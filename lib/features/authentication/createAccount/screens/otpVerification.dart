import 'package:discountzshop/features/authentication/createAccount/screens/successScreen.dart';
import 'package:discountzshop/utils/constants/colors.dart';
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../api/apiController.dart'; // Adjust import path

class OTPVerification extends StatefulWidget {
  final String email;
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;

  const OTPVerification({
    super.key,
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  bool _isLoading = false; // Track loading state
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  // Handle Verify button press
  Future<void> _handleVerify() async {
    if (_otpController.text.trim().isEmpty) {
      _showSnackBar('OTP cannot be empty');
      return;
    }
    if (_otpController.text.length != 6) {
      _showSnackBar('OTP must be 6 digits');
      return;
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });
    _showLoadingDialog();

    // Call verifyEmail from ApiController
    final apiController = ApiController();
    final result = await apiController.verifyEmail(
      email: widget.email,
      otp: _otpController.text.trim(),
    );

    // Hide loading indicator
    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog
      setState(() {
        _isLoading = false;
      });
    }

    // Handle API response
    if (result['statusCode'] == 200) {
      _showSnackBar('Email verified successfully!', isSuccess: true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } else {
      _showSnackBar(result['message'] ?? 'Email verification failed. Please try again.');
    }
  }

  // Show SnackBar with message
  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(
              'Verifying...',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Almost There Title
              Text(
                'Almost There',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                'Please enter the 6-digit code sent to your email ${widget.email} for verification.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),
              // OTP Input (Single TextField)
              TextField(
                controller: _otpController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Resend Code Link with Timer
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive any code? ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Resend Again ',
                        style: TextStyle(color: TColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: TSizes.sm),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Request for new Code in ",
                    style: TextStyle(color: TColors.darkGrey),
                    children: [
                      TextSpan(
                        text: '00:20s',
                        style: TextStyle(color: TColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'VERIFY',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}