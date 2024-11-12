
import 'package:flutter/material.dart';
import 'package:groundjp/widgets/draw/document.dart';
import 'package:groundjp/widgets/draw/resizable_container.dart';

class GuideLine extends StatefulWidget {

  final GuidelineItem item;
  final bool isDrawingMode;
  final Function()? closeEvent;
  const GuideLine({super.key, required this.item, required this.isDrawingMode, this.closeEvent});

  @override
  State<GuideLine> createState() => _GuideLineState();
}

class _GuideLineState extends State<GuideLine> {

  late FocusNode _focusNode;
  bool _isEditing = true;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.item.position.dx,
      top: widget.item.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (!widget.isDrawingMode) {
            setState(() {
              widget.item.position = Offset(
                widget.item.position.dx + details.delta.dx,
                widget.item.position.dy + details.delta.dy,
              );
            });
          }
        },
        onTap: () {
          if (!widget.isDrawingMode) {
            setState(() {
              _isEditing = true;  // 편집 모드 활성화
              _focusNode.requestFocus();  // TextField에 포커스 요청
            });
          }
        },
        child: ResizableWidget(
          initWidth: 200,
          closeEvent: widget.closeEvent,
          child: TextField(
            onEditingComplete: () {
              setState(() {
                _isEditing = false;  // 편집 완료 시 편집 모드 비활성화
                _focusNode.unfocus();  // 포커스 해제
              });
            },
            controller: widget.item.controller,
            focusNode: _focusNode,
            enabled: _isEditing && !widget.isDrawingMode,
            decoration: InputDecoration(
              fillColor: Colors.yellow.withOpacity(0.3),
              filled: true,
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
              hintText: '가이드라인 입력',
              hintStyle: const TextStyle(fontSize: 14),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
