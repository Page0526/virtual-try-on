import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation_bar.dart';

class ClosetDetailScreen extends StatefulWidget {
  final String closetName;

  const ClosetDetailScreen({super.key, required this.closetName});

  @override
  State<ClosetDetailScreen> createState() => _ClosetDetailScreenState();
}

class _ClosetDetailScreenState extends State<ClosetDetailScreen> {
  int _selectedSortOption = 0; 
  final List<Map<String, String>> items = [
    {
      'image': 'assets/images/image1.jpg', 
      'brand': 'No Brand',
      'date': '2/22/2025',
      'type': 'Tops',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/closet'),
        ),
        title: Text(widget.closetName),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_box_outline_blank),
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
      body: Column(
        children: [
          // Bộ lọc (Dropdown)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: 'Recently added',
              items: ['Recently added', 'Price', 'Date'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSortOption = value == 'Recently added' ? 0 : 1;
                });
              },
              isExpanded: true,
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildItemCard(items[index], context);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 1, 
        onItemTapped: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              break;
          }
        },
      ),
    );
  }

  Widget _buildItemCard(Map<String, String> item, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          context.push(
            '/clothes?itemImage=${Uri.encodeComponent(item['image']!)}&brand=${Uri.encodeComponent(item['brand']!)}&date=${Uri.encodeComponent(item['date']!)}&type=${Uri.encodeComponent(item['type']!)}',
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                item['image']!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['type']!,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      item['brand']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item['date']!,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}