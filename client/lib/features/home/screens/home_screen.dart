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
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/user.jpg'), // Avatar giả lập
              radius: 20,
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello, Tuoc',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  'Ha Noi, VN',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần thời tiết
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sunny Day',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '72°F',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny, color: Colors.orange),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Today',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              'Mar 15',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Phần Recent Outfits
              const Text(
                'Recent Outfits',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              RecentOutfitSlider(banners: [CusPath.banner1, CusPath.banner2, CusPath.banner3]),
              const SizedBox(height: 16.0),
              // Phần News
              const Text(
                'News',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: _buildOutfitCard(
                      imageUrl: 'assets/images/image2.jpg', // Ảnh giả lập
                      title: 'Casual Friday',
                      onTap: () {
                        // Placeholder cho điều hướng đến chi tiết Outfit (có thể mở rộng)
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildOutfitCard(
                      imageUrl: 'assets/images/image2.jpg', // Ảnh giả lập
                      title: 'Business Meeting',
                      onTap: () {
                        // Placeholder cho điều hướng đến chi tiết Outfit (có thể mở rộng)
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Phần Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: [
                  _buildQuickActionCard(
                    icon: Icons.camera_alt,
                    title: 'Virtual Try-On',
                    color: Colors.lightBlue[100]!,
                    onTap: () => context.go(AppRoutes.fittingRoom),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.checkroom,
                    title: 'My Wardrobe',
                    color: Colors.brown[100]!,
                    onTap: () => context.go(AppRoutes.closet),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.add_circle_outline,
                    title: 'Style Match',
                    color: Colors.green[100]!,
                    onTap: () {
                      // Placeholder cho điều hướng (có thể mở rộng)
                    },
                  ),
                  _buildQuickActionCard(
                    icon: Icons.shopping_cart,
                    title: 'Shopping List',
                    color: Colors.pink[100]!,
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
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
    required VoidCallback onTap,
  }) {
    return Card(
      color: color,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.black),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}