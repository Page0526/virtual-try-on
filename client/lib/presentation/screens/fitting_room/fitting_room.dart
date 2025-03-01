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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[700]!, Colors.deepPurple[300]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            title: Text(
              'Fitting Room',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 4,
            iconTheme: IconThemeData(color: Colors.white),
            
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  // TODO: Add wardrobe
                  
                },
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('App Settings'),
              onTap: () {
                // TODO: add settings
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                // TODO: add about
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      onDrawerChanged: (isOpen) {
        if (isOpen) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
      },
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 425,
                width: 325,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: _selectedImage != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(_selectedImage!, height: 200, fit: BoxFit.fill,)
                    )
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20, width: 20),
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
            
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImageFromCamera();
                  },
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400, Colors.deepPurple.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Icon(Icons.camera_alt, size: 40, color: Colors.white), // White needed for gradient
                  ),
                ),
                const SizedBox(width: 35),
                Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400, Colors.deepPurple.shade600],
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      // TODO: Model's API

                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Icon(Icons.add, size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(width: 35),
                GestureDetector(
                  onTap: () {
                    _pickImageFromGallery();
                  },
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400, Colors.deepPurple.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Icon(Icons.image, size: 40, color: Colors.white), // White needed for gradient
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  } 
}
