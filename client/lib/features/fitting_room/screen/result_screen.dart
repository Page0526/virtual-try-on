import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

class ResultScreen extends StatelessWidget {
  final List<int> resultImageBytes;

  const ResultScreen({super.key, required this.resultImageBytes});

  Future<void> _saveImage(BuildContext context) async {
    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/try_on_result_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(path);
      await file.writeAsBytes(resultImageBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ảnh đã được lưu tại: $path'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lưu ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFDEC), Color(0xFFFFF2AF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Kết quả thử đồ',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 4,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hình ảnh kết quả
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.memory(
                      Uint8List.fromList(resultImageBytes),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Nút hành động
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _saveImage(context),
                    icon: const Icon(Icons.save, size: 20),
                    label: const Text('Lưu Ảnh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFF2AF),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Lưu ảnh'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, size: 20),
                    label: const Text('Quay Lại'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFF2AF),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Nhận gợi ý về trang phục'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Quay lại', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}