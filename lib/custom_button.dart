import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Embossed Button Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmbossedButtonDemo(),
    );
  }
}

class EmbossedButtonDemo extends StatefulWidget {
  const EmbossedButtonDemo({super.key});

  @override
  State<EmbossedButtonDemo> createState() => _EmbossedButtonDemoState();
}

class _EmbossedButtonDemoState extends State<EmbossedButtonDemo> {
  double _imageSize = 24.0;
  bool _showImage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Embossed Button with Image'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              EmbossedButton(
                text: 'Dynamic Button',
                imagePath: _showImage ? 'assets/flutter_logo.png' : null,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Button Pressed!')),
                  );
                },
                imageSize: _imageSize,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Image:'),
                  Switch(
                    value: _showImage,
                    onChanged: (value) {
                      setState(() {
                        _showImage = value;
                      });
                    },
                  ),
                ],
              ),
              Text('Image Size: ${_imageSize.toStringAsFixed(1)}'),
              Slider(
                value: _imageSize,
                min: 16,
                max: 100,
                divisions: 12,
                label: _imageSize.toStringAsFixed(1),
                onChanged: _showImage
                    ? (double value) {
                        setState(() {
                          _imageSize = value;
                        });
                      }
                    : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class EmbossedButton extends StatefulWidget {
  final String? text;
  final String? imagePath;
  final VoidCallback onPressed;
  final double radius;
  final double depth;
  final Color color;
  final double? width;
  final double imageSize;

  const EmbossedButton({
    super.key,
    this.text,
    this.imagePath,
    required this.onPressed,
    this.radius = 20,
    this.depth = 84,
    this.color = const Color(0xFFFF8000),
    this.width,
    this.imageSize = 24.0,
  }) : assert(text != null || imagePath != null,
            'Either text or imagePath must be provided');

  @override
  State<EmbossedButton> createState() => _EmbossedButtonState();
}

class _EmbossedButtonState extends State<EmbossedButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final depth = _isPressed ? widget.depth * 0.6 : widget.depth;

    // Calculate dynamic padding based on image size
    final verticalPadding = 16.0 +
        (widget.imageSize > 40 && widget.imagePath != null
            ? widget.imageSize / 6
            : 0);
    final horizontalPadding = 32.0;

    // Calculate the minimum width needed to accommodate the content
    final textWidth = widget.text != null
        ? _calculateTextWidth(
            widget.text!,
            TextStyle(
              fontFamily: 'PencilChild',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ))
        : 0;

    // Only consider image size if there's actually an image
    final imageWidth = widget.imagePath != null ? widget.imageSize : 0;

    final minContentWidth = max(
        imageWidth + horizontalPadding * 2, textWidth + horizontalPadding * 2);

    final buttonWidth = widget.width ?? minContentWidth;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_isPressed ? -0.05 : -0.1)
            ..rotateY(_isPressed ? -0.05 : -0.1),
          alignment: FractionalOffset.center,
          child: CustomPaint(
            painter: _EmbossPainter(
              radius: widget.radius,
              depth: depth,
              color: widget.color,
              isPressed: _isPressed,
            ),
            child: Container(
              width: buttonWidth,
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              constraints: BoxConstraints(
                minWidth: minContentWidth,
                minHeight: (widget.imagePath != null ? widget.imageSize : 0) +
                    verticalPadding * 2 +
                    (widget.text != null ? 28 : 0),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.imagePath != null)
                      Image.asset(
                        widget.imagePath!,
                        width: widget.imageSize,
                        height: widget.imageSize,
                        color: null,
                      ),
                    if (widget.imagePath != null && widget.text != null)
                      SizedBox(height: widget.imageSize > 40 ? 12 : 8),
                    if (widget.text != null)
                      Text(
                        widget.text!,
                        style: TextStyle(
                          fontFamily: 'PencilChild',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFE6A9),
                          shadows: [
                            Shadow(
                              offset: Offset(0, _isPressed ? 1 : 2),
                              blurRadius: _isPressed ? 5 : 12,
                              color: Colors.black
                                  .withOpacity(_isPressed ? 0.4 : 0.6),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }
}

class _EmbossPainter extends CustomPainter {
  final double radius;
  final double depth;
  final Color color;
  final bool isPressed;

  _EmbossPainter({
    required this.radius,
    required this.depth,
    required this.color,
    required this.isPressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // Draw the stroke
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = const Color(0xFFFFE6A9);
    canvas.drawRRect(rrect, strokePaint);

    // Base fill with gradient
    final basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          Color.alphaBlend(Colors.black.withOpacity(0.1), color),
        ],
      ).createShader(rect);
    canvas.drawRRect(rrect, basePaint);

    canvas.save();
    canvas.clipRRect(rrect);

    final k = depth / 84.0;
    final innerOpacity = 0.35 * k;
    final highlightOpacity = 0.55 * k;

    // Highlight color based on button color
    final highlight = Colors.white.withOpacity(highlightOpacity);
    final shadow = Colors.black.withOpacity(innerOpacity);

    // Inner highlight (top-left)
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.center,
        colors: [highlight, Colors.transparent],
        stops: const [0.0, 0.65],
      ).createShader(Rect.fromLTWH(
          -depth, -depth, size.width + depth * 2, size.height + depth * 2))
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(
        Rect.fromLTWH(
            -depth, -depth, size.width + depth * 2, size.height + depth * 2),
        highlightPaint);

    // Inner shadow (bottom-right)
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.center,
        colors: [shadow, Colors.transparent],
        stops: const [0.0, 0.75],
      ).createShader(Rect.fromLTWH(
          -depth, -depth, size.width + depth * 2, size.height + depth * 2))
      ..blendMode = BlendMode.multiply;
    canvas.drawRect(
        Rect.fromLTWH(
            -depth, -depth, size.width + depth * 2, size.height + depth * 2),
        shadowPaint);

    // Optional rim
    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.3 * k),
          Colors.black.withOpacity(0.3 * k),
        ],
      ).createShader(rect)
      ..blendMode = BlendMode.overlay;
    canvas.drawRRect(rrect.deflate(0.5), rim);

    canvas.restore();

    // Outer shadow for lift
    final path = Path()..addRRect(rrect);
    canvas.drawShadow(path, Colors.black.withOpacity(0.35), 8.0, true);
  }

  @override
  bool shouldRepaint(covariant _EmbossPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.depth != depth ||
        oldDelegate.color != color ||
        oldDelegate.isPressed != isPressed;
  }
}
