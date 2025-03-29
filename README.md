<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Page0526/virtual-try-on">
    <img src="client/assets/images/dress-logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">EasyFit</h3>

  <p align="center">
    An awesome virtual try-on app built with React Native (Expo)!
    <br />
    <br />
    <a href="https://github.com/Page0526/virtual-try-on">View Demo</a>
    &middot;
    <a href="https://github.com/Page0526/virtual-try-on/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/Page0526/virtual-try-on/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project
<div align='center'>
  <img src="client/assets/images/banner.png" width="500">
</div>

Người tiêu dùng gặp khó khăn trong việc hình dung sản phẩm thực tế khi mua sắm thời trang online. Việc lựa chọn trang phục phù hợp không chỉ dựa vào sở thích mà còn phải xét đến các yếu tố như vóc dáng, phong cách cá nhân và khả năng kết hợp với các món đồ khác. Một lựa chọn phù hợp không chỉ giúp giảm tỷ lệ đổi trả mà còn góp phần tăng doanh số bán hàng. EasyFit ra đời nhằm cung cấp một giải pháp toàn diện giúp nâng cao trải nghiệm mua sắm trực tuyến thông qua các tính năng: 
- Phòng thử đồ ảo, cho phép người dùng thử trang phục trên ảnh cá nhân nhờ công nghệ AI mô phỏng chân thực
- Gợi ý trang phục phù hợp, đưa ra đề xuất sản phẩm dựa trên phong cách thời trang, màu sắc và trang phục hiện có
- Tích hợp mua sắm, giúp người dùng dễ dàng đặt hàng qua các sàn thương mại điện tử sau khi thử đồ
- StyleMate, trợ lý ảo AI cung cấp thông tin về xu hướng thời trang, gợi ý cách phối đồ và tối ưu hóa trải nghiệm mua sắm.

Với những tính năng này, EasyFit không chỉ mang đến trải nghiệm trực quan hơn mà còn tối ưu hóa quy trình từ thử đồ đến mua hàng, giúp người dùng thuận tiện hơn và giảm rủi ro khi mua sắm trực tuyến. 🚀

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* [![React Native](https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)](#)
* [![Expo](https://img.shields.io/badge/Expo-000020?style=for-the-badge&logo=expo&logoColor=white)](#)
* [![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](#)
* [![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=fff)](#)
* [![FastAPI](https://img.shields.io/badge/FastAPI-009485?style=for-the-badge&logo=fastapi&logoColor=white)](#)
* [![Google Gemini](https://img.shields.io/badge/Google%20Gemini-886FBF?style=for-the-badge&logo=googlegemini&logoColor=fff)](#)
* [![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](#) 
<!-- MongoDB seems incorrect based on code, replaced with Supabase -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

*   Node.js and npm/yarn
*   Expo CLI (`npm install -g expo-cli`)
*   Python 3.10+ and pip
*   Conda (optional, for managing Python environments)
*   Git

### Installation

**Backend (Server):**

1.  Clone the repo:
    ```sh
    git clone https://github.com/Page0526/virtual-try-on.git
    cd virtual-try-on
    ```
2.  Navigate to the server directory:
    ```sh
    cd server
    ```
3.  Create and activate a Python environment (using Conda):
    ```sh
    conda create --name easyfit-env python=3.10
    conda activate easyfit-env 
    ```
    (Or use `python -m venv venv` and `source venv/bin/activate` / `venv\Scripts\activate`)
4.  Install Python dependencies:
    ```sh
    pip install -r requirements.txt
    ```
5.  Set up environment variables (e.g., Supabase keys, Google API key). You might need a `.env` file in the `server` directory. Refer to `server/config/setting.py`.
    ```dotenv
    # Example .env content (replace with actual values)
    SUPABASE_URL=YOUR_SUPABASE_URL
    SUPABASE_KEY=YOUR_SUPABASE_ANON_KEY 
    # Add other required keys (like Google API Key if needed by backend features)
    ```
6.  Run the FastAPI server:
    ```sh
    uvicorn main:app --reload --host 0.0.0.0 --port 8000 
    ``` 
    (Ensure you are in the `server` directory)

**Frontend (Client):**

1.  Navigate to the client directory (from the project root):
    ```sh
    cd ../client 
    ```
2.  Install Node.js dependencies:
    ```sh
    npm install 
    ```
    (or `yarn install`)
3.  Set up environment variables for the client if needed (e.g., Clerk keys). Refer to the code using `process.env`. You might need a `.env` file in the `client` directory.
    ```dotenv
    # Example .env content (replace with actual values if used)
    EXPO_PUBLIC_CLERK_PUBLISHABLE_KEY=YOUR_CLERK_KEY 
    ```
4.  Start the Expo development server:
    ```sh
    npx expo start
    ```
5.  Follow the instructions in the terminal to open the app on a simulator/emulator or physical device using the Expo Go app.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Get to the try-on screen and start try on whatever clothes you want!
<div align='center'>
  <img src="client/assets/images/try-on-screen.png" width="400">
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/Page0526/virtual-try-on/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Top contributors:

<a href="https://github.com/Page0526/virtual-try-on/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Page0526/virtual-try-on" alt="contrib.rocks image" />
</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
[contributors-shield]: https://img.shields.io/github/contributors/Page0526/virtual-try-on.svg?style=for-the-badge
[contributors-url]: https://github.com/Page0526/virtual-try-on/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Page0526/virtual-try-on.svg?style=for-the-badge
[forks-url]: https://github.com/Page0526/virtual-try-on/network/members
[stars-shield]: https://img.shields.io/github/stars/Page0526/virtual-try-on.svg?style=for-the-badge
[stars-url]: https://github.com/Page0526/virtual-try-on/stargazers
[issues-shield]: https://img.shields.io/github/issues/Page0526/virtual-try-on.svg?style=for-the-badge
[issues-url]: https://github.com/Page0526/virtual-try-on/issues




<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
