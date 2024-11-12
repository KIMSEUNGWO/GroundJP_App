
import 'package:flutter/material.dart';

class ImageDetailView extends StatelessWidget {

  final Image image;

  const ImageDetailView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true, // 패닝 가능 여부
                scaleEnabled: true, // 확대/축소 가능 여부
                minScale: 1.0,
                maxScale: 4.0,
                child: Image(image: image.image, fit: BoxFit.contain,), // 최대 확대 비율
              ),
            ),
            Positioned(
              top: 20, right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 30,),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class SwipeablePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  SwipeablePageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 애니메이션을 위한 커스텀 트랜지션
      final begin = Offset(0.0, 1.0);
      final end = Offset.zero;
      final curve = Curves.easeInOut;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      final slideTransition = SlideTransition(position: offsetAnimation, child: child);

      return slideTransition;
    },
  );
}

