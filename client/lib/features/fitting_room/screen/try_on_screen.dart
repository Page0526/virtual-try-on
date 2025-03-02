import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';

// Giả sử các file BLoC và service đã được tạo
import '../controller/try_on_bloc.dart';
import '../controller/try_on_event.dart';
import '../controller/try_on_state.dart';
import '../controller/try_on_service.dart';

class FittingRoom extends StatefulWidget {
  const FittingRoom({super.key});

  @override
  State<FittingRoom> createState() => _FittingRoomState();
}

class _FittingRoomState extends State<FittingRoom> {
  File? _personImage; // Ảnh người
  File? _clothImage;  // Ảnh quần áo
  CameraController? _cameraController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  int _currentStep = 0; // 0: Chọn ảnh quần áo, 1: Chọn ảnh người, 2: Xác nhận cuối

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Khởi tạo camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  // Chụp ảnh từ camera
  Future<void> _captureImageFromCamera() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        if (_currentStep == 0) {
          _clothImage = File(photo.path);
        } else if (_currentStep == 1) {
          _personImage = File(photo.path);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chụp ảnh: $e')),
      );
    }
  }

  // Lấy ảnh từ thư viện
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (_currentStep == 0) {
            _clothImage = File(pickedFile.path);
          } else if (_currentStep == 1) {
            _personImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    }
  }

  // Lấy ảnh từ dữ liệu app (giả lập)
  Future<void> _pickImageFromAppData() async {
    // Giả lập: Thay bằng logic lấy ảnh từ dữ liệu app
    setState(() {
      if (_currentStep == 0) {
        _clothImage = File('path/to/default/cloth_image.jpg'); // Thay bằng đường dẫn thực tế
      } else if (_currentStep == 1) {
        _personImage = File('path/to/default/person_image.jpg'); // Thay bằng đường dẫn thực tế
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TryOnBloc(TryOnService()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple[700]!, Colors.deepPurple[300]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.go('/'),
              ),
              title: const Text(
                'Fitting Room',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 4,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // TODO: Add wardrobe
                  },
                ),
              ],
            ),
          ),
        ),
        body: BlocConsumer<TryOnBloc, TryOnState>(
          listener: (context, state) {
            if (state is TryOnFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              setState(() {
                _isLoading = false;
              });
            } else if (state is TryOnSuccess) {
              setState(() {
                _isLoading = false;
                _currentStep = 0; // Quay lại bước đầu sau khi thành công
                _clothImage = null;
                _personImage = null;
              });
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentStep != 2) // Ẩn khung lớn ở bước xác nhận cuối
                      Center(
                        child: SizedBox(
                          height: 425,
                          width: 325,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : state is TryOnSuccess
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.memory(
                                          Uint8List.fromList(state.resultImageBytes),
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : (_currentStep < 2 && _clothImage == null && _personImage == null) ||
                                            (_currentStep == 1 && _personImage == null)
                                        ? (_cameraController != null && _cameraController!.value.isInitialized
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: CameraPreview(_cameraController!),
                                              )
                                            : const Center(child: CircularProgressIndicator()))
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.file(
                                              _currentStep == 0
                                                  ? _clothImage!
                                                  : _personImage ?? _clothImage!,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_currentStep == 2) ...[
                      // Bước xác nhận cuối: Chỉ hiển thị hai ảnh và các nút
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.file(_personImage!, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.file(_clothImage!, fit: BoxFit.cover),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                context.read<TryOnBloc>().add(
                                      TryOnRequested(
                                        personImage: _personImage!,
                                        clothImage: _clothImage!,
                                      ),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Tạo ảnh'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep = 0; // Bắt đầu lại từ đầu
                                  _clothImage = null;
                                  _personImage = null;
                                });
                              },
                              child: const Text('Bắt đầu lại từ đầu'),
                            ),
                          ],
                        ),
                      ),
                    ] else if (_currentStep == 0 && _clothImage != null) ...[
                      // Bước xác nhận ảnh quần áo
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'Ảnh quần áo đã chọn',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Hãy kiểm tra ảnh quần áo bạn vừa chọn. Nhấn "Tiếp tục" để chọn ảnh người.',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep = 1; // Chuyển sang bước chọn ảnh người
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Tiếp tục'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _clothImage = null; // Xóa ảnh quần áo để chọn lại
                                });
                              },
                              child: const Text('Quay lại'),
                            ),
                          ],
                        ),
                      ),
                    ] else if (_currentStep == 1 && _personImage != null) ...[
                      // Bước xác nhận ảnh người
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'Ảnh người đã chọn',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Hãy kiểm tra ảnh người bạn vừa chọn. Nhấn "Tiếp tục" để xác nhận cả hai ảnh.',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep = 2; // Chuyển sang bước xác nhận cuối
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Tiếp tục'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _personImage = null; // Xóa ảnh người để chọn lại
                                });
                              },
                              child: const Text('Quay lại'),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Giao diện chọn ảnh với camera và mô tả
                      Center(
                        child: Column(
                          children: [
                            Text(
                              _currentStep == 0
                                  ? 'Chụp hoặc chọn ảnh quần áo'
                                  : 'Chụp hoặc chọn ảnh người',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _currentStep == 0
                                  ? 'Hãy chụp ảnh quần áo bằng camera hoặc chọn từ thư viện/dữ liệu app.'
                                  : 'Hãy chụp ảnh người bằng camera hoặc chọn từ thư viện/dữ liệu app. Đảm bảo ảnh rõ nét, toàn thân.',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _pickImageFromGallery,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [
                                    Colors.deepPurple.shade200,
                                    Colors.deepPurple.shade400,
                                    Colors.deepPurple.shade600
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Icon(Icons.image, size: 40, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 35),
                          Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade200,
                                  Colors.deepPurple.shade400,
                                  Colors.deepPurple.shade600
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: _captureImageFromCamera,
                              borderRadius: BorderRadius.circular(100),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 35),
                          GestureDetector(
                            onTap: _pickImageFromAppData,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [
                                    Colors.deepPurple.shade200,
                                    Colors.deepPurple.shade400,
                                    Colors.deepPurple.shade600
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Icon(Icons.storage, size: 40, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}