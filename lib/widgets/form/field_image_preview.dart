
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageSlider extends StatefulWidget {

  final List<Widget> images;
  final ImageSliderOption? option;

  const ImageSlider({super.key, required this.images, this.option});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

  int _currentImageIndex = 1;

  void onImageChanged(int index) {
    setState(() => _currentImageIndex = index);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.option?.width ?? double.infinity,
      clipBehavior: Clip.hardEdge,
      height: widget.option?.height?.h ?? 280.h,
      decoration: BoxDecoration(
          borderRadius: widget.option?.borderRadius ?? BorderRadius.circular(20),
          color: Colors.white
      ),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1, // 각 슬라이드의 크기 조정 (0.8 = 80%)
              height: double.infinity,
              disableCenter: true,
              autoPlay: widget.option?.autoplay ?? true,
              autoPlayInterval: widget.option?.autoPlayInterval ?? const Duration(seconds: 7),
              scrollDirection: widget.option?.scrollDirection ?? Axis.horizontal,
              onPageChanged: (index, reason) {
                onImageChanged(index + 1);
              },
            ),
            items: widget.images,
          ),

          Positioned(
            bottom: 10.h, right: 15.w,
            child: Container(
              width: 45.w,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF252525).withOpacity(0.7),
              ),
              child: Skeleton.ignore(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$_currentImageIndex',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                    Text(' / ${widget.images.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ImageSliderOption {

  double? width;
  double? height;
  bool? autoplay;
  Duration? autoPlayInterval;
  Axis? scrollDirection;
  BorderRadiusGeometry? borderRadius;

  ImageSliderOption(
      {this.width,
      this.height,
      this.autoplay,
      this.autoPlayInterval,
      this.borderRadius,
      this.scrollDirection});
}