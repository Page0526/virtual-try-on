// lib/features/fitting_room/result_screen.dart
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
        SnackBar(content: Text('Ảnh đã được lưu tại: $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu ảnh: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 425,
                  width: 325,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        Uint8List.fromList(resultImageBytes),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _saveImage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFF2AF),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Lưu ảnh'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Điều hướng đến SuggestionScreen
                      context.push('/suggestion', extra: resultImageBytes);
                    },
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