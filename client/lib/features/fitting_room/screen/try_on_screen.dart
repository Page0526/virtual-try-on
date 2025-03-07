import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:myapp/utils/const/graphic/color.dart';
import '/features/fitting_room/controller/try_on_bloc.dart';
import '/features/fitting_room/controller/try_on_event.dart';
import '/features/fitting_room/controller/try_on_state.dart';
import '/features/fitting_room/controller/try_on_service.dart';

class FittingRoom extends StatefulWidget {
  const FittingRoom({super.key});

  @override
  State<FittingRoom> createState() => _FittingRoomState();
}

class _FittingRoomState extends State<FittingRoom> {
  File? _personImage;
  File? _clothImage;
  CameraController? _cameraController;
  final ImagePicker _picker = ImagePicker();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
        await _cameraController!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khởi tạo camera: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _captureImageFromCamera() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera chưa sẵn sàng')),
      );
      return;
    }
    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        if (_currentStep == 0) _clothImage = File(photo.path);
        else if (_currentStep == 1) _personImage = File(photo.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chụp ảnh: $e')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (_currentStep == 0) _clothImage = File(pickedFile.path);
          else if (_currentStep == 1) _personImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chọn ảnh: $e')),
      );
    }
  }

  Future<void> _pickImageFromAppData() async {
    try {
      setState(() {
        if (_currentStep == 0) _clothImage = File('path/to/default/cloth_image.jpg');
        else if (_currentStep == 1) _personImage = File('path/to/default/person_image.jpg');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chọn ảnh từ app: $e')),
      );
    }
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
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: CusColor.barColor,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: CusColor.primaryTextColor),
            onPressed: () => context.go('/'),
          ),
          title: const Text(
            'Phòng Thử Đồ Ảo',
            style: TextStyle(color: CusColor.primaryTextColor, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          elevation: 8,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: CusColor.primaryTextColor),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<TryOnBloc, TryOnState>(
          listener: (context, state) {
            if (state is TryOnFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            } else if (state is TryOnSuccess) {
              setState(() {
                context.push('/fitting-room/result', extra: state.resultImageBytes);
                context.read<TryOnBloc>().add(ResetTryOn());
                _currentStep = 0;
                _clothImage = null;
                _personImage = null;
              });
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    _buildStepIndicator(),
                    const SizedBox(height: 24),
                    if (_currentStep == 0) ...[
                      Step0Widget(
                        clothImage: _clothImage,
                        cameraController: _cameraController,
                        onSelectGallery: _pickImageFromGallery,
                        onCaptureCamera: _captureImageFromCamera,
                        onSelectAppData: _pickImageFromAppData,
                        onContinue: () => setState(() => _currentStep = 1),
                        onBack: () => setState(() => _clothImage = null),
                      ),
                    ] else if (_currentStep == 1) ...[
                      Step1Widget(
                        personImage: _personImage,
                        clothImage: _clothImage,
                        cameraController: _cameraController,
                        onSelectGallery: _pickImageFromGallery,
                        onCaptureCamera: _captureImageFromCamera,
                        onSelectAppData: _pickImageFromAppData,
                        onContinue: () => setState(() => _currentStep = 2),
                        onBack: () => setState(() => _personImage = null),
                      ),
                    ] else if (_currentStep == 2) ...[
                      Step2Widget(
                        personImage: _personImage!,
                        clothImage: _clothImage!,
                        isLoading: state is TryOnLoading,
                        resultImageBytes: state is TryOnSuccess ? state.resultImageBytes : null,
                        onGenerate: () => context.read<TryOnBloc>().add(
                              TryOnRequested(personImage: _personImage!, clothImage: _clothImage!),
                            ),
                        onReset: () => setState(() {
                          _currentStep = 0;
                          _clothImage = null;
                          _personImage = null;
                        }),
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

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(0, 'Quần Áo'),
        _buildStepLine(),
        _buildStepCircle(1, 'Người'),
        _buildStepLine(),
        _buildStepCircle(2, 'Xác Nhận'),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep == step;
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Color(0xFFFFCFB3) : Colors.grey[300],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey[600],
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 50,
      height: 2,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class Step0Widget extends StatelessWidget {
  final File? clothImage;
  final CameraController? cameraController;
  final VoidCallback onSelectGallery;
  final VoidCallback onCaptureCamera;
  final VoidCallback onSelectAppData;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const Step0Widget({
    super.key,
    this.clothImage,
    this.cameraController,
    required this.onSelectGallery,
    required this.onCaptureCamera,
    required this.onSelectAppData,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (clothImage != null) {
      return Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(clothImage!, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ảnh Quần Áo Đã Chọn',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Text(
            'Kiểm tra ảnh quần áo bạn vừa chọn. Nhấn "Tiếp tục" để chọn ảnh người.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFCFB3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              side: BorderSide.none,
            ),
            child: const Text('Tiếp Tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onBack,
            child: const Text('Chọn Lại', style: TextStyle(fontSize: 14, color: Colors.black)),
          ),
        ],
      );
    }
    return Column(
      children: [
        CameraPreviewWidget(cameraController: cameraController),
        const SizedBox(height: 24),
        const Text(
          'Chụp Hoặc Chọn Ảnh Quần Áo',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        const Text(
          'Chụp ảnh quần áo bằng camera hoặc chọn từ thư viện/dữ liệu app.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ImageSelectionWidget(
          onSelectGallery: onSelectGallery,
          onCaptureCamera: onCaptureCamera,
          onSelectAppData: onSelectAppData,
        ),
      ],
    );
  }
}

class Step1Widget extends StatelessWidget {
  final File? personImage;
  final File? clothImage;
  final CameraController? cameraController;
  final VoidCallback onSelectGallery;
  final VoidCallback onCaptureCamera;
  final VoidCallback onSelectAppData;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const Step1Widget({
    super.key,
    this.personImage,
    this.clothImage,
    this.cameraController,
    required this.onSelectGallery,
    required this.onCaptureCamera,
    required this.onSelectAppData,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (personImage != null) {
      return Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(personImage!, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ảnh Người Đã Chọn',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Text(
            'Kiểm tra ảnh người bạn vừa chọn. Nhấn "Tiếp tục" để xác nhận.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFCFB3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              side: BorderSide.none,
            ),
            child: const Text('Tiếp Tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onBack,
            child: const Text('Chọn Lại', style: TextStyle(fontSize: 14, color: Colors.black)),
          ),
        ],
      );
    }
    return Column(
      children: [
        CameraPreviewWidget(cameraController: cameraController),
        const SizedBox(height: 24),
        const Text(
          'Chụp Hoặc Chọn Ảnh Người',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        const Text(
          'Chụp ảnh người bằng camera hoặc chọn từ thư viện/dữ liệu app. Đảm bảo ảnh rõ nét, toàn thân.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ImageSelectionWidget(
          onSelectGallery: onSelectGallery,
          onCaptureCamera: onCaptureCamera,
          onSelectAppData: onSelectAppData,
        ),
      ],
    );
  }
}

class Step2Widget extends StatelessWidget {
  final File personImage;
  final File clothImage;
  final bool isLoading;
  final List<int>? resultImageBytes;
  final VoidCallback onGenerate;
  final VoidCallback onReset;

  const Step2Widget({
    super.key,
    required this.personImage,
    required this.clothImage,
    required this.isLoading,
    this.resultImageBytes,
    required this.onGenerate,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    }
    if (resultImageBytes != null) {
      return Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.memory(Uint8List.fromList(resultImageBytes!), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: onReset,
            child: const Text('Bắt Đầu Lại', style: TextStyle(fontSize: 14, color: Colors.blueAccent)),
          ),
        ],
      );
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(personImage, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(clothImage, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Xác Nhận Ảnh',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        const Text(
          'Kiểm tra hai ảnh đã chọn. Nhấn "Tạo Ảnh" để xem kết quả thử đồ.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onGenerate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFCFB3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            side: BorderSide.none,
          ),
          child: const Text('Tạo Ảnh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onReset,
          child: const Text('Bắt Đầu Lại', style: TextStyle(fontSize: 14, color: Colors.black)),
        ),
      ],
    );
  }
}

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;

  const CameraPreviewWidget({super.key, this.cameraController});

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(child: CircularProgressIndicator(color: Color(0xFFFFCFB3))),
      );
    }
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: CameraPreview(cameraController!),
        ),
      ),
    );
  }
}

class ImageSelectionWidget extends StatelessWidget {
  final VoidCallback onSelectGallery;
  final VoidCallback onCaptureCamera;
  final VoidCallback onSelectAppData;

  const ImageSelectionWidget({
    super.key,
    required this.onSelectGallery,
    required this.onCaptureCamera,
    required this.onSelectAppData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(
          icon: Icons.image,
          onTap: onSelectGallery,
          tooltip: 'Chọn từ thư viện',
        ),
        const SizedBox(width: 32),
        _buildIconButton(
          icon: Icons.camera_alt,
          onTap: onCaptureCamera,
          tooltip: 'Chụp ảnh',
          isPrimary: true,
        ),
        const SizedBox(width: 32),
        _buildIconButton(
          icon: Icons.storage,
          onTap: onSelectAppData,
          tooltip: 'Chọn từ dữ liệu app',
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isPrimary = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFCFB3),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Icon(icon, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}