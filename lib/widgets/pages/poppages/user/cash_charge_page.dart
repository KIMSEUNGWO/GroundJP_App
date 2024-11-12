
import 'package:flutter/scheduler.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/service/payment_service.dart';
import 'package:groundjp/component/account_format.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/cash/kakao_ready_response.dart';
import 'package:groundjp/domain/enums/payment.dart';
import 'package:groundjp/notifier/notification_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/policy_widget.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:groundjp/widgets/webview/kakao_pay_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CashChargeWidget extends ConsumerStatefulWidget {
  const CashChargeWidget({super.key});

  @override
  createState() => _CashChargeWidgetState();
}

class _CashChargeWidgetState extends ConsumerState<CashChargeWidget> {

  final List<int> _amounts = [
    10000, 20000, 30000, 40000, 50000, 100000
  ];
  final List<Payment> _payments = Payment.values;

  int? _selectAmountIndex;
  int? _selectPaymentIndex;
  bool _selectPolicy = false;
  bool _canSubmit = false;
  bool _loading = false;

  _chargeCompleted() async {
    await ref.read(loginProvider.notifier).refreshCash();
    ref.read(notificationNotifier.notifier).show(
      id: 0, title: '캐시 충전',
      body: '충전이 완료되었습니다.\n충전수단: ${_payments[_selectPaymentIndex!].ko}\n충전금액: ${AccountFormatter.format(_amounts[_selectAmountIndex!])}',
    );
    if (mounted) {
      Alert.of(context).message(
        message: '결제가 완료되었습니다.',
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    }
  }

  _setAmount(int index) {
    setState(() =>_selectAmountIndex = index);
    _canSubmitCheck();
  }
  _setPayment(int index) {
    setState(() =>_selectPaymentIndex = index);
    _canSubmitCheck();
  }
  _checkPolicy(bool policy) {
    setState(() =>_selectPolicy = policy);
    _canSubmitCheck();
  }
  _canSubmitCheck() {
    setState(() {
      _canSubmit = _selectPolicy && _selectAmountIndex != null && _selectPaymentIndex != null;
    });
  }
  _setLoading(bool data) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _loading = data;
      });
    });

  }

  _submit() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    int amount = _amounts[_selectAmountIndex ?? 0];
    Payment payment = _payments[_selectPaymentIndex ?? 0];
    print('payment : $payment, amount : $amount');

    ResponseResult result = await PaymentService.instance.readyPayment(amount: amount, payment: payment);
    KakaoReady kakao = KakaoReady.fromJson(result.data);

    if (mounted) {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => KakaoPayWebView(kakao: kakao, loading: _setLoading, onSuccess: _chargeCompleted), fullscreenDialog: true)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('충전'),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SpaceHeight(36),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('잔액',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SpaceHeight(20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(AccountFormatter.format(ref.read(loginProvider.notifier).getCash()),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SpaceHeight(45),
                  DetailDefaultFormWidget(
                    title: '충전할 금액',
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2
                      ),
                      itemCount: _amounts.length,
                      itemBuilder: (context, index) {
                        int amount = _amounts[index];
                        return GestureDetector(
                          onTap: () {
                            _setAmount(index);
                          },
                          child: CustomContainer(
                            backgroundColor: _selectAmountIndex == index ? Theme.of(context).colorScheme.onPrimary : null,
                            child: Center(
                              child: Text(AccountFormatter.format(amount),
                                style: TextStyle(
                                  color: _selectAmountIndex == index ? Colors.white : Theme.of(context).colorScheme.primary,
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  fontWeight: _selectAmountIndex == index ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SpaceHeight(26),
                  DetailDefaultFormWidget(
                    title: '결제방식',
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2,
                      ),
                      itemCount: _payments.length,
                      itemBuilder: (context, index) {
                        Payment payment = _payments[index];
                        return GestureDetector(
                          onTap: () {
                            _setPayment(index);
                          },
                          child: CustomContainer(
                            backgroundColor: payment.backgroundColor,
                            border: _selectPaymentIndex == index
                              ? Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 4.sp,)
                              : null,
                            child: Center(
                              child: SvgIcon.asset(sIcon: payment.getLogo(),),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SpaceHeight(26),
                  PolicyWidget(canSubmit: _checkPolicy,),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: GestureDetector(
              onTap: () {
                if (_canSubmit) _submit();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration: BoxDecoration(
                  color: _canSubmit
                    ? Theme.of(context).colorScheme.onPrimary
                    : const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text('충전',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        if (_loading)
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111111).withOpacity(0.2)
              ),
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: CupertinoActivityIndicator(radius: 13,),
              ),
            ),
          ),
      ],
    );
  }
}
