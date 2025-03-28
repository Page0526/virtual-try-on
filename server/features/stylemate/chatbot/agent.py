import io
import os 
from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.memory import ConversationBufferMemory
from langchain.prompts import PromptTemplate
from langchain.chains.conversation.base import ConversationChain 
from langchain.agents import create_react_agent, AgentExecutor
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
            temperature= 0.7, 
            api_key = GEMINI_API_KEY
        )

        self.memory = ConversationBufferMemory(
            return_messages=True, 
            memory_key = "chat_history", 
            input_key = "input",
            output_key = "response", 
            k = settings.HISTORY_TOKEN_LIMIT,
        )

        self.knowledge_db = KnowledgeDB()

        try : 
            self.knowledge_db.loading_vector_store() 
        except FileNotFoundError:
            print("Style vector store not found, creating new one")

        self.prompt_template = PROMPT_TEMPLATE

        self.agent = create_react_agent(
            llm = self.model,
            tools = self.tools,
            prompt = self.prompt_template,
        )

        self.agent_executor = AgentExecutor(
            agent = self.agent, 
            tools = self.tools, 
            memory = self.memory, 
            verbose = True, 
            handling_parsing_errors = True,
            max_iterations = 8 ,
            max_iterations_per_tool = 2,
            early_stopping_method= "generate"
        ) 

    def process_message(self, query: str, image: bytes = None): 
        try : 
            try: 
                store_dir, = self.knowledge_db.routing(query)
                if store_dir is not None : 
                    documents = self.knowledge_db.retrieval(query, store_dir)
                    if documents and len(documents) > 0: 
                        context = "\n".join([f"{i+1}. {doc.page_content}" for i, doc in enumerate(documents)])
                        query = f"[CONTEXT] {context} \n\n [QUERY] {query}"
            except Exception as e : 
                print(f"Error in knowledge retrieval: {e}")

            if image is not None:
                print("Image detected")
                image_obj = Image.open(io.BytesIO(image))
                
                try : 
                    response = self.agent_executor.invoke({
                        "input": query,
                        "image": image_obj
                    })
                    return response.get("output", "Sorry, I couldn't process the image properly.")
                except Exception as e:
                    print(f"Error in vision agent: {e}")
                    return "Sorry, I couldn't process the image properly."
            else:
                try : 
                # Text-only query
                    response = self.agent_executor.invoke({
                        "input": query
                    })
                except Exception as e:
                    print(f"Error in text agent: {e}")
                    return "Sorry, I couldn't process your query."
                return response.get("output", "Sorry, I couldn't understand your query.")

        except Exception as e:
            print(f"Error in process message: {e}")
            return "Error in processing message"    

    def get_response(self, query: str, image: bytes = None): 
        try: 
            store_dir, _ = self.knowledge_db.routing(query)
            if store_dir is None: 
                response = self.conversation({"input": query})
                return response['response']
            
            try: 
                documents = self.knowledge_db.retrieval(query, store_dir)
                if not documents or len(documents) == 0: 
                    response = self.conversation({"input": query})
                    return response['response']
                
                context = "\n".join([f"{i+1}. {doc.page_content}" for i, doc in enumerate(documents)])

                prompt = self.qa_template.format(
                    context = context,
                    chat_history = self.memory.load_memory_variables({})["chat_history"],
                    question = query
                )
                response = self.model.invoke(prompt)
                
                self.memory.save_context({"input": query}, {"response": response.content})
                return response.content
            
            except Exception as e: 
                print(f"Error in retrieval: {e}")
                return "Error in retrieval"
        except Exception as e:
            print(f"Error in routing (get response function): {e}")
            return "Error in routing (get response function)"

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
