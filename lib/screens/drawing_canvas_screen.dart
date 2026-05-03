import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/lesson.dart';
import 'lesson_passed_screen.dart';

class DrawingCanvasScreen extends StatefulWidget {
  final Lesson lesson;
  const DrawingCanvasScreen({super.key, required this.lesson});

  @override
  State<DrawingCanvasScreen> createState() => _DrawingCanvasScreenState();
}

class _DrawingCanvasScreenState extends State<DrawingCanvasScreen> {
  // Strokes persist across steps to build up the drawing layer by layer
  final List<DrawingStroke> _strokes = [];
  DrawingStroke? _currentStroke;
  
  int _currentStepIndex = 0;
  double _stepProgress = 0.0;
  double _brushSize = 6.0;
  bool _isEraser = false;
  
  @override
  Widget build(BuildContext context) {
    if (widget.lesson.steps.isEmpty) {
      return Scaffold(body: const Center(child: Text('No steps available.')));
    }

    final step = widget.lesson.steps[_currentStepIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Thick Top Progress Bar
            LinearProgressIndicator(
              value: _stepProgress,
              minHeight: 12,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation(Colors.green),
            ),
            
            Expanded(
              child: Row(
                children: [
                  // Left Vertical Sidebar
                  _buildLeftSidebar(),
                  
                  // Main Canvas Area
                  Expanded(
                    child: Stack(
                      children: [
                        // Faint Tracing Guide (Template)
                        Center(
                          child: Opacity(
                            opacity: 0.15, // Faint phantom line
                            child: CachedNetworkImage(
                              key: ValueKey(_currentStepIndex), // Force reload on step change
                              imageUrl: step.templateUrl ?? widget.lesson.thumbnailUrl,
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.8,
                              placeholder: (context, url) => const SizedBox(),
                              errorWidget: (context, url, error) => const SizedBox(),
                            ),
                          ),
                        ),
                        
                        // Interactive Drawing Canvas
                        _buildCanvas(),
                        
                        // Top Right Step Counter
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Text(
                            '${_currentStepIndex + 1}/${widget.lesson.steps.length}',
                            style: AppTextStyles.h2.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ),
                        
                        // Bottom Right Reference Thumbnail
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.surfaceContainerHigh, width: 2),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(widget.lesson.thumbnailUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 64,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.surfaceContainerHigh, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(Icons.pause_rounded, size: 28),
            onPressed: () => Navigator.pop(context),
            color: AppColors.onSurface,
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            onPressed: () {
              if (_strokes.isNotEmpty) setState(() => _strokes.removeLast());
            },
          ),
          IconButton(
            icon: const Icon(Icons.redo_rounded),
            onPressed: () {}, // Optional feature
            color: AppColors.onSurfaceVariant, // Disabled look for now
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  value: _brushSize,
                  min: 2.0,
                  max: 20.0,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.surfaceContainerHigh,
                  onChanged: (v) => setState(() => _brushSize = v),
                ),
              ),
            ),
          ),
          
          IconButton(
            icon: Icon(_isEraser ? Icons.cleaning_services_rounded : Icons.edit_rounded),
            color: _isEraser ? AppColors.primary : AppColors.onSurface,
            onPressed: () => setState(() => _isEraser = !_isEraser),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _currentStroke = DrawingStroke(
            points: [details.localPosition],
            color: _isEraser ? Colors.white : Colors.black, // Default stroke is always black in workout
            size: _isEraser ? 20.0 : _brushSize,
          );
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _currentStroke?.points.add(details.localPosition);
          
          // Tracing logic: Fill progress bar as user draws
          if (_stepProgress < 1.0) {
            _stepProgress += 0.005; // Requires some effort to trace
            if (_stepProgress >= 1.0) {
              _stepProgress = 1.0;
              _advanceToNextStep();
            }
          }
        });
      },
      onPanEnd: (_) {
        setState(() {
          if (_currentStroke != null) {
            _strokes.add(_currentStroke!);
            _currentStroke = null;
          }
        });
      },
      child: CustomPaint(
        painter: CanvasPainter(
          strokes: _strokes,
          currentStroke: _currentStroke,
        ),
        size: Size.infinite,
      ),
    );
  }

  void _advanceToNextStep() {
    bool isLastStep = _currentStepIndex == widget.lesson.steps.length - 1;
    if (isLastStep) {
      // Navigate immediately to the Lesson Passed screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LessonPassedScreen(lesson: widget.lesson)),
      );
    } else {
      // Seamlessly jump to the next step
      setState(() {
        _currentStepIndex++;
        _stepProgress = 0.0;
      });
    }
  }
}

class DrawingStroke {
  final List<Offset> points;
  final Color color;
  final double size;

  DrawingStroke({required this.points, required this.color, required this.size});
}

class CanvasPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;

  CanvasPainter({required this.strokes, this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (var stroke in strokes) {
      paint.color = stroke.color;
      paint.strokeWidth = stroke.size;
      _drawStroke(canvas, stroke.points, paint);
    }

    if (currentStroke != null) {
      paint.color = currentStroke!.color;
      paint.strokeWidth = currentStroke!.size;
      _drawStroke(canvas, currentStroke!.points, paint);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
