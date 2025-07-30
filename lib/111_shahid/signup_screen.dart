// lib/screens/signup_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../111_shahid/otp_screen.dart';
import '../services/auth_service.dart';
import '../utils/snackbar_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> _signup() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    // Validate input
    if (username.isEmpty) {
      showSnackBar(context, "Username cannot be empty");
      return;
    }
    if (email.isEmpty) {
      showSnackBar(context, "Email cannot be empty");
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      showSnackBar(context, "Please enter a valid email address");
      return;
    }
    if (password.isEmpty) {
      showSnackBar(context, "Password cannot be empty");
      return;
    }
    if (password.length < 6) {
      showSnackBar(context, "Password must be at least 6 characters");
      return;
    }
    //validate password
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
        .hasMatch(password)) {
      showSnackBar(context,
          "Password must contain at least one uppercase & lowercase letter, one special character  and one number ");
      return;
    }
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackBar(context, "All fields are required");
      return;
    }

    setState(() => isLoading = true);

    final result = await AuthService.signup(username, email, password);

    if (result == "ok") {
      showSnackBar(context, "Signup successful. Check your email for OTP.",
          isError: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                OtpScreen(email: email, isPasswordResetFlow: false)),
      );
    } else {
      showSnackBar(context, result ?? "Signup failed");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1E28),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.flutter_dash,
                    size: 60, color: Colors.blueAccent),
                const SizedBox(height: 10),
                const Text('Flutterverse',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                const Text('Sign Up',
                    style: TextStyle(fontSize: 22, color: Colors.white)),
                const SizedBox(height: 30),
                buildInputField("Name", controller: usernameController),
                buildInputField("Email Address", controller: emailController),
                buildInputField("Password",
                    obscure: true, controller: passwordController),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign Up',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Login",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String hint,
      {bool obscure = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure ? obscurePassword : false,
        keyboardType: hint == "Email Address"
            ? TextInputType.emailAddress
            : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: obscure
              ? const Icon(Icons.lock, color: Colors.white70)
              : hint == "Name"
                  ? const Icon(Icons.person, color: Colors.white70)
                  : const Icon(Icons.email, color: Colors.white70),
          suffixIcon: hint == "Password"
              ? IconButton(
                  icon: obscurePassword
                      ? const Icon(Icons.visibility_off, color: Colors.white70)
                      : const Icon(Icons.visibility, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
              : null,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2A2F3A),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
        ),
        textInputAction: obscure ? TextInputAction.done : TextInputAction.next,
        autofocus: false,
        onFieldSubmitted: (value) =>
            obscure ? _signup() : FocusScope.of(context).nextFocus(),
      ),
    );
  }
}
