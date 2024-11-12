

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class Alert {

  final BuildContext context;
  Alert.of(this.context);

  void confirm({required String message, required String btnMessage, required Function() onPressed, Function()? onCanceled}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.sp),
            ),
            elevation: 0,
            child: SizedBox(
              width: 100.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                    child: Text(message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 45.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.sp),
                        bottomRight: Radius.circular(20.sp),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (onCanceled != null) {
                                  onCanceled();
                                }
                                Navigator.of(context).pop(false);
                              },
                              splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                              highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      top: alertBorderSide,
                                      right: alertBorderSide
                                  ),
                                ),
                                child: Center(
                                  child: Text('취소',
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                onPressed();
                              },
                              splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                              highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      top: alertBorderSide
                                  ),
                                ),
                                child: Center(
                                  child: Text(btnMessage,
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            )
        );
      },
    );
  }
  void message({required String message, VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.sp),
          ),
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                child: Text(message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 45.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.sp),
                    bottomRight: Radius.circular(20.sp),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(false);
                      if (onPressed != null) {
                        onPressed();
                      }
                    },
                    splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                    highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(top: alertBorderSide,),
                      ),
                      child: Center(
                        child: Text('확인',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        );
      },
      barrierDismissible: false,
    );
  }
  static BorderSide alertBorderSide = const BorderSide(
      color: Colors.grey,
      width: 0.2
  );
}