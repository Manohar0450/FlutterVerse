// lib/screens/login_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flutterverse_navbar.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../utils/token_storage.dart';
import '../utils/snackbar_helper.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if(email.isEmpty) {
      showSnackBar(context, "Email cannot be empty");
      return;
    }
    // Validate input
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
    setState(() => isLoading = true);
    final response = await AuthService.login(email, password);

    if (response != null && response.token!.length !=0) {
      await TokenStorage.saveToken(response.token!);
      await TokenStorage.saveUserData(response.toJson().toString());
      Provider.of<UserProvider>(context, listen: false).setUser(response);
      showSnackBar(context, "Login successful", isError: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FlutterVerseNavBar()),
      );
    } else {
      showSnackBar(context, null ?? "Login failed");
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
                const Text('Login',
                    style: TextStyle(fontSize: 22, color: Colors.white)),
                const SizedBox(height: 30),
                buildInputField("Email Address"),
                buildInputField("Password", obscure: true),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen()));
                    },
                    child: const Text("Forgot password?",
                        style: TextStyle(
                          color: Colors.white70,
                        )),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignUpScreen()));
                      },
                      child: const Text("Sign Up",
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

  Widget buildInputField(String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller:
            hint == "Email Address" ? emailController : passwordController,
        obscureText: obscure ? obscurePassword : false,
        keyboardType: hint == "Email Address"
            ? TextInputType.emailAddress
            : TextInputType.text,
        textInputAction: hint == "Email Address"
            ? TextInputAction.next
            : TextInputAction.done,
        style: const TextStyle(color: Colors.white),
        autofocus: false,
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
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
        ),
        onFieldSubmitted: (value) =>
            obscure ? _login() : FocusScope.of(context).nextFocus(),
      ),
    );
  }
}
