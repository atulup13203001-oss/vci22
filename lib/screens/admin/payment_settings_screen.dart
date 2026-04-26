import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vimal_coaching_institute/services/firebase_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentSettingsScreen extends StatefulWidget {
  const PaymentSettingsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends State<PaymentSettingsScreen> {
  final _razorpayKeyController = TextEditingController();
  final _razorpaySecretController = TextEditingController();
  final _upiIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await FirebaseService.getPaymentSettings();
    if (settings != null) {
      setState(() {
        _razorpayKeyController.text = settings['razorpay_key_id'] ?? '';
        _razorpaySecretController.text = settings['razorpay_key_secret'] ?? '';
        _upiIdController.text = settings['upi_id'] ?? '';
      });
    }
  }

  Future<void> _saveSettings() async {
    if (_razorpayKeyController.text.isEmpty ||
        _razorpaySecretController.text.isEmpty ||
        _upiIdController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseService.updatePaymentSettings({
        'razorpay_key_id': _razorpayKeyController.text,
        'razorpay_key_secret': _razorpaySecretController.text,
        'upi_id': _upiIdController.text,
        'updated_at': DateTime.now().toIso8601String(),
      });
      Fluttertoast.showToast(msg: 'Settings saved successfully');
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving settings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _razorpayKeyController.dispose();
    _razorpaySecretController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Settings'),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Razorpay Section
              Text(
                'Razorpay Configuration',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Razorpay Key ID',
                _razorpayKeyController,
                'Enter your Razorpay Key ID',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Razorpay Key Secret',
                _razorpaySecretController,
                'Enter your Razorpay Key Secret',
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // UPI Section
              Text(
                'UPI Configuration',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'UPI ID',
                _upiIdController,
                'Enter UPI ID (e.g., yourname@bank)',
              ),
              const SizedBox(height: 24),

              // Info Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Payment Gateway Setup',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Get your Razorpay credentials from https://dashboard.razorpay.com\n'
                      '2. Add your UPI ID for direct UPI transfers\n'
                      '3. Save these settings to enable payments',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Save Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
