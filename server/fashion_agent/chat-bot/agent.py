import os 
from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.memory import ConversationBufferMemory
from langchain.prompts import PromptTemplate
from langchain.chains.conversation.base import ConversationChain


load_dotenv()
GEMINI_API_KEY = os.getenv("GOOGLE_APIKEY")


class FashionAgent: 
    """
    Main class thực hiện kết nối đến model và infer câu hỏi của ngừoi dùng

    """

    def __init__(self, template_path: str):

    
        template = open(template_path, 'r')
        self.template = template.read()
        template.close()

        self.model = ChatGoogleGenerativeAI(
            model = "gemini-2.0-flash", 
            temperature= 0.7, 
            api_key = GEMINI_API_KEY
        )


        self.memory = ConversationBufferMemory(return_messages=True)


        self.conversation = ConversationChain(
            llm = self.model, 
            memory = self.memory, 
            prompt = PromptTemplate(self.template), 
            verbose = True
        )


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

            response = self.conversation(user_input)
            print(f"Bot: {response}")


    

if __name__ == "__main__": 
    agent = FashionAgent("templates/fashion_template.txt")
    agent.chat_simulator()


