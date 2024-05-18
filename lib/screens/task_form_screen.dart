import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:taskmanager/components/bold_text.dart';
import '../components/consts.dart';
import '../components/reusabletextformfield.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DateTime? _deadline;
  String _deadlineText = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _durationController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BoldText(name: 'Create Task', fontsize: 16),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReusableTextFormField(
                keyboardType: TextInputType.text,
                hintText: "Task Title",
                controller: _titleController,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: appColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ReusableTextFormField(
                keyboardType: TextInputType.text,
                hintText: "Task Description",
                controller: _descriptionController,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: appColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ReusableTextFormField(
                keyboardType: TextInputType.number,
                hintText: "Expected Task Duration (in hours)",
                controller: _durationController,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: appColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expected task duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Text('Deadline: $_deadlineText'),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await selectDateTime(context);
                  if (picked != null) {
                    setState(() {
                      _deadline = picked;
                      _deadlineText = DateFormat.yMd().add_jm().format(picked);
                    });
                  }
                },
                child: const Text('Select Deadline'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _saveTask();
                  _sendNotification('Task created successfully');
                  Get.back();
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    try {
      await _firestore.collection('tasks').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'deadline': _deadline,
        'duration': _durationController.text,
        'status': 'Incomplete',
        'name': FirebaseAuth.instance.currentUser!.displayName,
      });
    } catch (e) {
      print('Error saving task: $e');
    }
  }

  Future<void> _sendNotification(String message) async {
    try {
      await _firebaseMessaging.requestPermission();
      String? token = await _firebaseMessaging.getToken();
      await _firestore.collection('notifications').add({
        'token': token,
        'message': message,
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<DateTime?> selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timePicked != null) {
        return DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );
      }
    }
    return null;
  }
}
