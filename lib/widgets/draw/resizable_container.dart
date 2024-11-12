import 'package:flutter/material.dart';

class ResizableWidget extends StatefulWidget {
  final Widget child;
  final double initWidth;
  final Function()? closeEvent;

  const ResizableWidget({super.key,
    required this.child,
    required this.initWidth,
    this.closeEvent,
  });

  @override
  createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  late double width;
  static const double minWidth = 100.0;
  static const double maxWidth = 400.0;

  @override
  void initState() {
    super.initState();
    width = widget.initWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: width,
          child: widget.child,
        ),
        // 크기 조절 핸들
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                width += details.delta.dx;
                // 최소/최대 너비 제한
                width = width.clamp(minWidth, maxWidth);
                // widget.onResize(Size(width, 0)); // 크기 변경 콜백
              });
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.drag_handle,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),

        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              if (widget.closeEvent != null) widget.closeEvent!();
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
