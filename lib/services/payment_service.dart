import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentService {
  static final Razorpay _razorpay = Razorpay();
  static Function? onPaymentSuccess;
  static Function? onPaymentError;
  static Function? onPaymentWaiting;

  static void initialize() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Payment Successful! ID: ${response.paymentId}');
    onPaymentSuccess?.call(response.paymentId);
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'Payment Failed: ${response.message}');
    onPaymentError?.call(response.message);
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'External Wallet: ${response.walletName}');
  }

  static void openRazorpayCheckout({
    required String courseTitle,
    required double amount,
    required String email,
    required String phone,
    String? razorpayKeyId,
  }) {
    var options = {
      'key': razorpayKeyId ?? 'rzp_live_YOUR_KEY_ID',
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': 'Vimal Coaching Institute',
      'description': courseTitle,
      'prefill': {
        'email': email,
        'contact': phone,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  static void dispose() {
    _razorpay.clear();
  }
}
