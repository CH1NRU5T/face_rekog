import 'package:face_rekog/features/auth/services/auth_service.dart';
import 'package:face_rekog/features/auth/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  void signIn() {
    _authService.signInWithEmailAndPassword(
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
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Form(
          key: _formKey,
          child: Column(children: [
            CustomTextFormField(
                controller: emailController,
                hintText: 'Email',
                type: TextInputType.emailAddress),
            CustomTextFormField(
                controller: passwordController,
                hintText: 'Password',
                obscure: true,
                type: TextInputType.visiblePassword),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signIn();
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const NewHome()));
                  }
                },
                child: const Text('Login')),
          ]),
        )
      ]),
    );
  }
}
