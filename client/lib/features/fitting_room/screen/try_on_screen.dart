// lib/features/fitting_room/fitting_room.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
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
  File? _personImage; // Ảnh người
  File? _clothImage;  // Ảnh quần áo
  CameraController? _cameraController;
  final ImagePicker _picker = ImagePicker();
  int _currentStep = 0; // 0: Chọn ảnh quần áo, 1: Chọn ảnh người, 2: Xác nhận cuối

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Khởi tạo camera
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi khởi tạo camera: $e')),
      );
    }
  }

  // Chụp ảnh từ camera
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
        SnackBar(content: Text('Lỗi khi chọn ảnh từ thư viện: $e')),
      );
    }
  }

  // Lấy ảnh từ dữ liệu app (giả lập)
  Future<void> _pickImageFromAppData() async {
    // Giả lập: Thay bằng logic lấy ảnh từ dữ liệu app
    try {
      setState(() {
        if (_currentStep == 0) {
          _clothImage = File('path/to/default/cloth_image.jpg'); // Thay bằng đường dẫn thực tế
        } else if (_currentStep == 1) {
          _personImage = File('path/to/default/person_image.jpg'); // Thay bằng đường dẫn thực tế
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh từ dữ liệu app: $e')),
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFDEC), Color(0xFFFFF2AF)],
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
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 4,
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
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
            } else if (state is TryOnSuccess) {
              setState(() {
                context.push('/fitting-room/result', extra: state.resultImageBytes);
                context.read<TryOnBloc>().add(ResetTryOn());
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
                  children: [
                    _buildStepIndicator(),
                    const SizedBox(height: 20),
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
                        onGenerate: () {
                          context.read<TryOnBloc>().add(
                                TryOnRequested(
                                  personImage: _personImage!,
                                  clothImage: _clothImage!,
                                ),
                              );
                        },
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepCircle(0, 'Clothes'),
          _buildStepLine(),
          _buildStepCircle(1, 'Person'),
          _buildStepLine(),
          _buildStepCircle(2, 'Confirm'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep == step;
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: isActive ? Color(0xFFFFF2AF): Colors.grey,
          child: Text(
            '${step + 1}',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 50,
      height: 2,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}

// Widget cho bước 0: Chọn ảnh quần áo
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
            child: SizedBox(
              height: 425,
              width: 325,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    clothImage!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFF2AF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Tiếp tục', style: TextStyle(color: Colors.black),),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onBack,
            child: const Text('Quay lại'),
          ),
        ],
      );
    }

    return Column(
      children: [
        CameraPreviewWidget(cameraController: cameraController),
        const SizedBox(height: 20),
        const Text(
          'Chụp hoặc chọn ảnh quần áo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Hãy chụp ảnh quần áo bằng camera hoặc chọn từ thư viện/dữ liệu app.',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ImageSelectionWidget(
          onSelectGallery: onSelectGallery,
          onCaptureCamera: onCaptureCamera,
          onSelectAppData: onSelectAppData,
        ),
      ],
    );
  }
}

// Widget cho bước 1: Chọn ảnh người
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
            child: SizedBox(
              height: 425,
              width: 325,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    personImage!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFF2AF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Tiếp tục', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onBack,
            child: const Text('Quay lại'),
          ),
        ],
      );
    }

    return Column(
      children: [
        CameraPreviewWidget(cameraController: cameraController),
        const SizedBox(height: 20),
        const Text(
          'Chụp hoặc chọn ảnh người',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Hãy chụp ảnh người bằng camera hoặc chọn từ thư viện/dữ liệu app. Đảm bảo ảnh rõ nét, toàn thân.',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ImageSelectionWidget(
          onSelectGallery: onSelectGallery,
          onCaptureCamera: onCaptureCamera,
          onSelectAppData: onSelectAppData,
        ),
      ],
    );
  }
}

// Widget cho bước 2: Xác nhận và gửi yêu cầu API
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
      return const Center(child: CircularProgressIndicator());
    }

    if (resultImageBytes != null) {
      return Column(
        children: [
          Center(
            child: SizedBox(
              height: 425,
              width: 325,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(
                    Uint8List.fromList(resultImageBytes!),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onReset,
            child: const Text('Bắt đầu lại từ đầu'),
          ),
        ],
      );
    }

    return Center(
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
                child: Image.file(personImage, fit: BoxFit.cover),
              ),
              const SizedBox(width: 20),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.file(clothImage, fit: BoxFit.cover),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onGenerate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFF2AF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Tạo ảnh', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onReset,
            child: const Text('Bắt đầu lại từ đầu', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

// Widget hiển thị camera preview
class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;

  const CameraPreviewWidget({super.key, this.cameraController});

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: SizedBox(
        height: 425,
        width: 325,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CameraPreview(cameraController!),
          ),
        ),
      ),
    );
  }
}

// Widget hiển thị các nút chọn ảnh
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
        GestureDetector(
          onTap: onSelectGallery,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                Color(0xFFFFF2AF),
                Color.fromARGB(255, 243, 230, 113),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: const Icon(Iconsax.image, size: 40, color: Colors.black),
          ),
        ),
        const SizedBox(width: 35),
        Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFF2AF),
                Color.fromARGB(255, 243, 230, 113),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: onCaptureCamera,
            borderRadius: BorderRadius.circular(100),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Icon(Iconsax.instagram, size: 25, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 35),
        GestureDetector(
          onTap: onSelectAppData,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                Color(0xFFFFF2AF),
                Color.fromARGB(255, 243, 230, 113),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: const Icon(Iconsax.category, size: 40, color: Colors.black),
          ),
        ),
      ],
    );
  }
}