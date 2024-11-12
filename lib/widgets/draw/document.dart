import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundjp/widgets/component/image_detail_view.dart';
import 'package:groundjp/widgets/draw/draw_history_manager.dart';
import 'package:groundjp/widgets/draw/guide_line.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/**
 * https://claude.ai/chat/262eee22-ddab-4bcd-9461-5cffc90b8cc8
 * 관련정보
 */
class DocumentDrawingApp extends StatefulWidget {

  final String imageLink;
  const DocumentDrawingApp({super.key, required this.imageLink});

  @override
  State<DocumentDrawingApp> createState() => _DocumentDrawingAppState();
}

class _DocumentDrawingAppState extends State<DocumentDrawingApp> {
  List<DrawingPoints?> points = [];
  List<GuidelineItem> guidelines = [];
  bool showGuidelines = true;
  bool isDrawingMode = false;

  GlobalKey globalKey = GlobalKey();

  // 확대/축소 관련 변수
  double _scale = 1.0;
  late TransformationController _transformationController;

  Color selectedColor = Colors.black;
  double strokeWidth = 1.0;

  bool _isScaling = true;

  // 현재 포인터 개수를 추적
  int _pointerCount = 0;

  Size? _originalImageSize;
  Size? _displaySize;


  // 되돌리기 매니저
  final DrawingHistoryManager historyManager = DrawingHistoryManager();
  late FocusNode _focusNode;

  ui.Image? baseImage;


