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


from server.features.stylemate.tools.tools_implements import get_tools
from server.config.setting import settings
from server.features.stylemate.prompt import PROMPT_TEMPLATE


warnings.filterwarnings("ignore")
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from knowledge_db.vector_store import KnowledgeDB

load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_APIKEY")

class StyleMate: 
    """
    Main class thực hiện kết nối đến model và infer câu hỏi của ngừoi dùng

    """

    def __init__(self):
        self.tools = get_tools()


        self.text_model = ChatGoogleGenerativeAI(
            model =  settings.GEMINI_MODEL, 
            temperature= 0.7, 
            api_key = GEMINI_API_KEY
        )

        self.vision_model = ChatGoogleGenerativeAI(
            model = settings.VISION_GEMINI, 
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
            llm = self.text_model,
            tools = self.tools,
            prompt = self.prompt_template,
            verbose = True,
            memory = self.memory

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



    def get_response(self, query: str): 

        
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
                print(e)
                return "Error in retrieval"
        except Exception as e:
            print(e)
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

            response = self.get_response(user_input)
            print(f"Bot: {response}")


    

if __name__ == "__main__": 
    agent = StyleMate()
    agent.chat_simulator()


