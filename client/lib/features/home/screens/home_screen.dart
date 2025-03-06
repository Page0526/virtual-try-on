import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/common/widgets/recent_outfit_slider.dart';
import 'package:myapp/features/routes/routes.dart';
import 'package:myapp/utils/const/path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/user.jpg'),
              radius: 22,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xin chào, Tuoc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Hà Nội, VN',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần thời tiết
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent.withOpacity(0.1), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trời Nắng',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Text(
                          '22°C',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny, color: Colors.orange, size: 32),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Hôm Nay',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            const Text(
                              '15/03',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Phần Recent Outfits
              const Text(
                'Trang Phục Gần Đây',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              RecentOutfitSlider(banners: [CusPath.banner1, CusPath.banner2, CusPath.banner3]),
              const SizedBox(height: 24),
              // Phần News
              const Text(
                'Tin Tức Thời Trang',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildOutfitCard(
                      imageUrl: 'assets/images/image2.jpg',
                      title: 'Phong Cách Thứ Sáu',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOutfitCard(
                      imageUrl: 'assets/images/image2.jpg',
                      title: 'Cuộc Họp Công Việc',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Phần Quick Actions
              const Text(
                'Hành Động Nhanh',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildQuickActionCard(
                    icon: Icons.camera_alt,
                    title: 'Thử Đồ Ảo',
                    color: Colors.lightBlue[100]!,
                    gradientColors: [Colors.blueAccent, Colors.lightBlue],
                    onTap: () => context.go(AppRoutes.fittingRoom),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.checkroom,
                    title: 'Tủ Đồ Của Tôi',
                    color: Colors.brown[100]!,
                    gradientColors: [Colors.brown, Colors.brown[300]!],
                    onTap: () => context.go(AppRoutes.closet),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.add_circle_outline,
                    title: 'Kết Hợp Phong Cách',
                    color: Colors.green[100]!,
                    gradientColors: [Colors.green, Colors.greenAccent],
                    onTap: () {},
                  ),
                  _buildQuickActionCard(
                    icon: Icons.shopping_cart,
                    title: 'Danh Sách Mua Sắm',
                    color: Colors.pink[100]!,
                    gradientColors: [Colors.pink, Colors.pinkAccent],
                    onTap: () => context.go(AppRoutes.shop),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutfitCard({required String imageUrl, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}