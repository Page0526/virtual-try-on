import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/navigation_bar.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  int _selectedSubIndex = 0; // Theo dõi tab Closet/Outfit/Packing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tủ Quần Áo Số'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Sub-taskbar (Closet/Outfit/Packing)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSubTab('Closet', 0),
                _buildSubTab('Outfit', 1),
                _buildSubTab('Packing', 2),
              ],
            ),
          ),
          // Nội dung chính
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 1, // "Closet" đang được chọn
        onItemTapped: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              // Đã ở Closet, không cần thay đổi
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Thêm logic để mở màn hình thêm mới (Closet/Outfit/Packing)
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSubTab(String title, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSubIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _selectedSubIndex == index ? Colors.black : Colors.grey,
              fontWeight: _selectedSubIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (_selectedSubIndex == index)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 2.0,
              width: 40.0,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedSubIndex) {
      case 0:
        return ClosetContent(
          onClosetTapped: (closetName) {
            context.go('/closet/$closetName');
          },
          onEditPressed: () {},
          onArchivePressed: () {},
          onQuickReviewPressed: () {},
        );
      case 1:
        return const Center(child: Text('Outfit content coming soon'));
      case 2:
        return const Center(child: Text('Packing content coming soon'));
      default:
        return Container();
    }
  }
}

// Widget hiển thị nội dung Closet
class ClosetContent extends StatelessWidget {
  final Function(String) onClosetTapped;
  final VoidCallback onEditPressed;
  final VoidCallback onArchivePressed;
  final VoidCallback onQuickReviewPressed;

  const ClosetContent({
    super.key,
    required this.onClosetTapped,
    required this.onEditPressed,
    required this.onArchivePressed,
    required this.onQuickReviewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Danh sách Closet
          Expanded(
            child: ListView(
              children: [
                // Mục "All clothes"
                _buildClosetItem(
                  imageUrl: 'assets/images/image1.jpg', // Ảnh giả lập
                  title: 'All clothes',
                  count: '1 clothes',
                  onEditPressed: onEditPressed,
                  onTap: () => onClosetTapped('All clothes'), // Điều hướng khi nhấn
                ),
                // Nút tạo Closet mới
                _buildCreateCloset(),
              ],
            ),
          ),
          // Nút Archive và Quick Review
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: onArchivePressed,
                  icon: const Icon(Icons.archive),
                  label: const Text('Archive'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: onQuickReviewPressed,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Quick Closet Review'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosetItem({
    required String imageUrl,
    required String title,
    required String count,
    required VoidCallback onEditPressed,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap, // Bắt sự kiện nhấn để điều hướng
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh món đồ
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            // Thông tin
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(count, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            // Nút Edit
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: onEditPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateCloset() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          // Logic thêm Closet mới
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.grey),
              const SizedBox(width: 8.0),
              const Text('Create a closet', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}