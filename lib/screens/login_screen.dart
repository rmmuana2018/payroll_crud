import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/auth_state.dart';
import 'dashboard_screen.dart';
import '../components/buttons/custom_button.dart';
import '../components/text_fields/custom_text_field.dart';
import '../notifiers/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController(text: 'cabic60931@onlcool.com');
  final passwordController = TextEditingController(text: 'E4ts&4H-');
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.loading) {
        showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
      } else {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }

      if (next.status == AuthStatus.success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
      }

      if (next.status == AuthStatus.failure) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Login Failed"),
              content: const Text('Incorrect email/password'),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
            );
          },
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on_outlined, size: 100),
                const SizedBox(height: 25),
                Text('Welcome to Payroll', style: TextStyle(color: Colors.grey[700], fontSize: 35, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                CustomTextField(controller: emailController, hintText: 'Email', obscureText: false),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  showPassword: showPassword,
                  onToggle: () => setState(() => showPassword = !showPassword),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text('Forgot Password?', style: TextStyle(color: Colors.grey[600]))],
                  ),
                ),
                const SizedBox(height: 25),
                CustomButton(
                  text: 'Sign In',
                  onTap: () => ref.read(authNotifierProvider.notifier).login(emailController.text, passwordController.text),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?', style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    GestureDetector(child: const Text('Register now', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
