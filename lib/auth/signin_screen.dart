import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanager/auth/forget_password.dart';
import 'package:taskmanager/auth/signupscreen.dart';
import 'package:taskmanager/components/consts.dart';
import '../components/bold_text.dart';
import '../components/plain_text.dart';
import '../components/reusabletextformfield.dart';
import '../components/rounded_button.dart';
import '../screens/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 60, right: 15),
          child: Form(
            key: _formKey, // Assigning form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          "assets/images/logo.png",
                        ),
                        fit: BoxFit.contain,
                      ),
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const BoldText(
                  name: "Please enter your details to log in your account!",
                  textAlign: TextAlign.center,
                  fontsize: 16,
                ),
                const SizedBox(height: 20),
                const PlainText(name: "Email Address*", fontsize: 14),
                const SizedBox(height: 10),
                ReusableTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter Your email Address",
                  controller: emailController,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: appColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const PlainText(name: "Password*", fontsize: 14),
                const SizedBox(height: 10),
                ReusableTextFormField(
                  maxLines: 1,
                  obscureText: true,
                  hintText: "Enter Your Password",
                  controller: passController,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: appColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    child: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                RoundedButton(
                  title: "Submit",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      signIn(emailController.text, passController.text);
                    }
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const SignUpScreen());
                      },
                      child: PlainText(
                        name: "New User?\nCreate Account",
                        color: redColor,
                        fontsize: 14,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const ForgetPasswordScreen());
                      },
                      child: PlainText(
                        name: "Forget Password?",
                        color: redColor,
                        fontsize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      logger.i("User signed in successfully");
      logger.i('User signed in: ${userCredential.user!.uid}');
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Show snackbar or toast to display error message
        Get.snackbar(
          'Error',
          'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Handle other sign-in errors
        logger.i('Error signing in: $e');
      }
    }
  }
}
