import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class IdCardScannerScreen extends StatefulWidget {
  final String title;
  final bool isFront;

  const IdCardScannerScreen({
    super.key,
    required this.title,
    required this.isFront,
  });

  @override
  State<IdCardScannerScreen> createState() => _IdCardScannerScreenState();
}

class _IdCardScannerScreenState extends State<IdCardScannerScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _flashOn = false;

  // Auto-scanning logic
  Timer? _countdownTimer;
  int _secondsLeft = 3;
  bool _isCountingDown = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _startAutoCaptureTimer();
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  void _startAutoCaptureTimer() {
    if (_isCountingDown) return;

    setState(() {
      _isCountingDown = true;
      _secondsLeft = 3;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          _secondsLeft = 0;
          timer.cancel();
          _isCountingDown = false;
          _captureAndProcess();
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    try {
      _flashOn = !_flashOn;
      await _controller!.setFlashMode(
        _flashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _captureAndProcess() async {
    if (_controller == null ||
        _isCapturing ||
        !_controller!.value.isInitialized) return;

    // Stop timer if it's running
    _countdownTimer?.cancel();

    setState(() {
      _isCapturing = true;
      _isCountingDown = false;
    });

    try {
      // Capture image
      final XFile imageFile = await _controller!.takePicture();

      // Process and enhance image
      final File enhancedImage = await _enhanceImage(File(imageFile.path));

      if (mounted) {
        Navigator.pop(context, enhancedImage);
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('حدث خطأ أثناء التقاط الصورة'),
            backgroundColor: AppColor.redButtonColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<File> _enhanceImage(File imageFile) async {
    try {
      // Read image
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) return imageFile;

      // Handle image rotation if needed (camera images often come in different orientations)
      if (image.width > image.height) {
        // If it's landscape and we were in portrait, we might need rotation
        // but img.decodeImage usually handles Exif.
      }

      // Calculate Crop Area
      // Logical screen dimensions
      final double screenWidth = 1.sw;
      final double screenHeight = 1.sh;

      // Card frame dimensions inside the screen
      final double cardWidth = 320.w;
      final double cardHeight = 200.h;

      // Calculate ratios (where the box is relative to the screen)
      final double cropWidthRatio = cardWidth / screenWidth;
      final double cropHeightRatio = cardHeight / screenHeight;

      // The box is centered
      final double cropXStartRatio =
          (screenWidth - cardWidth) / 2 / screenWidth;
      final double cropYStartRatio =
          (screenHeight - cardHeight) / 2 / screenHeight;

      // Actual pixel dimensions for cropping
      int cropX = (image.width * cropXStartRatio).toInt();
      int cropY = (image.height * cropYStartRatio).toInt();
      int cropW = (image.width * cropWidthRatio).toInt();
      int cropH = (image.height * cropHeightRatio).toInt();

      // Ensure we stay within bounds
      cropX = cropX.clamp(0, image.width);
      cropY = cropY.clamp(0, image.height);
      cropW = cropW.clamp(0, image.width - cropX);
      cropH = cropH.clamp(0, image.height - cropY);

      // Perform the crop
      image =
          img.copyCrop(image, x: cropX, y: cropY, width: cropW, height: cropH);

      // Auto-adjust brightness and contrast after cropping
      image = img.adjustColor(
        image,
        contrast: 1.2,
        brightness: 1.05,
      );

      // Resize for optimization (keeping details but reducing file size)
      if (image.width > 1200) {
        image = img.copyResize(
          image,
          width: 1200,
          interpolation: img.Interpolation.linear,
        );
      }

      // Save enhanced image
      final directory = await getTemporaryDirectory();
      final String path =
          '${directory.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File enhancedFile = File(path);
      await enhancedFile.writeAsBytes(img.encodeJpg(image, quality: 90));

      return enhancedFile;
    } catch (e) {
      debugPrint('Error enhancing/cropping image: $e');
      return imageFile;
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          if (_isInitialized && _controller != null)
            Positioned.fill(
              child: CameraPreview(_controller!),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),

          // Scanner Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(),
            ),
          ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFlash,
                      icon: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _flashOn ? Icons.flash_on : Icons.flash_off,
                          color: _flashOn ? Colors.yellow : Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Instructions
          Positioned(
            top: 120.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    widget.title,
                    style: AppStyle.font16_600Weight.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                if (_isCountingDown)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Text(
                      'التقاط تلقائي خلال $_secondsLeft ثانية',
                      style: AppStyle.font14_600Weight.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Text(
                    'ضع البطاقة داخل الإطار',
                    style: AppStyle.font14_400Weight.copyWith(
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
          ),

          // Card Frame Guide
          Center(
            child: Container(
              width: 320.w,
              height: 200.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isCountingDown ? Colors.red : AppColor.primaryColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Stack(
                children: [
                  // Scanning line animation
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value * 200.h,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primaryColor.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                            color: AppColor.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                  // Corner decorations
                  ..._buildCornerDecorations(),
                  // ID icon in center
                  Center(
                    child: Icon(
                      widget.isFront
                          ? Icons.credit_card
                          : Icons.credit_card_outlined,
                      color: Colors.white.withOpacity(0.3),
                      size: 60.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                child: Column(
                  children: [
                    Text(
                      'تأكد من وضوح جميع البيانات',
                      style: AppStyle.font14_400Weight.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Capture Button
                    GestureDetector(
                      onTap: _isCapturing ? null : _captureAndProcess,
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isCapturing
                                ? Colors.grey
                                : AppColor.primaryColor,
                          ),
                          child: _isCapturing
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerDecorations() {
    return [
      // Top Left
      Positioned(
        top: -2,
        left: -2,
        child: _buildCorner(true, true),
      ),
      // Top Right
      Positioned(
        top: -2,
        right: -2,
        child: _buildCorner(true, false),
      ),
      // Bottom Left
      Positioned(
        bottom: -2,
        left: -2,
        child: _buildCorner(false, true),
      ),
      // Bottom Right
      Positioned(
        bottom: -2,
        right: -2,
        child: _buildCorner(false, false),
      ),
    ];
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide(color: AppColor.primaryColor, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? BorderSide(color: AppColor.primaryColor, width: 4)
              : BorderSide.none,
          left: isLeft
              ? BorderSide(color: AppColor.primaryColor, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? BorderSide(color: AppColor.primaryColor, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final cardWidth = 320.0;
    final cardHeight = 200.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final cardRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: cardWidth,
        height: cardHeight,
      ),
      const Radius.circular(15),
    );

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(cardRect);

    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
