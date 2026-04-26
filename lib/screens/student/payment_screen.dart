import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/models/course_model.dart';
import 'package:vimal_coaching_institute/models/ebook_model.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';
import 'package:vimal_coaching_institute/services/payment_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late dynamic item; // Can be Course or Ebook
  late String itemTitle;
  late double amount;
  late String itemType; // 'course' or 'ebook'
  String _selectedPaymentMethod = 'razorpay';

  @override
  void initState() {
    super.initState();
    item = Get.arguments;
    
    if (item is Course) {
      itemType = 'course';
      itemTitle = item.title;
      amount = item.price;
    } else if (item is Ebook) {
      itemType = 'ebook';
      itemTitle = item.title;
      amount = item.price;
    }

    PaymentService.initialize();
    _setupPaymentCallbacks();
  }

  void _setupPaymentCallbacks() {
    PaymentService.onPaymentSuccess = (paymentId) {
      _handlePaymentSuccess(paymentId);
    };

    PaymentService.onPaymentError = (error) {
      Fluttertoast.showToast(msg: 'Payment failed: $error');
    };
  }

  Future<void> _handlePaymentSuccess(String paymentId) async {
    final user = FirebaseService.getCurrentUser();
    if (user == null) return;

    try {
      if (itemType == 'course') {
        await FirebaseService.enrollStudent(
          user.id,
          item.id,
          item.validityDays,
        );
      } else if (itemType == 'ebook') {
        await FirebaseService.purchaseEbook(
          user.id,
          item.id,
          amount,
          paymentId,
        );
      }

      Fluttertoast.showToast(msg: 'Payment successful!');
      Get.back();
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving purchase: $e');
    }
  }

  Future<void> _processRazorpayPayment() async {
    final user = FirebaseService.getCurrentUser();
    if (user == null) return;

    final settings = await FirebaseService.getPaymentSettings();
    final razorpayKeyId = settings?['razorpay_key_id'] ?? '';

    PaymentService.openRazorpayCheckout(
      courseTitle: itemTitle,
      amount: amount,
      email: user.email,
      phone: user.phone,
      razorpayKeyId: razorpayKeyId,
    );
  }

  Future<void> _processUPIPayment() async {
    Fluttertoast.showToast(
      msg: 'UPI Payment feature coming soon',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            itemTitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '₹$amount',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '₹$amount',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFFFF9500),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method Selection
              Text(
                'Select Payment Method',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // Razorpay Option
              GestureDetector(
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'razorpay');
                },
                child: Card(
                  color: _selectedPaymentMethod == 'razorpay'
                      ? const Color(0xFFFF9500).withOpacity(0.1)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Radio(
                          value: 'razorpay',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() => _selectedPaymentMethod = value ?? 'razorpay');
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Razorpay',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Card, UPI, Wallet',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // UPI Option
              GestureDetector(
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'upi');
                },
                child: Card(
                  color: _selectedPaymentMethod == 'upi'
                      ? const Color(0xFFFF9500).withOpacity(0.1)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Radio(
                          value: 'upi',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() => _selectedPaymentMethod = value ?? 'upi');
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UPI Payment',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Google Pay, PhonePe, Paytm',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedPaymentMethod == 'razorpay') {
                      _processRazorpayPayment();
                    } else {
                      _processUPIPayment();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9500),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Security Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your payment is secure and encrypted',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    PaymentService.dispose();
    super.dispose();
  }
}