  Future<void> _saveDrawing() async {
    try {
      setState(() {
        showGuidelines = false;
      });

      // 이미지와 드로잉 합성
      final mergedImageBytes = await _mergeImageAndDrawing();

      // 서버로 전송
      await _uploadToServer(mergedImageBytes);

      setState(() {
        showGuidelines = true;
      });
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
      );
    }
  }
  Future<void> _loadBaseImage() async {
    final ByteData data = await rootBundle.load(widget.imageLink);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      baseImage = fi.image;
      _originalImageSize = Size(baseImage!.width.toDouble(), baseImage!.height.toDouble());
    });
  }
  // 화면 좌표를 실제 이미지 좌표로 변환
  Offset _convertToImageCoordinate(Offset displayPoint) {
    if (_originalImageSize == null || _displaySize == null) return displayPoint;

    // 화면 크기와 실제 이미지 크기의 비율만 계산
    final double scaleX = _originalImageSize!.width / _displaySize!.width;
    final double scaleY = _originalImageSize!.height / _displaySize!.height;

    // 단순히 비율만 적용하여 변환
    return Offset(
      displayPoint.dx * scaleX,
      displayPoint.dy * scaleY,
    );
  }

  Future<Uint8List> _mergeImageAndDrawing() async {
    if (baseImage == null) return Uint8List(0);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 원본 이미지 크기로 캔버스 생성
    final size = Size(baseImage!.width.toDouble(), baseImage!.height.toDouble());

    // 1. 기본 이미지 그리기
    canvas.drawImage(baseImage!, Offset.zero, Paint());

    // 2. 모든 드로잉 포인트를 이미지 좌표계로 변환
    List<DrawingPoints?> scaledPoints = points.map((point) {
      if (point == null) return null;

      final scaledOffset = _convertToImageCoordinate(point.points);
      return DrawingPoints(
        points: scaledOffset,
        paint: Paint()
          ..color = point.paint.color
          ..strokeCap = point.paint.strokeCap
          ..strokeWidth = point.paint.strokeWidth * (_originalImageSize!.width / _displaySize!.width)
          ..isAntiAlias = true,
      );
    }).toList();

    // 3. 변환된 좌표로 드로잉
    for (int i = 0; i < scaledPoints.length - 1; i++) {
      if (scaledPoints[i] != null && scaledPoints[i + 1] != null) {
        canvas.drawLine(
          scaledPoints[i]!.points,
          scaledPoints[i + 1]!.points,
          scaledPoints[i]!.paint,
        );
      } else if (scaledPoints[i] != null && scaledPoints[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [scaledPoints[i]!.points],
          scaledPoints[i]!.paint,
        );
      }
    }


    // 4. 이미지로 변환
    final picture = recorder.endRecording();
    final mergedImage = await picture.toImage(
      baseImage!.width,
      baseImage!.height,
    );

    final byteData = await mergedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return byteData!.buffer.asUint8List();
  }
  // 서버로 이미지 전송
  Future<void> _uploadToServer(Uint8List imageBytes) async {
    try {
      // 이미지를 base64로 인코딩
      String base64Image = base64Encode(imageBytes);

      // API 엔드포인트 설정
      Uri url = Uri.parse('YOUR_API_ENDPOINT');

      // 멀티파트 요청 생성
      var request = http.MultipartRequest('POST', url);

      Image image = Image.memory(imageBytes);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageDetailView(image: image);
      },));
      // 파일 추가
      // request.files.add(
      //   http.MultipartFile.fromBytes(
      //     'image',
      //     imageBytes,
      //     filename: 'document.png',
      //   ),
      // );
      //
      // // 추가 메타데이터가 필요한 경우
      // request.fields['timestamp'] = DateTime.now().toIso8601String();
      //
      // // 요청 전송
      // var response = await request.send();
      //
      // if (response.statusCode == 200) {
      //   // 성공 처리
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('문서가 성공적으로 저장되었습니다.')),
      //   );
      // } else {
      //   // 에러 처리
      //   throw Exception('서버 에러: ${response.statusCode}');
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: ${e.toString()}')),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _loadBaseImage();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleUndo() {
    if (historyManager.undo()) {
      setState(() {
        points = historyManager.allPoints;
      });
    }
  }

  void _handleRedo() {
    if (historyManager.redo()) {
      setState(() {
        points = historyManager.allPoints;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문서 작성'),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: historyManager.canUndo ? _handleUndo : null,
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: historyManager.canRedo ? _handleRedo : null,
          ),
          IconButton(
            icon: Icon(isDrawingMode ? Icons.edit : Icons.draw),
            onPressed: () {
              setState(() {
                isDrawingMode = !isDrawingMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                showGuidelines = !showGuidelines;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveDrawing,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              historyManager.clear();
              setState(() {
                points.clear();
              });
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 이미지 비율에 맞는 크기 계산
          double imageWidth = constraints.maxWidth;
          double imageHeight = constraints.maxWidth * (_originalImageSize?.height ?? 1) / (_originalImageSize?.width ?? 1);

          // 계산된 이미지 크기를 화면 크기와 비교하여 조정
          if (imageHeight > constraints.maxHeight) {
            imageHeight = constraints.maxHeight;
            imageWidth = imageHeight * (_originalImageSize?.width ?? 1) / (_originalImageSize?.height ?? 1);
          }

          // 실제 표시 크기 저장
          _displaySize = Size(imageWidth, imageHeight);

          Image a = Image.asset(widget.imageLink,
            fit: BoxFit.contain,
          );
          return Listener(
            onPointerDown: (event) {
              setState(() {
                _pointerCount++;
              });
            },
            onPointerUp: (event) {
              setState(() {
                _pointerCount--;
              });
            },
            child: InteractiveViewer(
              transformationController: _transformationController,
              scaleEnabled: true,
              panEnabled: _isScaling,
              minScale: 1,
              maxScale: 5,
              onInteractionStart: (details) {
                int count = details.pointerCount;
                setState(() {
                  _isScaling = count == 2;
                });
              },
              onInteractionUpdate: (details) {
                if (!_isScaling) return;
                _scale = _transformationController.value.getMaxScaleOnAxis();
              },
              onInteractionEnd: (details) {
                print('interactionEnd pointerCount : ${details.pointerCount}');
                setState(() {
                  _isScaling = false;
                });
              },
              child: Stack(
                children: [
                  // 기본 문서 이미지

                  Image.asset(
                    widget.imageLink,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.fill,
                  ),

                  // 가이드라인 레이어
                  if (showGuidelines)
                    ...guidelines.map((guideline) {
                      return GuideLine(
                        item: guideline,
                        isDrawingMode: isDrawingMode,
                        closeEvent: () {
                          setState(() {
                            guidelines.remove(guideline);
                          });
                        },
                      );
                    }),

                  // 드로잉 레이어
                  if (isDrawingMode)
                    Listener(
                      onPointerDown: (details) {
                        // 첫 번째 터치일 때만 드로잉 시작
                        if (_pointerCount == 0 && !_isScaling) {
                          // 약간의 지연을 주어 확대/축소 동작과 구분
                          Future.delayed(const Duration(milliseconds: 50), () {
                            // 여전히 한 손가락이고 스케일링 모드가 아닐 때만 드로잉 시작
                            if (_pointerCount == 1 && !_isScaling) {
                              final point = DrawingPoints(
                                points: details.localPosition,
                                paint: Paint()
                                  ..color = selectedColor
                                  ..strokeCap = StrokeCap.round
                                  ..strokeWidth = strokeWidth
                                  ..isAntiAlias = true,
                              );
                              historyManager.startStroke(point);
                              setState(() {
                                points = historyManager.allPoints;
                              });
                            }
                          });
                        }
                      },
                      onPointerMove: (details) {
                        // 한 손가락이고 드로잉 중일 때만 계속 그리기
                        if (_pointerCount == 1 && !_isScaling && historyManager.isDrawing) {
                          final point = DrawingPoints(
                            points: details.localPosition,
                            paint: Paint()
                              ..color = selectedColor
                              ..strokeCap = StrokeCap.round
                              ..strokeWidth = strokeWidth
                              ..isAntiAlias = true,
                          );
                          historyManager.addPoint(point);
                          setState(() {
                            points = historyManager.allPoints;
                          });
                        }
                      },
                      onPointerUp: (details) {
                        if (historyManager.isDrawing) {
                          historyManager.endStroke();
                          setState(() {
                            points = historyManager.allPoints;
                          });
                        }
                      },
                      child: CustomPaint(
                        size: _displaySize!,
                        painter: DrawingPainter(
                          pointsList: points,
                          scale: _scale,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isDrawingMode)
            FloatingActionButton(
              onPressed: _addGuideline,
              child: Icon(Icons.add),
              tooltip: '가이드라인 추가',
            ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _transformationController.value = Matrix4.identity();
              setState(() {
                _scale = 1.0;
              });
            },
            child: Icon(Icons.refresh),
            tooltip: '확대/축소 초기화',
          ),
        ],
      ),
      bottomNavigationBar: isDrawingMode ? SafeArea(
        child: Container(
          height: 50,
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.color_lens),
                onPressed: _showColorPicker,
              ),
              Slider(
                min: 1.0,
                max: 7.0,
                value: strokeWidth,
                onChanged: (val) {
                  setState(() {
                    strokeWidth = val;
                  });
                },
              ),
            ],
          ),
        ),
      ) : null,
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('펜 색상 선택'),
        content: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorButton(Colors.black),
              _buildColorButton(Colors.blue),
              _buildColorButton(Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  void _addGuideline() {
    setState(() {
      guidelines.add(GuidelineItem(
        position: Offset(100, 100),
        controller: TextEditingController(),
      ));
    });
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoints?> pointsList;
  final double scale;

  DrawingPainter({
    required this.pointsList,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(
          pointsList[i]!.points,
          pointsList[i + 1]!.points,
          pointsList[i]!.paint,
        );
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [pointsList[i]!.points],
          pointsList[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
class DrawingPoints {
  Offset points;
  Paint paint;

  DrawingPoints({required this.points, required this.paint});
}

class GuidelineItem {
  Offset position;
  TextEditingController controller;

  GuidelineItem({
    required this.position,
    required this.controller,
  });
}
