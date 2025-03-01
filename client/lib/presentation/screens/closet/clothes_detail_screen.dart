import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/navigation_bar.dart';

class ClothesDetailScreen extends StatefulWidget {
  final String itemImage;
  final String brand;
  final String date;
  final String type;

  const ClothesDetailScreen({
    super.key,
    required this.itemImage,
    required this.brand,
    required this.date,
    required this.type,
  });

  @override
  State<ClothesDetailScreen> createState() => _ClothesDetailScreenState();
}

class _ClothesDetailScreenState extends State<ClothesDetailScreen> {
  int _selectedTab = 0;
  List<String> seasons = ['Spring', 'Summer', 'Fall', 'Winter'];
  String? selectedSeason = 'Winter';
  String? selectedOccasion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Tránh lỗi khi bàn phím xuất hiện
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text('Clothes Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'option1', child: Text('Option 1')),
              const PopupMenuItem(value: 'option2', child: Text('Option 2')),
            ],
            onSelected: (value) {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hình ảnh món đồ
            Image.asset(
              widget.itemImage,
              fit: BoxFit.contain,
              width: double.infinity,
              height: 250, // Giới hạn chiều cao
            ),
            // Nút Washing và Edit
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.local_laundry_service, color: Colors.blue),
                    label: const Text('Washing', style: TextStyle(color: Colors.blue)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Thanh tab dạng 2 cột: Information và Outfit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedTab == 0 ? Colors.blue : Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Information',
                          style: TextStyle(
                            color: _selectedTab == 0 ? Colors.black : Colors.grey,
                            fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedTab == 1 ? Colors.blue : Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Outfit',
                          style: TextStyle(
                            color: _selectedTab == 1 ? Colors.black : Colors.grey,
                            fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Nội dung tab
            _selectedTab == 0 ? _buildInformationTab() : _buildOutfitTab(),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 1,
        onItemTapped: (index) {
          if (index == 0) context.go('/');
        },
      ),
    );
  }

  /// Tab "Information"
  Widget _buildInformationTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Occasion info', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          const Text('Season', style: TextStyle(color: Colors.black)),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: seasons.map((season) {
              return ChoiceChip(
              label: Text(season),
              selected: selectedSeason == season,
              onSelected: (selected) {
                setState(() {
                selectedSeason = selected ? season : null;
                });
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: selectedSeason == season ? Colors.white : Colors.black,
              ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16.0),
          const Text('Occasions', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          DropdownButton<String>(
            hint: const Text('Select occasion'),
            value: selectedOccasion,
            items: ['Casual', 'Formal', 'Party'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOccasion = value;
              });
            },
            isExpanded: true,
            underline: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Tab "Outfit"
  Widget _buildOutfitTab() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: Text('Outfit details coming soon')),
    );
  }
}
