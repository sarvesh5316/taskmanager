import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/screens/home_screen.dart';
import '../components/bold_text.dart';
import '../components/consts.dart';
import '../components/plain_text.dart';
import '../components/reusabletextformfield.dart';
import '../components/rounded_button.dart';

class UserRegistrationForm extends StatefulWidget {
  final String email;
  const UserRegistrationForm({super.key, required this.email});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String date = DateTime.now().toString();
  String selectedGender = "";
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PlainText(name: "User Details", fontsize: 18),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Form(
            key: _formKey, // Assigning form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BoldText(name: "Full Name", fontsize: 16),
                const SizedBox(height: 10),
                ReusableTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter Your Name",
                  controller: nameController,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: appColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const BoldText(name: "Date of Birth", fontsize: 16),
                const SizedBox(height: 10),
                ReusableTextFormField(
                  keyboardType: TextInputType.phone,
                  controller: dobController,
                  hintText: date,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: appColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your date of birth';
                    }
                    return null;
                  },
                  suffixIcon: InkWell(
                    onTap: () async {
                      date = await selectDate(context);
                      dobController.text = date;
                    },
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 10),
                const BoldText(name: "Email ID", fontsize: 16),
                const SizedBox(height: 10),
                ReusableTextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  hintText: widget.email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: appColor),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your email address';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 10),
                const BoldText(name: "Phone Number", fontsize: 16),
                const SizedBox(height: 10),
                ReusableTextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  hintText: "Enter Your Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: appColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const BoldText(name: "Gender", fontsize: 16),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildGenderOption('Male'),
                    buildGenderOption('Female'),
                    buildGenderOption('Other'),
                  ],
                ),
                const SizedBox(height: 20),
                RoundedButton(
                  title: "Submit",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      userRegistration();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      return DateFormat.yMMMMd().format(picked);
    }
    return "";
  }

  Widget buildGenderOption(String gender) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        width: 80,
        height: 35,
        decoration: BoxDecoration(
          color: selectedGender == gender ? Colors.pink : Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: PlainText(name: gender, fontsize: 16, color: whiteColor),
        ),
      ),
    );
  }

  Future<void> userRegistration() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'fullName': nameController.text,
        'DOB': dobController.text,
        'email': emailController.text,
        'mobileNo': "+91${phoneController.text}",
        'gender': selectedGender,
        // Add more user data fields as needed
      });
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logger.i('Error registering user: $e');
      // Handle registration errors
    }
  }
}
