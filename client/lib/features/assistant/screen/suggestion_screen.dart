import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/assistant/controller/assistant_service.dart';

class SuggestionScreen extends StatefulWidget {
  final List<int> resultImageBytes;

  const SuggestionScreen({super.key, required this.resultImageBytes});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  List<SuggestionItem> suggestions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    try {
      final result = await AssistantService().suggestCombinations(widget.resultImageBytes);
      setState(() {
        suggestions = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<Widget> _buildSuggestionWidgets() {
    if (isLoading) {
      return [
        const Center(child: CircularProgressIndicator()),
      ];
    }

    if (errorMessage.isNotEmpty) {
      return [
        Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ];
    }

    if (suggestions.isEmpty) {
      return [
        const Center(
          child: Text(
            'Không có gợi ý nào.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ];
    }

    return suggestions.map((item) {
      Widget imageWidget;
      if (item.imageData != null && item.imageData!.isNotEmpty) {
        try {
          final bytes = base64Decode(item.imageData!);
          imageWidget = Image.memory(
            bytes,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          );
        } catch (e) {
          imageWidget = Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        }
      } else {
        imageWidget = Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        );
      }

      return GestureDetector(
        onTap: () {
          context.push(
            Uri(
              path: '/item',
              queryParameters: {
                'itemImage': 'assets/images/placeholder.jpg',
                'brand': 'Unknown',
                'date': '2023',
                'type': item.category,
                'imageData': item.imageData ?? '', 
              },
            ).toString(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            color: const Color(0xFFFFCFB3),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageWidget,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gợi ý: ${item.suggestions}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Gợi Ý Trang Phục',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 8,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      Uint8List.fromList(widget.resultImageBytes),
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
              const Text(
                'Trang Phục Phù Hợp Với Bạn',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ..._buildSuggestionWidgets(),
            ],
          ),
        ),
      ),
    );
  }
}