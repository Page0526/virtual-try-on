import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Melissa Peters');
  final _emailController = TextEditingController(text: 'melpeters@gmail.com');
  final _passwordController = TextEditingController(text: '********');
  String _dateOfBirth = '23/05/1995';
  String _country = 'Nigeria';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/settings'),
        ),
        title: const Text(
          'Chỉnh Sửa Hồ Sơ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 8,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile image
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.grey[200],
                          child: const Text(
                            'Profile Image',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blueAccent,
                          child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Name field
                const Text('Tên', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên của bạn',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 16),
                // Email field
                const Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Nhập email của bạn',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 16),
                // Password field
                const Text('Mật khẩu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu mới',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 16),
                // Date of Birth field
                const Text('Ngày sinh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Implement date picker logic here
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_dateOfBirth, style: const TextStyle(fontSize: 16)),
                        const Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Country/Region field
                const Text('Quốc gia/Khu vực', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _country,
                  onChanged: (value) {
                    setState(() {
                      _country = value!;
                    });
                  },
                  items: ['Nigeria', 'USA', 'UK', 'Canada'].map((country) {
                    return DropdownMenuItem(value: country, child: Text(country, style: const TextStyle(fontSize: 16)));
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 32),
                // Save Changes button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 6,
                    ),
                    child: const Text(
                      'Lưu Thay Đổi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
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