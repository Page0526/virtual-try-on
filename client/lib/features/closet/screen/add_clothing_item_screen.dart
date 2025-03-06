import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/closet/controller/clothing_bloc.dart';
import 'package:myapp/features/closet/controller/clothing_event.dart';
import 'package:myapp/features/closet/model/item.dart';

class AddClothingItemScreen extends StatefulWidget {
  const AddClothingItemScreen({super.key});

  @override
  _AddClothingItemScreenState createState() => _AddClothingItemScreenState();
}

class _AddClothingItemScreenState extends State<AddClothingItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = '';
  String _brand = '';
  String _date = '';
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
    final closetId = GoRouterState.of(context).uri.queryParameters['closetId'] ?? '1';

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Thêm Món Đồ Mới',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tên món đồ',
                    hintText: 'Nhập tên món đồ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSaved: (value) => _name = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Loại (jeans, shirt...)',
                    hintText: 'Nhập loại món đồ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSaved: (value) => _type = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập loại' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Thương hiệu',
                    hintText: 'Nhập thương hiệu',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSaved: (value) => _brand = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập thương hiệu' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ngày mua (dd/mm/yyyy)',
                    hintText: 'Nhập ngày mua (tùy chọn)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSaved: (value) => _date = value ?? '',
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text('Chọn Ảnh', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                ),
                const SizedBox(height: 16),
                if (_image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(_image!, height: 200, fit: BoxFit.cover),
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newItem = Item(
                        id: DateTime.now().toString(),
                        name: _name,
                        type: _type,
                        imageUrl: _image?.path ?? '',
                        brand: _brand,
                        date: _date.isNotEmpty ? _date : DateTime.now().toString(),
                      );
                      context.read<ClothingBloc>().add(AddClothingItem(closetId, newItem));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Thêm Món Đồ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}