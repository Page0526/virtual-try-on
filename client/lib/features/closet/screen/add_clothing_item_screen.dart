// lib/presentation/screens/add_clothing_item_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/clothing_event.dart';
import '../controller/clothing_bloc.dart';
import '../model/item.dart';

class AddClothingItemScreen extends StatefulWidget {
  const AddClothingItemScreen({super.key});

  @override
  _AddClothingItemScreenState createState() => _AddClothingItemScreenState();
}

class _AddClothingItemScreenState extends State<AddClothingItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = '';
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Món Đồ Mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tên'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Loại (jeans, shirt...)'),
                onSaved: (value) => _type = value ?? '',
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập loại' : null,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Chọn Ảnh'),
              ),
              if (_image != null) Image.file(_image!, height: 200),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newItem = Item(
                      id: DateTime.now().toString(), // ID tạm thời
                      name: _name,
                      type: _type,
                      imageUrl: _image?.path ?? '', // Cần upload ảnh lên server
                    );
                    context.read<ClothingBloc>().add(AddClothingItem(newItem));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}