## Chạy code sau để cài đặt 

- Install trước npm 

```
cd client 
npm install 

npx expo start --clear # lenhj de chay , tai app ve xong quet qr nhe or dung duoc tren app

```


## Cấu trúc dự án
```

virtual-try-on/client/
├── app/                        
│   ├── _layout.tsx             # Root layout wrapper for all screens
│   ├── index.tsx               # page đầu tiên 
│   ├── landing_page.tsx        # landing page 
│   ├── (auth)/                 # Thông tin (đăng kí + đăng nhập + thông tin tài khoản ngừoi dùng)
│   │   ├── login.tsx           # Login screen (/login)
│   │   ├── register.tsx        # Registration screen (/register)
│   │   └── profile.tsx         # User profile screen (/profile)
│   ├── (tabs)/                 # Tab navigation group (doesn't affect URL path)
│   │   └── bottom_tab.tsx      # Bottom tab navigation (/bottom_tab)
│   ├── fitting_room/           # Virtual fitting room feature (URL: /fitting_room/...)
│   │   ├── input.tsx           # màn input nhập thông tin ảnh của ngừoi dùng 
│   │   ├── output.tsx          # màn trả về output của model 
│   │   └── closet.tsx          # màn lưu thông tin tủ đồ người dùng
│   ├── shop/                   # Shopping related screens (URL: /shop/...)
│   │   ├── cart.tsx            # Shopping cart screen (/shop/cart)
│   │   └── ...
│   └── stylemate/              # Style recommendation feature (URL: /stylemate/...)
│
├── assets/                     # Static assets for the application
│   ├── fonts/                  # Custom fonts
│   └── images/                 # Images and icons
│
├── components/                 # Reusable UI components
│
├── constants/                  # Application constants
    └── Colors.ts               # Color definition
```