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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/closet/${closet.id}?closetName=${Uri.encodeComponent(closet.name)}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      closet.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${closet.items.length} món đồ',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () {
                  // Logic chỉnh sửa có thể thêm sau
                },
              ),
            ],
          ),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text(
                  'Tạo Tủ Quần Áo Mới',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: TextField(
                  controller: _closetNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên tủ quần áo',
                    hintText: 'Nhập tên tủ quần áo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final name = _closetNameController.text.trim();
                      if (name.isNotEmpty) {
                        final newCloset = Closet(id: DateTime.now().toString(), name: name);
                        context.read<ClosetBloc>().add(AddCloset(newCloset));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Tạo', style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Colors.blueAccent, size: 28),
              SizedBox(width: 12),
              Text(
                'Tạo tủ quần áo mới',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}