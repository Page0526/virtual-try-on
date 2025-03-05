import os 
from dotenv import load_dotenv
from langchain_google_genai import GoogleGenerativeAIEmbeddings, ChatGoogleGenerativeAI
import pandas as pd 
from langchain_community.vectorstores.chroma import Chroma
import json
from langchain_core.documents import Document
from typing import Dict


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
            model = "models/embedding-001", 
            google_api_key = GEMINI_API_KEY
        )
        self.llm_model = ChatGoogleGenerativeAI(
            model = "gemini-2.0-flash", 
            api_key = GEMINI_API_KEY
        ) 

        self.vector_directory = {
            "style": "style_vector_store",
            "news": "news_vector_store", 
            "product": "product_vector_store"
        }
        self.vector_store: Dict[str, Chroma] = {}
        self.vector_description = {
            "style": "Fashion styles, aesthetics, style guides, subcultures, categories of fashion", 
            "news": "Recent fashion news, trends, fashion weeks, brand updates, new collections, industry news", 
            "product": "Product vector store"
        }

        
    def update_or_create_vectorstore(self, directory: str, data: pd.DataFrame):
    
        if directory not in self.vector_directory:
            raise ValueError(f"Directory '{directory}' not found in available directories: {list(self.vector_directory.keys())}")
        
        persist_dir = self.vector_directory[directory]
        os.makedirs(persist_dir, exist_ok=True)
        
        if 'content' not in data.columns and 'style_content' not in data.columns:
            raise ValueError("DataFrame must contain a 'content' or 'text' column for embedding")
        
        
        documents = []
        text_col = 'content' if 'content' in data.columns else 'style_content'
        
        for _, row in data.iterrows():
            text = row[text_col]
            metadata = {col: row[col] for col in data.columns if col != text_col}
            doc = Document(page_content=text, metadata=metadata)
            documents.append(doc)
        
        if persist_dir in self.vector_store:
            self.vector_store[directory].add_documents(documents)
        else:
            self.vector_store[directory] = Chroma.from_documents(
            documents,
            embedding=self.embedding_model,
            persist_directory=persist_dir
            )
        
        # Ensure the vector store is persisted to disk
        self.vector_store[directory].persist()
        print(f"Vector store successfully saved to {persist_dir}")

    def retrieval(self, query, directory, top_k = 5): 
        """
        Hàm thực hiện retrieval dữ liệu từ vectorstore
        """

        if directory and directory in self.vector_directory: 
            
            return self.vector_store[directory].similarity_search(query, k=top_k)
        
        elif directory is None:
            # timf kiem  tren toan bo vectorstore
            all_result = []
            for key, value in self.vector_directory.items(): 
                result = value.similarity_search(query, k = 3)
                all_result.append(result) 
            

            return all_result[:top_k]
        raise ValueError("Directory not found") 



    def routing(self, query): 
        """
        Ham lua chon db phu hop voi query 
        """


        category_descriptions = "\n".join([f"{key}: {value}" for key, value in self.vector_description.items()])
        self.routing_template = f"""
        I need you to classify the following user query into one of these fashion knowledge categories:
        {category_descriptions}

        USER QUERY: "{query}"

        Respond with just the category name (e.g., "news", "style", etc.) that best matches the query.
        If the query could fit multiple categories, choose the most relevant one.
        If the query doesn't match any of these categories, respond with only "None". """

        
        if not self.vector_store: 
            raise ValueError("Vector store is empty")

        if len(self.vector_store) == 1:
            return list(self.vector_store.keys())[0], "Only one vector store available"

        try : 
            response = self.llm_model.invoke(self.routing_template)
            for i in self.vector_directory.keys(): 
                if i in response.content.lower(): 
                    return i , None 


            return None, "No category found"
        except Exception as e:
            print(e)
            return None , "Error in routing"
        

    def loading_vector_store(self): 
        """
        Hàm thực hiện load vector store từ disk
        """
        try:
            with open("../data_collector/raw-data/elle_data.json", "r", encoding="utf-8") as f:
                elle_data = json.load(f)
            
            with open("../data_collector/raw-data/vogue_data.json", "r", encoding="utf-8") as f:
                vogue_data = json.load(f)
            
            combined_data = elle_data + vogue_data
            df = pd.DataFrame(combined_data)
            
            self.update_or_create_vectorstore("news", df)
            print("News vector store created")

            with open("../data_collector/raw-data/styling_data_vs.json", "r", encoding="utf-8") as f:
                styling_data = json.load(f)
            df = pd.DataFrame(styling_data)
            self.update_or_create_vectorstore("style", df)
        
            print("Style vector store created")
        
        
        except FileNotFoundError as e:
            print(f"Error: {e}")
        except json.JSONDecodeError as e:
            print(f"JSON parsing error: {e}")

        

if __name__ == '__main__':

    # test code 
    db = KnowledgeDB()


    try:
        with open("../data_collector/raw-data/elle_data.json", "r", encoding="utf-8") as f:
            elle_data = json.load(f)
        
        with open("../data_collector/raw-data/vogue_data.json", "r", encoding="utf-8") as f:
            vogue_data = json.load(f)
        
        combined_data = elle_data + vogue_data
        df = pd.DataFrame(combined_data)
        
        db.update_or_create_vectorstore("news", df)
        print("News vector store created")

        with open("../data_collector/raw-data/styling_data_vs.json", "r", encoding="utf-8") as f:
            styling_data = json.load(f)
        df = pd.DataFrame(styling_data)
        db.update_or_create_vectorstore("style", df)
        print("Style vector store created")
        
        
    except FileNotFoundError as e:
        print(f"Error: {e}")
    except json.JSONDecodeError as e:
        print(f"JSON parsing error: {e}")
    




        


    