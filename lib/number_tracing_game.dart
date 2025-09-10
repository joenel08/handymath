import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';

import 'package:handymath/custom_button.dart';

class NumberTracingScreen extends StatefulWidget {
  const NumberTracingScreen({super.key});

  @override
  State<NumberTracingScreen> createState() => _NumberTracingScreenState();
}

class _NumberTracingScreenState extends State<NumberTracingScreen> {
  final List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  int currentNumberIndex = 0;
  bool isGuiding = true;
  bool isCompleted = false;
  List<Offset> drawingPoints = [];
  List<Offset> guidePath = [];
  ui.Image? numberImage;
  ui.Image? handImage;
  Timer? guideTimer;
  int currentGuideIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadHandImage();
    _loadNumberImage();
    _startGuideAnimation();
  }

  @override
  void dispose() {
    guideTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadHandImage() async {
    try {
      final data = await rootBundle.load('assets/hand_icon.png');
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      setState(() {
        handImage = frame.image;
      });
    } catch (e) {
      print('Error loading hand image: $e');
    }
  }

  Future<void> _loadNumberImage() async {
    final numbersList = [
      'zero',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine'
    ];
    final imagePath = 'assets/${numbersList[currentNumberIndex]}.png';

    try {
      final data = await rootBundle.load(imagePath);
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      setState(() {
        numberImage = frame.image;
      });
    } catch (e) {
      print('Error loading number image: $e');
    }
  }

  void _startGuideAnimation() {
    _createGuidePath();

    // Animate guide hand
    guideTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (isGuiding && currentGuideIndex < guidePath.length - 1) {
        setState(() {
          currentGuideIndex++;
        });
      } else {
        timer.cancel();
        if (isGuiding) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              isGuiding = false;
            });
          });
        }
      }
    });
  }

  void _createGuidePath() {
    final number = numbers[currentNumberIndex];
    guidePath.clear();
    currentGuideIndex = 0;

    switch (number) {
      case 0:
        // Oval shape for 0 (not perfect circle)
        for (double i = 0; i <= 1; i += 0.01) {
          final angle = i * 2 * pi;
          guidePath.add(Offset(
            200 + 120 * cos(angle), // Width: 240 (more oblong)
            200 + 80 * sin(angle), // Height: 160 (more oblong)
          ));
        }
        break;
      case 1:
        // Number 1 - from TOP to BOTTOM
        for (double i = 0; i <= 1; i += 0.01) {
          guidePath.add(Offset(
            200,
            50 + i * 300, // Start at top (50), go to bottom (350)
          ));
        }
        break;
      case 2:
        // Number 2 - with curvy top and proper shape
        // Top curve
        for (double i = 0; i <= 0.4; i += 0.01) {
          final angle = i * pi; // Half circle for the top curve
          guidePath.add(Offset(
            150 + 50 * cos(angle + pi), // Curved top
            100 + 30 * sin(angle),
          ));
        }
        // Diagonal down
        for (double i = 0.4; i <= 0.7; i += 0.01) {
          guidePath.add(Offset(
            200 - (i - 0.4) * 100,
            130 + (i - 0.4) * 100,
          ));
        }
        // Bottom curve
        for (double i = 0.7; i <= 1; i += 0.01) {
          final angle = (i - 0.7) * pi; // Half circle for bottom curve
          guidePath.add(Offset(
            170 + 30 * cos(angle),
            230 + 20 * sin(angle),
          ));
        }
        break;
      case 3:
        // Number 3 - two curves
        // Top curve
        for (double i = 0; i <= 0.5; i += 0.01) {
          final angle = i * pi;
          guidePath.add(Offset(
            150 + 50 * cos(angle + pi),
            120 + 30 * sin(angle),
          ));
        }
        // Bottom curve
        for (double i = 0.5; i <= 1; i += 0.01) {
          final angle = (i - 0.5) * pi;
          guidePath.add(Offset(
            150 + 50 * cos(angle + pi),
            180 + 30 * sin(angle),
          ));
        }
        break;
      case 4:
        // Number 4
        // Vertical line
        for (double i = 0; i <= 0.4; i += 0.01) {
          guidePath.add(Offset(150, 50 + i * 200));
        }
        // Horizontal line
        for (double i = 0.4; i <= 0.7; i += 0.01) {
          guidePath.add(Offset(150 + (i - 0.4) * 100, 130));
        }
        // Diagonal line
        for (double i = 0.7; i <= 1; i += 0.01) {
          guidePath.add(Offset(210 - (i - 0.7) * 60, 130 + (i - 0.7) * 170));
        }
        break;
      case 5:
        // Number 5
        // Top horizontal
        for (double i = 0; i <= 0.3; i += 0.01) {
          guidePath.add(Offset(150 + i * 100, 80));
        }
        // Curve
        for (double i = 0.3; i <= 0.6; i += 0.01) {
          final angle = (i - 0.3) * pi / 2;
          guidePath.add(Offset(250, 80 + 50 * sin(angle)));
        }
        // Vertical down
        for (double i = 0.6; i <= 1; i += 0.01) {
          guidePath.add(Offset(250, 130 + (i - 0.6) * 170));
        }
        break;
      case 6:
        // Number 6 - circle with tail
        // Curve
        for (double i = 0; i <= 0.7; i += 0.01) {
          final angle = i * 1.5 * pi;
          guidePath.add(Offset(200 + 70 * cos(angle), 200 + 70 * sin(angle)));
        }
        // Closing curve
        for (double i = 0.7; i <= 1; i += 0.01) {
          final angle = 1.5 * pi + (i - 0.7) * 0.5 * pi;
          guidePath.add(Offset(200 + 70 * cos(angle), 200 + 70 * sin(angle)));
        }
        break;
      case 7:
        // Number 7
        // Top horizontal
        for (double i = 0; i <= 0.3; i += 0.01) {
          guidePath.add(Offset(150 + i * 100, 80));
        }
        // Diagonal down
        for (double i = 0.3; i <= 1; i += 0.01) {
          guidePath.add(Offset(250 - (i - 0.3) * 100, 80 + (i - 0.3) * 220));
        }
        break;
      case 8:
        // Number 8 - two circles
        // Top circle
        for (double i = 0; i <= 0.5; i += 0.01) {
          final angle = i * 2 * pi;
          guidePath.add(Offset(200 + 50 * cos(angle), 150 + 40 * sin(angle)));
        }
        // Bottom circle
        for (double i = 0.5; i <= 1; i += 0.01) {
          final angle = i * 2 * pi;
          guidePath.add(Offset(200 + 60 * cos(angle), 250 + 50 * sin(angle)));
        }
        break;
      case 9:
        // Number 9 - circle with stem
        // Top circle
        for (double i = 0; i <= 0.7; i += 0.01) {
          final angle = i * 2 * pi;
          guidePath.add(Offset(200 + 60 * cos(angle), 150 + 50 * sin(angle)));
        }
        // Stem down
        for (double i = 0.7; i <= 1; i += 0.01) {
          guidePath.add(Offset(200, 200 + (i - 0.7) * 100));
        }
        break;
    }
  }

  void _skipGuide() {
    guideTimer?.cancel();
    setState(() {
      isGuiding = false;
    });
  }

  void _checkCompletion() {
    // More sophisticated completion check
    if (drawingPoints.length > 150 && !isCompleted) {
      setState(() {
        isCompleted = true;
      });
      _showCongratulations();
    }
  }

  void _showCongratulations() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/congratulations.gif',
                height: 120,
                width: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.celebration,
                  size: 80,
                  color: Colors.yellow,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Great Job!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontFamily: 'PencilChild',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You traced number ${numbers[currentNumberIndex]} perfectly!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'PencilChild',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _nextNumber();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextNumber() {
    if (currentNumberIndex < numbers.length - 1) {
      setState(() {
        currentNumberIndex++;
        isGuiding = true;
        isCompleted = false;
        drawingPoints.clear();
        _loadNumberImage();
        _startGuideAnimation();
      });
    } else {
      // All numbers completed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: const Text(
            'Congratulations!',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'You completed all numbers!',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _resetDrawing() {
    setState(() {
      drawingPoints.clear();
      isCompleted = false;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isGuiding && !isCompleted) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(details.globalPosition);

      setState(() {
        drawingPoints.add(localPosition);
      });
      _checkCompletion();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!isGuiding && !isCompleted) {
      setState(() {
        drawingPoints.add(Offset.infinite);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trace Number ${numbers[currentNumberIndex]}',
          style: const TextStyle(
            fontFamily: 'PencilChild',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            constraints: const BoxConstraints(
              minWidth: 50,
              minHeight: 50,
            ),
            child: EmbossedButton(
              imagePath: 'assets/settings_icon.png',
              onPressed: () => Navigator.pop(context),
              depth: 120,
              color: Colors.blue,
              radius: 15,
              imageSize: 24,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/game_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: CustomPaint(
                    size: const Size(400, 400),
                    painter: _TracingPainter(
                      numberImage: numberImage,
                      drawingPoints: drawingPoints,
                      guidePath: guidePath,
                      currentGuideIndex: currentGuideIndex,
                      isGuiding: isGuiding,
                      currentNumber: numbers[currentNumberIndex],
                      handImage: handImage,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (isGuiding)
                    ElevatedButton(
                      onPressed: _skipGuide,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      child: const Text(
                        'Skip Guide',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (!isGuiding && !isCompleted)
                        ElevatedButton(
                          onPressed: _resetDrawing,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      if (isCompleted)
                        ElevatedButton(
                          onPressed: _nextNumber,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            currentNumberIndex < numbers.length - 1
                                ? 'Next Number'
                                : 'Finish',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  final ui.Image? numberImage;
  final ui.Image? handImage;
  final List<Offset> drawingPoints;
  final List<Offset> guidePath;
  final int currentGuideIndex;
  final bool isGuiding;
  final int currentNumber;

  _TracingPainter({
    required this.numberImage,
    required this.handImage,
    required this.drawingPoints,
    required this.guidePath,
    required this.currentGuideIndex,
    required this.isGuiding,
    required this.currentNumber,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    // Draw number background
    if (numberImage != null) {
      final scale = 0.8;
      final scaledWidth = numberImage!.width * scale;
      final scaledHeight = numberImage!.height * scale;

      canvas.drawImageRect(
        numberImage!,
        Rect.fromLTWH(0, 0, numberImage!.width.toDouble(),
            numberImage!.height.toDouble()),
        Rect.fromCenter(
          center: center,
          width: scaledWidth,
          height: scaledHeight,
        ),
        Paint(),
      );
    } else {
      // Fallback: draw the number as text
      final textPainter = TextPainter(
        text: TextSpan(
          text: currentNumber.toString(),
          style: const TextStyle(
            fontSize: 100,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'PencilChild',
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2),
      );
    }

    // Draw guide path
    if (isGuiding && guidePath.isNotEmpty && currentGuideIndex > 0) {
      final guidePaint = Paint()
        ..color = Colors.yellow.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(guidePath[0].dx, guidePath[0].dy);

      for (int i = 1; i < currentGuideIndex; i++) {
        path.lineTo(guidePath[i].dx, guidePath[i].dy);
      }

      canvas.drawPath(path, guidePaint);

      // Draw guide hand
      if (currentGuideIndex < guidePath.length && handImage != null) {
        final handPosition = guidePath[currentGuideIndex];
        canvas.drawImage(
          handImage!,
          Offset(handPosition.dx - 20, handPosition.dy - 20),
          Paint(),
        );
      }
    }

    // Draw user's drawing
    if (drawingPoints.isNotEmpty) {
      final drawingPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      final path = Path();
      path.moveTo(drawingPoints[0].dx, drawingPoints[0].dy);

      for (int i = 1; i < drawingPoints.length; i++) {
        if (drawingPoints[i] != Offset.infinite &&
            drawingPoints[i - 1] != Offset.infinite) {
          path.lineTo(drawingPoints[i].dx, drawingPoints[i].dy);
        } else if (i + 1 < drawingPoints.length) {
          path.moveTo(drawingPoints[i + 1].dx, drawingPoints[i + 1].dy);
        }
      }

      canvas.drawPath(path, drawingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) {
    return oldDelegate.drawingPoints != drawingPoints ||
        oldDelegate.guidePath != guidePath ||
        oldDelegate.currentGuideIndex != currentGuideIndex ||
        oldDelegate.isGuiding != isGuiding ||
        oldDelegate.numberImage != numberImage ||
        oldDelegate.handImage != handImage;
  }
}
