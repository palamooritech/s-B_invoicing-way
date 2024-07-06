import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isEmailVerified = false;

  // Function to send OTP to the email
  void _sendOtp() {
    // Implement the logic to send OTP to the email
    setState(() {
      _isOtpSent = true;
    });
  }

  // Function to verify the OTP
  void _verifyOtp() {
    // Implement the logic to verify the OTP
    setState(() {
      _isEmailVerified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: _sendOtp,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!_isEmailVerified) {
              return 'Please verify your email';
            }
            return null;
          },
        ),
        if (_isOtpSent) ...[
          TextFormField(
            controller: _otpController,
            decoration: InputDecoration(
              labelText: 'Enter OTP',
            ),
          ),
          ElevatedButton(
            onPressed: _verifyOtp,
            child: Text('Verify OTP'),
          ),
        ],
      ],
    );
  }
}
