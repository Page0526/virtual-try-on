import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class FittingRoom extends StatefulWidget{
  const FittingRoom({super.key});
  
  @override
  State<FittingRoom> createState() => _FittingRoomState();
}

class _FittingRoomState extends State<FittingRoom> {

  File? _selectedImage;
  File? _output;
  bool _isLoading = false;

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _output = null;
        _isLoading = true;
      });

      File? output = await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _output = output;
        _isLoading = false;
      });
    } else {
      return;
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _output = null;
        _isLoading = true;
      });

      File? output = await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _output = output;
        _isLoading = false;
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 350,
                width: 300,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: _selectedImage != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_selectedImage!, height: 200, fit: BoxFit.fill,)
                    )
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
            ),
            // const SizedBox(height: 10),
            Center(
              child: _isLoading
                ? const CircularProgressIndicator() // loading spinner while processing
                : _output != null
                    ? Image.file(_output!, height: 200) // processed image
                    : SizedBox(
                      height: 50,
                      width: 325,
                      child: const Text('Choose a well-lit, full-body shot with one person standing straight', 
                                    style: TextStyle(
                                              fontSize: 15, 
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                    ),
            ),
            
            
          ],
        )
      ),
    );
  } 
}

