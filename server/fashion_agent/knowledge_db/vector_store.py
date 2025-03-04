import os 
from dotenv import load_dotenv
from langchain_google_genai import GoogleGenerativeAIEmbeddings
import pandas as pd 
from langchain_chroma import Chroma


load_dotenv()
GEMINI_API_KEY = os.getenv("GOOGLE_APIKEY")


class KnowledgeDB: 
    """
    Class play as retrival knowledge from the database
    1. Thực hiện embedding dữ liệu từ nhiều nguồn khác nhau vào trong một vectordb 
    2. Thực hiện retrival dữ liệu từ vectordb
    3. Thực hiện update dữ liệu từ vectordb

    """
    def __init__(self):

    
        self.embedding_model = GoogleGenerativeAIEmbeddings(
            model = "text-embedding-001", 
            api_key = GEMINI_API_KEY
        )
        self.llm_model = GoogleGenerativeAIEmbeddings(
            model = "gemini-2.0-flash", 
            api_key = GEMINI_API_KEY
        ) 

        self.vector_directory = {
            "style": "style_vector_store",
            "news": "news_vector_store", 
            "product": "product_vector_store"
        }
        self.vector_store = {}
        self.vector_descriptoon = {
            "style": "Fashion styles, aesthetics, style guides, subcultures, categories of fashion", 
            "news": "Recent fashion news, trends, fashion weeks, brand updates, new collections, industry news", 
            "product": "Product vector store"
        }

        
    def update_or_create_vectorstore(self, directory: str, data: pd.DataFrame ): 
        """
        Hàm cập nhật hoặc tạo ra một vectorstore mới 
        """
        if directory not in self.vector_directory: 
            raise ValueError("Directory not found")
        
        directory = self.vector_directory[directory]
        os.mkdir(directory, exist_ok=True)

        if directory not in self.vector_store: 
            
            self.vector_store[directory].add_documents(data)
            self.vector_store[directory].persist()
        else: 
            self.vector_store[directory] = Chroma.from_documents(
                data, 
                embeddings = self.embedding_model, 
                persist_directory= directory
            )

    def retrieval(self, query, directory, top_k = 5): 
        """
        Hàm thực hiện retrieval dữ liệu từ vectorstore
        """

        if directory and directory in self.vector_directory: 
            return self.vector_directory[directory].similarity_search(query, top_k = top_k)
        elif directory is None:
            # timf kiem  tren toan bo vectorstore

            all_result = []
            for key, value in self.vector_directory.items(): 
                result = value.similarity_search(query, top_k = 3)
                all_result.append(result) 
            

            return all_result[:top_k]

        raise ValueError("Directory not found") 



    def routing(self, query): 
        """
        Ham lua chon db phu hop voi query 
        """


        category_descriptions = "\n".join([f"{key}: {value}" for key, value in self.vector_description.items()])
        self.routing_template = f"""
        I need you to classify the following user query into exactly one of these fashion knowledge categories:
        {category_descriptions}

        USER QUERY: "{query}"

        Respond with just the category name (e.g., "fashion_news", "fashion_styles", etc.) that best matches the query.
        If the query could fit multiple categories, choose the most relevant one. """

        
        if not self.vector_store: 
            raise ValueError("Vector store is empty")

        if len(self.vector_store) == 1:
            return list(self.vector_store.keys())[0], "Only one vector store available"

        try : 
            response = self.llm_model.invoke(self.routing_template)

            for i in self.vector_store.keys(): 
                if i in response: 
                    return i , None 


            return None, "No category found"
        except Exception as e:
            print(e)
            return None , "Error in routing"
        

if __name__ == '__main__':

    # test code 
    db = KnowledgeDB()
    print(db.vector_directory)
    print(db.vector_description)

    # test update_or_create_vectorstore
    query = "Summer fashion trends 2024"
    directory, message = db.routing(query)
    print(directory, message)

    result = db.retrieval(query, directory)




        


    