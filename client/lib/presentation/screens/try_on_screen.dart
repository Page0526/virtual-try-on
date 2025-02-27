// lib/presentation/screens/try_on_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/business_logic/blocs/try_on/try_on_bloc.dart';
import 'package:myapp/business_logic/blocs/try_on/try_on_event.dart';
import 'package:myapp/business_logic/blocs/try_on/try_on_state.dart';
import '../../data/services/try_on_service.dart';

class TryOnScreen extends StatefulWidget {
  const TryOnScreen({super.key});

  @override
  _TryOnScreenState createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  File? personImage;
  File? clothImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isPersonImage) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, 
      );
      if (pickedFile != null) {
        setState(() {
          if (isPersonImage) {
            personImage = File(pickedFile.path);
          } else {
            clothImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TryOnBloc(TryOnService()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Virtual Try-On')),
        body: BlocConsumer<TryOnBloc, TryOnState>(
          listener: (context, state) {
            if (state is TryOnFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is TryOnLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TryOnSuccess) {
              return Center(
                child: Image.memory(Uint8List.fromList(state.resultImageBytes)),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _pickImage(true),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: personImage != null
                          ? Image.file(personImage!, fit: BoxFit.cover)
                          : const Center(child: Text('Chọn ảnh người')),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _pickImage(false),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: clothImage != null
                          ? Image.file(clothImage!, fit: BoxFit.cover)
                          : const Center(child: Text('Chọn ảnh quần áo')),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (personImage != null && clothImage != null) {
                        context.read<TryOnBloc>().add(
                              TryOnRequested(
                                personImage: personImage!,
                                clothImage: clothImage!,
                              ),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng chọn cả hai ảnh')),
                        );
                      }
                    },
                    child: const Text('Thử đồ'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}