import os 
from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.memory import ConversationBufferMemory
from langchain.prompts import PromptTemplate
from langchain.chains.conversation.base import ConversationChain 
import sys
import os
import warnings

warnings.filterwarnings("ignore")
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from knowledge_db.vector_store import KnowledgeDB

load_dotenv()
GEMINI_API_KEY = os.getenv("GOOGLE_APIKEY")


class FashionAgent: 
    """
    Main class thực hiện kết nối đến model và infer câu hỏi của ngừoi dùng

    """

    def __init__(self):


        self.model = ChatGoogleGenerativeAI(
            model = "gemini-2.0-flash", 
            temperature= 0.7, 
            api_key = GEMINI_API_KEY
        )


        self.memory = ConversationBufferMemory(
            return_messages=True, 
            memory_key = "chat_history", 
            input_key = "input",
            output_key = "response"
        )

        self.knowledge_db = KnowledgeDB()

        try : 
            self.knowledge_db.loading_vector_store() 
        except FileNotFoundError:
            print("Style vector store not found, creating new one")

        self.qa_template = """
            You are a fashion expert assistant providing accurate information based on the retrieved context.
            Some rules you must follow:
                1. Focus on topics related to fashion
                2. If users ask about topics unrelated to fashion, politely decline and guide them back to fashion topics
                3. Provide specific and practical advice
                4. When possible, provide illustrative examples
                5. Use friendly and accessible language
            
            Context information is below:
            ---------------------
            {context}
            ---------------------
            
            Given this context, please answer the question. If the answer is not found in the context, 
            say that you don't have information about that specific topic but provide relevant fashion advice 
            based on your general knowledge.
            
            Chat History:
            {chat_history}
            
            Question: {question}
            Answer:
        """

        self.regular_template = """
            You are a friendly, professional, and experienced fashion expert.
            Your task is to provide information, advice on fashion trends, outfit coordination,
            and related fashion knowledge.

            Some rules you must follow:
            1. Focus on topics related to fashion
            2. If users ask about topics unrelated to fashion, politely decline and guide them back to fashion topics
            3. Provide specific and practical advice
            4. When possible, provide illustrative examples
            5. Use friendly and accessible language

            Conversation history:
            {chat_history}

            Latest question: {input}
            Your response:
        """

        self.conversation = ConversationChain(
            llm = self.model, 
            memory = self.memory, 
            prompt = PromptTemplate(
            template = self.regular_template,
            input_variables=["chat_history", "input"]
            ), 
            verbose = True
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
                    esponse = self.conversation({"input": query})
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
    agent = FashionAgent()
    agent.chat_simulator()


