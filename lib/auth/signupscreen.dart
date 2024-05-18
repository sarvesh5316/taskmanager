import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanager/auth/signin_screen.dart';
import 'package:taskmanager/auth/user_reg_form.dart';
import '../components/bold_text.dart';
import '../components/consts.dart';
import '../components/plain_text.dart';
import '../components/reusabletextformfield.dart';
import '../components/rounded_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
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
                  name: "Please enter your details to create a new account!",
                  textAlign: TextAlign.center,
                  fontsize: 16,
                ),
                const SizedBox(height: 10),
                const PlainText(name: "Email Address*", fontsize: 14),
                const SizedBox(height: 5),
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
                const SizedBox(height: 10),
                const PlainText(name: "Password*", fontsize: 14),
                const SizedBox(height: 5),
                ReusableTextFormField(
                  maxLines: 1,
                  obscureText: isVisible,
                  hintText: "Enter Your Password",
                  controller: passController,
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
                ),
                const SizedBox(height: 20),
                RoundedButton(
                  title: "Submit",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // If all validations pass, sign up
                      signUp(emailController.text, passController.text);
                    }
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Get.to(() => const SignInScreen());
                  },
                  child: PlainText(
                    name: "Already have an account?Log In",
                    color: redColor,
                    fontsize: 14,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      logger.i('User signed up: ${userCredential.user!.uid}');
      Get.offAll(() => UserRegistrationForm(email: email));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        logger.i('The account already exists for that email.');
      } else {
        logger.i('Error signing up: $e');
      }
    }
  }
}
