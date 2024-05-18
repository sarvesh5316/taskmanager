// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/bold_text.dart';
import '../components/consts.dart';
import '../components/plain_text.dart';
import '../components/reusabletextformfield.dart';
import '../components/rounded_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SvgPicture.asset("assets/svg/doctor.svg", height: 100),
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
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
                hspacer(20),

                BoldText(
                    name: "Please enter your email to reset your password!!",
                    textAlign: TextAlign.center,
                    fontsize: 16),
                hspacer(20),
                PlainText(name: "Email Address*", fontsize: 14),
                hspacer(10),
                ReusableTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter Your email Address",
                  // labelText: "Email Address",
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  controller: emailController,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: appColor),
                  ),
                ),
                hspacer(30),
                RoundedButton(
                    title: "Submit",
                    onTap: () {
                      resetPassword(emailController.text);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.back();
      // AppToast()
      //     .toastMessage("Password Reset Link sent to your $email successfully");
      // Password reset email sent successfully
    } catch (e) {
      // Handle reset password errors
      logger.i("Error resetting password: $e");
    }
  }
}
