from bs4 import BeautifulSoup
import requests as req 
from pathlib import Path
from tqdm import tqdm 
import json 



class StylingCollector: 
    """
    Class crawl từ trang web 70 styling 

    """
    def __init__(self, url: str, output_dir: str): 
        self.url = url 
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)

        self.header = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
        }

        self.data = {}


    def get_page_content(self): 
        try: 
            response = req.get(self.url, headers = self.header)
            response.raise_for_status()
            return response.text

        except Exception as e:
            print(f"Error: {e}")



    def extract_data(self, html_content):

        if not html_content: 
            return None

        soup = BeautifulSoup(html_content, "html.parser")

        for id in tqdm(range(1, 108)): 
            heading = soup.find('h2', id = str(id)) 
            if not heading: continue
            
            style_name = heading.get_text(strip = True) 

            if not style_name: continue 

            contents = []
            current = heading.next_sibling

            while current and (not isinstance(current, type(heading)) or 'id' not in current.attrs): 
                if current.name == 'p': 
                    text = current.get_text(strip = True)
                    if text: 
                        contents.append(text)

                current = current.next_sibling

            style_content = "\n\n".join(contents)
            if style_content:
                # handling 
                style_content = style_content.replace(';', ';\n')
                style_content = style_content.replace("\\n", '\n').replace("\\r", '')
                self.data[style_name] = style_content

            else: 
                print(f"Error: {style_name}")



    def save_data_original(self):
        # luu data vao file json 
        output_file = self.output_dir / "styling_data.json"

        with open(output_file, 'w') as f: 
            json.dump(self.data, f, ensure_ascii=False, indent=2) 

    def save_data_jsonformat(self): 
        # luu data vao file json 
        output_file = self.output_dir / "styling_data_vs.json"
        docs = []
        for key, value in self.data.items(): 
            doc = {
                "style_name": key, 
                "style_content": value, 
                "type": "style", 
            }
            docs.append(doc)

        with open(output_file, 'w', encoding = "utf-8") as f: 
            json.dump(docs, f, ensure_ascii=False, indent=2)


        return docs 

    def crawling_data(self): 

        html_content = self.get_page_content()
        self.extract_data(html_content)
        self.save_data_original()


if __name__ == "__main__":
    url = "https://www.panaprium.com/blogs/i/fashion-styles?srsltid=AfmBOopa2__P80t7XV27mlUlfdW-KgH4IdY7Qu2oQxme2c0mhQj4hLTU"
    output_dir = "raw-data"
    collector = StylingCollector(url, output_dir)
    collector.crawling_data()
    collector.save_data_jsonformat()


    


