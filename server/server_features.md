# Quy hoạch tính năng 

## Tính năng Agent 

1. Xây dựng được tính năng trả lời câu hỏi của ngừoi dùng liên quan tới thông tin thời trang ( cập nhật xu hướng thời trang hiện tạ, gợi ý phong cách thời trang phù hợp với các mô tả của ngừoi + query trong danh sách các mặt hàng để đưa ra gợi ý dành cho ngừoi dùng) 
2. Xây dựng các tính năng function calling : 
    - Tự động đặt hàng dựa trên prompt của ngừoi mua 
    - Cập nhật thông tin cá nhân ngừoi dùng 
    - Theo dõi lịch sử mua hàng của ngừoi dùng, quản lý thông tin đơn hàng 

## Tính năng thiết kế API  

- Thông tin ngừoi dùng 
    -> DB : tên đăng nhập + ttin cá nhân 
    -> Đăng kí + đăng nhập tài khoản 
    -> Lưu + chỉnh sửa thông tin cá nhân của người dùng 

- Agent : 
    -> DB : Lưu trữ cuộc trò chuyện trước đó + đặc điểm của ngừoi dùng 
    -> API tương tác với Agent 
    -> Agent thực hiện một số tool hệ thống 


- Shopping : 
    
    -> DB : 
        -> Lưu thông tin của từng sản phẩm (có thuộc tính category đề filter)
        -> Lưu thông tin của shopping cart 

    -> Chức năng : 
        -> Tìm kiếm + filter trên từng sản phẩm 
        -> Tích hợp tìm kiếm dựa trên embedding vector 
        -> CRUD trên shopping cart 


- Tủ đồ :  
    -> DB : 
        -> Lưu trử ảnh người dùng thêm vào (form người + quần áo có sẵn )
        -> Lưu trữ ảnh người dùng đã tạo trước đó + gợi ý quần áo cho ngừoi dùng + feedback của ngừoi dùng nếu cần thiết + quần áo tìm kiếm được 


- Fitting Room : 

    
=> Cần tìm phương pháp cải thiện mô hình với feedback của ngừoi dùng 


## Project structure 

1. Models : định nghĩa format của collection trong mongodb -> chuyển đổi format sang json 
2. Services -> các hàm xử lý logic cho mỗi API 
3. routers -> gọi tới các hàm services được định nghĩa trước với đường dẫn api  
4. schemas -> 


    
    
