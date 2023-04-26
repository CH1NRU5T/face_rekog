import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';
import '../widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  void register() {
    _authService.registerWithEmailAndPassword(
        context: context,
        email: emailController.text,
        password: passwordController.text);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.green,
                        fontWeight: FontWeight.bold)),
                Lottie.asset('assets/Person Scan.json',
                    width: 200, height: 200),
                Column(
                  children: [
                    CustomTextFormField(
                        controller: emailController,
                        hintText: 'Email',
                        type: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscure: true,
                        type: TextInputType.visiblePassword),
                  ],
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      register();
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Already have an account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, '/login');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
