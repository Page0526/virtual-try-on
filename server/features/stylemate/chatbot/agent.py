import io
import os 
from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.memory import ConversationBufferMemory
from langchain.prompts import PromptTemplate
from langchain.chains.conversation.base import ConversationChain 
from langchain.agents import create_react_agent, AgentExecutor
from langchain_core.exceptions import OutputParserException
import sys
import os
import warnings
from PIL import Image 

warnings.filterwarnings("ignore")
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from knowledge_db.vector_store import KnowledgeDB
from tools.tools_implements import get_tools
from config.setting import settings
from prompt.prompt import PROMPT_TEMPLATE
from output_parser import CustomOutputParser
from tracker import IterationTracker
load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_APIKEY")

class StyleMate: 
    """
    Main class thực hiện kết nối đến model và infer câu hỏi của ngừoi dùng
    """

    def __init__(self):
        self.tools = get_tools()

        self.model = ChatGoogleGenerativeAI(
            model =  settings.GEMINI_MODEL, 
            temperature= 0.3, 
            api_key = GEMINI_API_KEY
        )

        self.memory = ConversationBufferMemory(
            return_messages=True, 
            memory_key = "chat_history", 
            input_key = "input",
            output_key = "output",  #
            k = settings.HISTORY_TOKEN_LIMIT,
        )

        self.knowledge_db = KnowledgeDB()
        self.output_parser = CustomOutputParser()
        try : 
            self.knowledge_db.loading_vector_store() 
        except FileNotFoundError:
            print("Style vector store not found, creating new one")

        self.prompt_template = PROMPT_TEMPLATE
        self.iteration_tracker = IterationTracker(max_iterations=settings.MAX_ITERATIONS)
        self.agent = create_react_agent(
            llm = self.model,
            tools = self.tools,
            prompt = self.prompt_template,
            output_parser = self.output_parser
        )

        self.agent_executor = AgentExecutor(
            agent = self.agent, 
            tools = self.tools, 
            memory = self.memory, 
            verbose = True, 
            handle_parsing_errors= True,
            max_iterations = settings.MAX_ITERATIONS,
            max_iterations_per_tool = 1,
            max_repeated_calls = 1,
            early_stopping_method= "force" ,
            max_iterations_error_message = "I've analyzed this as much as I can. Based on the information I have, here's my best answer: "
        ) 
    def _invoke_with_iteration_tracking(self, inputs):
        """Track iterations and inject signals for the last iteration."""
        self.iteration_tracker.reset()
        class AgentWrapper:
            def __init__(self, original_agent, tracker):
                self.original_agent = original_agent
                self.tracker = tracker
                
            def __call__(self, *args, **kwargs):
                

                self.tracker.increment()
                kwargs["iteration_count"] = self.tracker.iteration_count
                kwargs["max_iterations"] = self.tracker.max_iterations
                if self.tracker.is_last_iteration:
                    if "input" in kwargs:
                        kwargs["input"] = f"{kwargs['input']}\n\nITERATION_LIMIT_APPROACHING: This is your last chance to provide a final answer."
                return self.original_agent(*args, **kwargs)
    
            def __getattr__(self, name):
                return getattr(self.original_agent, name)

        original_agent = self.agent_executor.agent
        
        try:
            self.agent_executor.agent = AgentWrapper(original_agent, self.iteration_tracker)
            
            return self.agent_executor.invoke(inputs)
        finally:
            self.agent_executor.agent = original_agent
   


    def process_message(self, query: str, image: bytes = None):
        try:
            try:
                store_dir, = self.knowledge_db.routing(query)
                if store_dir is not None:
                    documents = self.knowledge_db.retrieval(query, store_dir)
                    if documents and len(documents) > 0:
                        context = "\n".join([f"{i+1}. {doc.page_content}" for i, doc in enumerate(documents)])
                        query = f"[CONTEXT] {context} \n\n [QUERY] {query}"
            except Exception as e:
                print(f"Error in knowledge retrieval: {e}")

            if image is not None:
                print("Image detected")
                image_obj = Image.open(io.BytesIO(image))
                
                try:
                    response = self.agent_executor.invoke({
                        "input": query,
                        "image": image_obj
                    })
                    return response.get("output", "Sorry, I couldn't process the image properly.")
                except OutputParserException as e:
                    print(f"Parser error in vision agent: {e}")
                    # Xử lý trực tiếp nội dung từ LLM
                    try:
                        # Lấy nội dung gốc từ lỗi
                        error_message = str(e)
                        if "Could not parse LLM output: `" in error_message:
                            direct_response = error_message.split("Could not parse LLM output: `")[1].split("`")[0]
                            return direct_response.strip()
                        else:
                            return "Sorry, I couldn't understand your query with the image."
                    except:
                        return "Sorry, I couldn't process the image properly."
                except Exception as e:
                    print(f"Error in vision agent: {e}")
                    return "Sorry, I couldn't process the image properly."
            else:
                try:
                    response = self._invoke_with_iteration_tracking({
                        "input": query
                    })
                    return response.get("output", "Sorry, I couldn't understand your query.")
                
                except OutputParserException as e:
                    print(f"Parser error in text agent: {e}")
                    try:
                        error_message = str(e)
                        if "Could not parse LLM output: `" in error_message:
                            direct_response = error_message.split("Could not parse LLM output: `")[1].split("`")[0]
                            return direct_response.strip()
                        else:
                            return "Sorry, I couldn't understand your query."
                    except:
                        return "Sorry, I couldn't understand your query."
                except Exception as e:
                    print(f"Error in text agent: {e}")
                    return "Sorry, I couldn't process your query."

        except Exception as e:
            print(f"Error in process message: {e}")
            return "Error in processing message"


    
    def chat_simulator(self): 
        """
        Hàm thực hiện chat với người dùng
        """
        print("Welcome to Fashion Agent")
        print("Type 'exit' to exit the chat")
        while True: 
            user_input = input("User: ")
            if user_input == "exit": 
                break

            response = self.process_message(user_input)
            print(f"Bot: {response}")

if __name__ == "__main__": 
    agent = StyleMate()
    agent.chat_simulator()
