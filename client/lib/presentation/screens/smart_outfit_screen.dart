// lib/presentation/screens/smart_outfit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/business_logic/blocs/assistant/outfit_bloc.dart';
import 'package:myapp/business_logic/blocs/assistant/outfit_event.dart';
import 'package:myapp/business_logic/blocs/assistant/outfit_state.dart';
import 'package:myapp/data/models/item.dart';
import 'package:myapp/data/services/outfit_service.dart';


class SmartOutfitScreen extends StatefulWidget {
  final List<Item> wardrobeItems;

  const SmartOutfitScreen({required this.wardrobeItems, super.key});

  @override
  _SmartOutfitScreenState createState() => _SmartOutfitScreenState();
}

class _SmartOutfitScreenState extends State<SmartOutfitScreen> {
  Item? selectedItem;
  String? selectedOccasion;
  final List<String> occasions = ['Công sở', 'Dạo phố', 'Tiệc tùng', 'Thể thao'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OutfitBloc(OutfitService()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Phòng Phối Đồ Thông Minh')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<Item>(
                hint: const Text('Chọn một món đồ'),
                value: selectedItem,
                onChanged: (Item? newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                },
                items: widget.wardrobeItems.map((Item item) {
                  return DropdownMenuItem<Item>(
                    value: item,
                    child: Text(item.name),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                hint: const Text('Chọn dịp'),
                value: selectedOccasion,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOccasion = newValue;
                  });
                },
                items: occasions.map((String occasion) {
                  return DropdownMenuItem<String>(
                    value: occasion,
                    child: Text(occasion),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      if (selectedItem != null) {
                        context.read<OutfitBloc>().add(GetOutfitSuggestions(
                          itemId: selectedItem!.id,
                          occasion: selectedOccasion,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng chọn một món đồ')),
                        );
                      }
                    },
                    child: const Text('Nhận gợi ý'),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<OutfitBloc, OutfitState>(
                  builder: (context, state) {
                    if (state is OutfitLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OutfitLoaded) {
                      return ListView.builder(
                        itemCount: state.outfits.length,
                        itemBuilder: (context, index) {
                          final outfit = state.outfits[index];
                          return Card(
                            child: ListTile(
                              title: Text('Bộ trang phục ${index + 1}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dành cho: ${outfit.occasion}'),
                                  Text('Món đồ: ${outfit.items.map((item) => item.name).join(", ")}'),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is OutfitError) {
                      return Center(child: Text('Lỗi: ${state.message}'));
                    }
                    return const Center(child: Text('Chọn món đồ và dịp để nhận gợi ý'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}