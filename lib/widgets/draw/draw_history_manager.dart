import 'package:groundjp/widgets/draw/document.dart';

class DrawingHistoryManager {
  List<List<DrawingPoints?>> _undoHistory = [];
  List<List<DrawingPoints?>> _redoHistory = [];
  List<DrawingPoints?> _currentStroke = [];

  // 현재 그리기 상태
  bool isDrawing = false;

  // 모든 포인트를 가져오는 getter
  List<DrawingPoints?> get allPoints {
    if (_currentStroke.isEmpty) {
      return _undoHistory.expand((stroke) => stroke).toList();
    }
    return [..._undoHistory.expand((stroke) => stroke), ..._currentStroke];
  }

  // 현재 스트로크 시작
  void startStroke(DrawingPoints point) {
    isDrawing = true;
    _currentStroke = [point];
    _redoHistory.clear(); // 새로운 스트로크가 시작되면 redo 히스토리 초기화
  }

  // 현재 스트로크에 포인트 추가
  void addPoint(DrawingPoints point) {
    if (isDrawing) {
      _currentStroke.add(point);
    }
  }

  // 현재 스트로크 종료
  void endStroke() {
    if (isDrawing) {
      _currentStroke.add(null); // stroke 종료 표시
      _undoHistory.add(List<DrawingPoints?>.from(_currentStroke));
      _currentStroke = [];
      isDrawing = false;
    }
  }

  // 되돌리기
  bool undo() {
    if (_undoHistory.isEmpty) return false;

    final lastStroke = _undoHistory.removeLast();
    _redoHistory.add(lastStroke);
    return true;
  }

  // 다시하기
  bool redo() {
    if (_redoHistory.isEmpty) return false;

    final nextStroke = _redoHistory.removeLast();
    _undoHistory.add(nextStroke);
    return true;
  }

  // 모든 그리기 내용 지우기
  void clear() {
    _undoHistory.clear();
    _redoHistory.clear();
    _currentStroke = [];
    isDrawing = false;
  }

  // 되돌리기 가능 여부
  bool get canUndo => _undoHistory.isNotEmpty;

  // 다시하기 가능 여부
  bool get canRedo => _redoHistory.isNotEmpty;
}