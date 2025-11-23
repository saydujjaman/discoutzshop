import 'package:discountzshop/features/authentication/createAccount/screens/otpVerification.dart';
import 'package:discountzshop/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../../api/apiController.dart'; // Adjust import path

class DetailedInformation extends StatefulWidget {
  const DetailedInformation({super.key});

  @override
  State<DetailedInformation> createState() => _DetailedInformationState();
}

class _DetailedInformationState extends State<DetailedInformation> {
  bool _obscurePassword = true; // Track password visibility
  bool _isLoading = false; // Track loading state
  bool _termsAccepted = false; // Track Terms and Conditions checkbox

  // TextEditingControllers for form fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  // Handle Submit & Get OTP button press
  Future<void> _handleSubmitAndGetOtp() async {
    // Validate empty fields
    if (_fullNameController.text.trim().isEmpty) {
      _showSnackBar('Full Name cannot be empty');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar('Email cannot be empty');
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showSnackBar('Phone Number cannot be empty');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Password cannot be empty');
      return;
    }
    if (_repeatPasswordController.text.isEmpty) {
      _showSnackBar('Repeat Password cannot be empty');
      return;
    }
    if (!_termsAccepted) {
      _showSnackBar('Please accept the Terms and Conditions');
      return;
    }

    // Additional validations
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text.trim())) {
      _showSnackBar('Please enter a valid email');
      return;
    }
    if (!RegExp(r'^\+?1?\d{9,15}$').hasMatch(_phoneController.text.trim())) {
      _showSnackBar('Please enter a valid phone number');
      return;
    }
    if (_passwordController.text.length < 8) {
      _showSnackBar('Password must be at least 8 characters');
      return;
    }
    if (_passwordController.text != _repeatPasswordController.text) {
      _showSnackBar('Passwords do not match');
      return;
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });
    _showLoadingDialog();

    // Call sendEmailVerification from ApiController
    final apiController = ApiController();
    final result = await apiController.sendEmailVerification(email: _emailController.text.trim());

    // Hide loading indicator
    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog
      setState(() {
        _isLoading = false;
      });
    }

    // Handle API response
    if (result['statusCode'] == 200) {
      _showSnackBar('OTP sent successfully!', isSuccess: true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerification(
            email: _emailController.text.trim(),
            name: _fullNameController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _repeatPasswordController.text,
          ),
        ),
      );
    } else {
      _showSnackBar(result['message'] ?? 'Failed to send OTP. Please try again.');
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
              'Submitting...',
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Get Started Title
                Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Subtitle
                Text(
                  'By creating a free account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 30),
                // Full Name TextField
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                SizedBox(height: 20),
                // Valid Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Valid Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: 20),
                // Phone Number TextField
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                SizedBox(height: 20),
                // Strong Password TextField
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Strong Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Repeat Password TextField
                TextField(
                  controller: _repeatPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Repeat Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Terms and Conditions Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'By checking the box you agree to our Terms and Conditions.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Submit & Get OTP Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmitAndGetOtp,
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
                          'SUBMIT & GET OTP',
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
                SizedBox(height: 20),
                // Already a member? Log In
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to LoginScreen
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already a member? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(color: TColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}