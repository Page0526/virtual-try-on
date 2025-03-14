import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/closet/controller/closet_bloc.dart';
import 'package:myapp/features/closet/controller/closet_event.dart';
import 'package:myapp/features/closet/controller/closet_state.dart';
import 'package:myapp/features/closet/model/closet.dart';
import 'package:myapp/utils/const/graphic/color.dart';

class ClosetTabScreen extends StatelessWidget {
  const ClosetTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClosetBloc, ClosetState>(
      builder: (context, state) {
        if (state is ClosetLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        } else if (state is ClosetLoaded) {
          final closets = state.closets;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: closets.length + 1,
                    itemBuilder: (context, index) {
                      if (index == closets.length) {
                        return _buildCreateCloset(context);
                      }
                      final closet = closets[index];
                      return _buildClosetItem(closet, context);
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is ClosetError) {
          return Center(
            child: Text(
              'Lỗi: ${state.message}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }
        return const Center(
          child: Text(
            'Chưa có tủ quần áo nào',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildClosetItem(Closet closet, BuildContext context) {
    return Card(
      color: Color(0xFFFFCFB3),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => context.go('/closet/${closet.id}?closetName=${Uri.encodeComponent(closet.name)}'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: const Icon(Icons.image, size: 100, color: Color(0xFFE78F81)), // Placeholder image
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      closet.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text('${closet.items.length} clothes', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFFE78F81), size: 20),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateCloset(BuildContext context) {
    final TextEditingController _closetNameController = TextEditingController();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Color(0xFFFFCFB3),
                title: const Text('Tạo Tủ Quần Áo Mới'),
                content: DefaultTextStyle(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  child: TextField(
                  controller: _closetNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên tủ quần áo',
                    hintText: 'Nhập tên tủ quần áo',
                    border: OutlineInputBorder( // Default border
                      borderRadius: BorderRadius.circular(8), // Optional: Adjust corner radius
                      borderSide: BorderSide(color: Colors.black, width: 1), // Default border color
                    ),
                    enabledBorder: OutlineInputBorder( // Border when TextField is not focused
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black, width: 1.5), // Change color here
                    ),
                    focusedBorder: OutlineInputBorder( // Border when TextField is focused
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black, width: 2), // Change color here
                    ),
                  ),
                ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Color(0xFF578FCA)
                      side: BorderSide.none
                    ),
                    onPressed: () {
                      final name = _closetNameController.text.trim();
                      if (name.isNotEmpty) {
                        final newCloset = Closet(id: DateTime.now().toString(), name: name);
                        context.read<ClosetBloc>().add(AddCloset(newCloset));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Tạo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFFFCFB3),
          
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Colors.black),
              SizedBox(width: 2.0),
              Text('Create a closet', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}