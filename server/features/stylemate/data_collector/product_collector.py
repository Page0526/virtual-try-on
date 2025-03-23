import glob
import os
import requests
from bs4 import BeautifulSoup
import json
from time import sleep 
from tqdm import tqdm 
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import random



class ProductCollector:

    def __init__(self, page_number = 10): 

        self.page_number = page_number
        self.header = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
        }
        self.product_urls = []
        self.product_data = []
        self.driver = self._setup_selenium()

    def _setup_selenium(self):

        chrome_options = Options()
        chrome_options.add_argument("--headless")  
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument(f"user-agent={self.header['User-Agent']}")
        chrome_options.add_argument("--window-size=1920,1080")
        
        # Thiết lập và trả về WebDriver
        driver = webdriver.Chrome(
            service=Service(ChromeDriverManager().install()),
            options=chrome_options
        )
        return driver

    def url_crawling(self): 

        pre_url = "https://shop.harpersbazaar.com/clothing?category-1=sbz&category-2=clothing&fuzzy=0&operator=and&facets=category-1%2Ccategory-2%2Cfuzzy%2Coperator&sort=score_desc&page="

        for i in tqdm(range(self.page_number)): 
            url = pre_url + str(i)
            try : 
                html_content = self._get_html_with_selenium(url)
                if not html_content:
                    continue
               
                soup = BeautifulSoup(html_content, 'html.parser')
                main_div = soup.find('div', attrs = {'data-fs-product-listing-results': 'true'})

                for li in main_div.find_all('li'):
                    a_tag = li.find('a')
                    if a_tag and a_tag.has_attr('href'):
                        product_url = f"https://shop.harpersbazaar.com{a_tag['href']}"
                        self.product_urls.append(product_url)
                
            except Exception as e: 
                print("Error in url crawling: ", e)
                continue 

    def _get_html_with_selenium(self, url, wait_time=10):
        """Tải HTML của một trang web sử dụng Selenium"""
        try:
            # Truy cập URL
            self.driver.get(url)
            
            # Đợi trang web tải xong
            WebDriverWait(self.driver, wait_time).until(
                EC.presence_of_element_located((By.TAG_NAME, 'body'))
            )
            
            # Thêm một khoảng thời gian ngẫu nhiên để tránh bị phát hiện là bot
            sleep(random.uniform(1.5, 3.0))
            
            # Lấy HTML của trang
            html = self.driver.page_source
            return html
        except Exception as e:
            print(f"Error loading page with Selenium: {e}")
            return None

    def product_crawling(self) : 
        
        for url in self.product_urls:
            try : 
                html_content = self._get_html_with_selenium(url)
                if not html_content:
                    continue
                soup = BeautifulSoup(html_content, 'html.parser')
                title = soup.find('h1', {'data-fs-product-name': 'true'}).text
                price = soup.find('span', {'data-fs-price': 'true'}).get_text()
                description = soup.find('div', {'class': 'RenderHtmlStyling_CustomRenderHtmlStyling__1eC6V'}).get_text()
                brand = soup.find('p', {'data-fs-brand': 'true'}).text
            
                inst_data = {
                    "title": title,
                    "brand": brand,
                    "price": price,
                    "description": description, 
                    "url": url
                }
                self.product_data.append(inst_data)

            except Exception as e: 
                print("Error in product crawling: ", e)
                continue
        
    

    def save(self, filename, is_product = False): 
        if not self.product_urls: 
            raise ValueError("No data to save")
        data = self.product_data if is_product else self.product_urls
            
        with open(filename, 'w') as f:
            json.dump(data, f, indent=4, ensure_ascii=False)

        print("Data path saved successfully")



    def run(self): 
        if not os.path.exists('raw-data'): 
            os.makedirs('data')

        product_url_file = glob.glob('raw-data/product_urls*.json')

        if not product_url_file: 
            self.url_crawling()
            self.save('raw-data/product_urls.json', is_product=False)
            
        else: 
            with open(product_url_file[0], 'r') as f: 
                self.product_urls = json.load(f)


        self.product_crawling()
        self.save('raw-data/product_data.json', is_product=True)
        print("Product data saved successfully")



if __name__ == '__main__':
    pc = ProductCollector()
    pc.run()

