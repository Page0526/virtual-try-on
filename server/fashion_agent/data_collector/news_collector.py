import json
from time import sleep
from typing import List
import requests
from bs4 import BeautifulSoup
import pandas as pd
from time import sleep
from datetime import datetime
from tqdm import tqdm
import os
import glob




class NewsCollector:
    def __init__(self): 
        self.article_urls = []
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
        }
        self.article_data = []
        


    def run(self):
        pass

    def url_crawling(self):
        pass

    def article_crawling(self):
        pass


    def save_path(self, filename: str):
        pass

    def save_data(self, filename: str):
        pass

class VougeCollector(NewsCollector): 
    def __init__(self, subnames: List):
        self.urls = [ "https://www.vogue.com/fashion/" + subname for subname in subnames]


    def url_crawling(self):

        self.article_urls = []
        for url in tqdm(self.urls): 
            try: 
                print(url)
                response = requests.get(url, headers = self.headers)
                print(response.status_code)
                if response.status_code != 200: 
                    raise ValueError("Cannot get the page")

                soup = BeautifulSoup(response.content, 'html.parser')
                main_div = soup.find("div", class_ = "CarouselListWrapper-jhefUk Rvfhx")

                if main_div is None:
                    raise ValueError("Cannot find the main div")
                
                ul_element = main_div.find('ul')
                if ul_element is None: 
                    raise ValueError("Cannot find the ul element")

                li_elements = ul_element.find_all('li')
                if li_elements is None: 
                    raise ValueError("Cannot find the li elements")
                
                for li in li_elements: 
                    a_tag = li.find('a', href = True)
                    href = a_tag.get('href')
                    full_href = f"https://www.vogue.com{href}"
                    self.article_urls.append(full_href)

            except Exception as e:
                print(e)


    def article_crawling(self):
        self.articles_data = []

        for idx, url in tqdm(enumerate(self.article_urls)): 
            try: 
                sleep(20)
                response = requests.get(url, headers = self.headers)
                if response.status_code != 200: 
                    raise ValueError("Cannot get the page")

                soup = BeautifulSoup(response.content, 'html.parser')
                title = soup.find('h1', attrs = {'data-testid' : 'ContentHeaderHed'}).text
                print(title)
                time = soup.find('time', attrs  = {'data-testid' :'ContentHeaderPublishDate'}).text

                content_data = soup.find("div", class_ = "body__inner-container")
              
                if content_data: 
                    # Extract all text content from inst_data, not just paragraphs
                    content = content_data.get_text(separator='\n\n', strip=True)
                    print(content)
                    if not content: 
                        raise ValueError("Cannot find the content")

                    pass 

                else : 
                    raise ValueError("Cannot find the article data")
                
                inst_data = {
                    "title": title, 
                    "time": time, 
                    "content": content
                }

                self.article_data.append(inst_data)


            except Exception as e: 
                print(e)
                continue


    def save_path(self, filename: str): 
        if not self.article_urls: 
            raise ValueError("No data to save")
        
        timestamp = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        filename = f"{filename}_{timestamp}.json"
        with open(filename, 'w') as f: 
            json.dump(self.article_urls, f, ensure_ascii=False, indent=2)
        
        print(f"Data saved to {filename}")



    def save_data(self, filename: str):
                
        if not self.article_data: 
            raise ValueError("No data to save")
        
        timestamp = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        filename = f"{filename}_{timestamp}.json"
        with open(filename, 'w') as f: 
            json.dump(self.article_data, f, ensure_ascii=False, indent=2)
        
        print(f"Data saved to {filename}")

    
    def run(self):
        
        # Check if the raw-data directory exists, create it if not
        if not os.path.exists("raw-data"):
            os.makedirs("raw-data")
        
        # Check for files matching the pattern
        vogue_url_files = glob.glob("raw-data/vogue_url*.json")
        
        if not vogue_url_files:
            self.url_crawling()
            self.save_path("raw-data/vogue_url")
        else: 
            with open(vogue_url_files[-1], 'r') as f: 
                self.article_urls = json.load(f)
        self.article_crawling()
        self.save_data("vogue_data")


