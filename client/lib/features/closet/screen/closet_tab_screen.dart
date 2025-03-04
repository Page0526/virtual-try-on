// lib/features/closet/screen/closet_tab_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/closet/controller/closet_bloc.dart';
import 'package:myapp/features/closet/controller/closet_event.dart';
import 'package:myapp/features/closet/controller/closet_state.dart';
import 'package:myapp/features/closet/model/closet.dart';

class ClosetTabScreen extends StatelessWidget {
  const ClosetTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClosetBloc, ClosetState>(
      builder: (context, state) {
        if (state is ClosetLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClosetLoaded) {
          final closets = state.closets;
          return Padding(
            padding: const EdgeInsets.all(16.0),
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
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Chưa có tủ quần áo nào'));
      },
    );
  }

  Widget _buildClosetItem(Closet closet, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => context.go('/closet/${closet.id}?closetName=${Uri.encodeComponent(closet.name)}'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.image, size: 100), // Placeholder image
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      closet.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${closet.items.length} clothes', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
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
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Tạo Tủ Quần Áo Mới'),
                content: TextField(
                  controller: _closetNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên tủ quần áo',
                    hintText: 'Nhập tên tủ quần áo',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () {
                      final name = _closetNameController.text.trim();
                      if (name.isNotEmpty) {
                        final newCloset = Closet(id: DateTime.now().toString(), name: name);
                        context.read<ClosetBloc>().add(AddCloset(newCloset));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Tạo'),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Colors.grey),
              SizedBox(width: 8.0),
              Text('Create a closet', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}