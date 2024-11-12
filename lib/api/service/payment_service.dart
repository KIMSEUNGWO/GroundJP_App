
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/service/pipe_buffer.dart';
import 'package:groundjp/domain/enums/payment.dart';

class PaymentService extends PipeBuffer<PaymentService> {

  static final PaymentService instance = PaymentService();
  PaymentService();

  Future<ResponseResult> readyPayment({required int amount, required Payment payment}) async {
    return await ApiService.instance.get(
        uri: '/api/user/cash/charge/${payment.url}?amount=$amount',
        authorization: true
    );
  }

  @override
  PaymentService getService() {
    return this;
  }

}