class ElleCollector(NewsCollector): 

    def __init__(self): 
        self.url = "https://www.elle.com/fashion/"
        self.article_urls = []
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
        }
        self.article_data = []


    def run(self): 
          # Check if the raw-data directory exists, create it if not
        if not os.path.exists("raw-data"):
            os.makedirs("raw-data")
        
        # Check for files matching the pattern
        elle_url_files = glob.glob("raw-data/elle_url*.json")
        
        if not elle_url_files:
            self.url_crawling()
            self.save_path("raw-data/elle_url")
        else: 
            with open(elle_url_files[-1], 'r') as f: 
                self.article_urls = json.load(f)
        self.article_crawling()
        self.save_data("elle_data")



        pass 

    def url_crawling(self): 
        self.article_urls = []

        try:
            response = requests.get(self.url, headers = self.headers)
            if response.status_code != 200: 
                raise ValueError("Cannot get the page")

            soup = BeautifulSoup(response.content, 'html.parser')
            main_div = soup.find_all("div", attrs = {'data-theme-key' : 'block-column'})
            
            if not main_div:
                raise ValueError("Cannot find the main divs")
            
            for div in main_div:
                a_tags = div.find_all('a', href=True)
                for a_tag in a_tags:
                    href = a_tag.get('href')
                    # Check if URL is relative or absolute
                    if href.startswith('/'):
                        full_href = f"https://www.elle.com{href}"
                    elif not href.startswith('http'):
                        full_href = f"https://www.elle.com/{href}"
                    else:
                        full_href = href
                    self.article_urls.append(full_href)
        
        except Exception as e:
            print(f"Error in url_crawling: {e}")


    def article_crawling(self):
        self.article_data = []

        for idx, url in tqdm(enumerate(self.article_urls)):
            try:
                sleep(10)
                response = requests.get(url, headers = self.headers)
                if response.status_code != 200:
                    raise ValueError("Cannot get the page")

                soup = BeautifulSoup(response.content, 'html.parser')
                title = soup.find('h1').get_text(separator='\n', strip =True)
                
                time = soup.find("time").text
                
                content_data = soup.find("div", attrs = {"data-journey-body" : "standard-article"})
                
                if content_data:
                    all_content = []
                    for tag_name in ['em', 'a', 'p']:
                        tags = content_data.find_all(tag_name)
                        for tag in tags:
                            text = tag.get_text(strip=True)
                            if text: 
                                all_content.append(text)
                    
                    content = '\n\n'.join(all_content)
                    
                    if not content:
                        raise ValueError("No content found in em, a, and p tags")
                else:
                    content_data = soup.find_all("p", attrs = {"data-journey-content" : "true"})
                    if content_data:
                        content = '\n\n'.join([p.get_text(strip=True) for p in content_data])
                    else:
                        raise ValueError("Cannot find the content data")
                   
                    
        
                inst_data = {
                    "title": title,
                    "time": time,
                    "content": content
                }
                
                self.article_data.append(inst_data)
                
            except Exception as e:
                print(f"Error processing {url}: {e}")


    def save_path(self, filename: str):
        if not self.article_urls: 
            raise ValueError("No data to save")
        
        timestamp = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        filename = f"{filename}_{timestamp}.json"
        with open(filename, 'w') as f: 
            json.dump(self.article_urls, f, ensure_ascii=False, indent=2)
        
        print(f"Data saved to {filename}")


    def save_data(self, filename: str):
        if not self.article_data: 
            raise ValueError("No data to save")
        
        timestamp = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        filename = f"{filename}_{timestamp}.json"
        with open(filename, 'w') as f: 
            json.dump(self.article_data, f, ensure_ascii=False, indent=2)
        
        print(f"Data saved to {filename}")
        






if __name__ == "__main__": 
    # subnames = ["celebrity-style", "street-style", "models", "designers", "trends"]
    collector = ElleCollector()
    collector.run()





    