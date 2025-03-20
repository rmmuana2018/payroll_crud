// import 'package:flutter/material.dart';
// import '../../components/my_button.dart';
// import '../../components/my_textfield.dart';
// import '../services/api_service.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   // text editing controllers
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   // sign user in method
//   void signUserIn(BuildContext context, String email, String password) async {
//     FocusManager.instance.primaryFocus?.unfocus(); // Hide keyboard
//     final apiService = ApiService();
//
//     try {
//       showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));
//
//       final response = await apiService.login(email, password);
//       Navigator.pop(context);
//
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text("Login Success"),
//             content: Text("Token: ${response['token']}"), // Show API token
//             actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
//           );
//         },
//       );
//     } catch (e) {
//       Navigator.pop(context);
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text("Login Failed"),
//             content: Text(e.toString()),
//             actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
//           );
//         },
//       );
//     }
//   }
//
//   void dialog(String msg) {
//     Navigator.pop(context);
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(title: Text(msg));
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // logo
//                 const Icon(Icons.lock, size: 100),
//
//                 const SizedBox(height: 25),
//
//                 // welcome message
//                 Text('Welcome guest!', style: TextStyle(color: Colors.grey[700], fontSize: 35, fontWeight: FontWeight.bold)),
//
//                 const SizedBox(height: 25),
//
//                 // email textfield
//                 MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
//
//                 const SizedBox(height: 10),
//
//                 // password textfield
//                 MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
//
//                 const SizedBox(height: 10),
//
//                 // forgot password?
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [Text('Forgot Password?', style: TextStyle(color: Colors.grey[600]))],
//                   ),
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 // sign in button
//                 MyButton(
//                     text: 'Sign In',
//                     onTap: () => signUserIn(context, emailController.text, passwordController.text),
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 // or continue with
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Row(children: [Expanded(child: Divider(thickness: 0.5, color: Colors.grey[400]))]),
//                 ),
//
//                 const SizedBox(height: 20),
//                 // not a member? register now
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Not a member?', style: TextStyle(color: Colors.grey[700])),
//                     const SizedBox(width: 4),
//                     GestureDetector(child: const Text('Register now', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../cubits/auth_cubit.dart';
import 'dashboard_screen.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            Navigator.pop(context);
          }

          if (state is AuthSuccess) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
          }

          if (state is AuthFailure) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Login Failed"),
                  content: Text(state.error),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 100),
                    const SizedBox(height: 25),
                    Text('Welcome guest!', style: TextStyle(color: Colors.grey[700], fontSize: 35, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                    const SizedBox(height: 10),
                    MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text('Forgot Password?', style: TextStyle(color: Colors.grey[600]))]),
                    ),
                    const SizedBox(height: 25),
                    MyButton(
                      text: 'Sign In',
                      onTap: () => context.read<AuthCubit>().login(emailController.text, passwordController.text),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(children: [Expanded(child: Divider(thickness: 0.5, color: Colors.grey[400]))]),
                    ),
                    const SizedBox(height: 20),
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
          );
        },
      ),
    );
  }
}