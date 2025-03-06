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
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tên'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Loại (jeans, shirt...)'),
                onSaved: (value) => _type = value ?? '',
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập loại' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Thương hiệu'),
                onSaved: (value) => _brand = value ?? '',
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập thương hiệu' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ngày mua (dd/mm/yyyy)'),
                onSaved: (value) => _date = value ?? '',
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _pickImage,
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB3D8A8),
                ),
                child: const Text('Chọn Ảnh'),
              ),
              if (_image != null) Image.file(_image!, height: 200),
              SizedBox(height: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB3D8A8),
                ),
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
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}