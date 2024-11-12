
import 'dart:ffi';

import 'package:groundjp/component/account_format.dart';
import 'package:groundjp/domain/order/order_result.dart';
import 'package:flutter/material.dart';

class OrderCompleteWidget extends StatefulWidget {

  final OrderResult orderResult;

  const OrderCompleteWidget({super.key, required this.orderResult});

  @override
  State<OrderCompleteWidget> createState() => _OrderCompleteWidgetState();
}

class _OrderCompleteWidgetState extends State<OrderCompleteWidget> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  animationIcon() async {
    await Future.delayed(const Duration(microseconds: 500));
    _controller.forward();
  }
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    animationIcon();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('결제완료'),
          // automaticallyImplyLeading: false, // 뒤로가기 숨김
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100,),
              Column(
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF52CA3E),
                        size: 100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text('결제가 완료되었습니다.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: Theme.of(context).textTheme.displayLarge!.fontSize
                    ),
                  )
                ],
              ),
              const SizedBox(height: 60,),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.symmetric(horizontal: BorderSide(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                      ))
                    ),
                    child: Column(
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('이용금액',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(AccountFormatter.format(widget.orderResult.totalPrice),
                              style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        if (widget.orderResult.coupon != null)
                          const SizedBox(height: 8,),
                        if (widget.orderResult.coupon != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('(쿠폰) ${widget.orderResult.coupon!.title}',
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                    fontWeight: FontWeight.w500
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text(AccountFormatter.format(-1 * widget.orderResult.coupon!.discount),
                                style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('결제금액',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(AccountFormatter.format(widget.orderResult.finalPrice),
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('남은잔액',
                                style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                    fontWeight: FontWeight.w500
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(AccountFormatter.format(widget.orderResult.remainCash),
                              style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: GestureDetector(
            onTap: () {

            },
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text('홈으로',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
