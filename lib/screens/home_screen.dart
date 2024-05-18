import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/auth/signin_screen.dart';
import 'package:taskmanager/components/apptoast.dart';
import 'package:taskmanager/components/bold_text.dart';
import 'package:taskmanager/components/consts.dart';
import 'package:taskmanager/components/plain_text.dart';
import 'package:taskmanager/components/reusabletextformfield.dart';
import 'package:taskmanager/screens/task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              AppToast().toastMessage("User Logged Out Successfully!!");
              Get.offAll(() => const SignInScreen());
            },
            child: const Icon(Icons.logout, color: Colors.red),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 1));
        },
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No tasks found'));
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                DateTime deadline;
                if (data['deadline'] is Timestamp) {
                  deadline = (data['deadline'] as Timestamp).toDate();
                } else if (data['deadline'] is String) {
                  deadline = DateFormat.yMd().add_jm().parse(data['deadline']);
                } else {
                  deadline = DateTime.now();
                }

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    tileColor: Colors.lightBlue.shade100,
                    title: BoldText(
                      name: data['title'] ?? '',
                      fontsize: 20,
                      color: Colors.purple,
                    ),
                    contentPadding: EdgeInsets.only(left: 5, right: 5),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Times New Roman' // Default color
                                ),
                            children: [
                              const TextSpan(text: 'Description: '),
                              TextSpan(
                                text: '${data['description']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Times New Roman' // Default color
                                ),
                            children: [
                              const TextSpan(text: 'Deadline: '),
                              TextSpan(
                                text:
                                    '${DateFormat.yMd().add_jm().format(deadline)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Times New Roman' // Default color
                                ),
                            children: [
                              const TextSpan(text: 'Expected Duration: '),
                              TextSpan(
                                text: '${data['duration']} hours',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const PlainText(
                                  name: 'Status: ',
                                  fontsize: 14,
                                ),
                                Switch(
                                  value: data['status'] == 'Complete',
                                  onChanged: (bool value) async {
                                    await FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(document.id)
                                        .update({
                                      'status':
                                          value ? 'Complete' : 'Incomplete',
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return _buildEditTaskDialog(
                                            context, document);
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(document.id)
                                        .delete();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to task creation screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _buildEditTaskDialog(BuildContext context, DocumentSnapshot document) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  titleController.text = document['title'];
  descriptionController.text = document['description'];
  durationController.text = document['duration'];

  DateTime? deadline;
  if (document['deadline'] is Timestamp) {
    deadline = (document['deadline'] as Timestamp).toDate();
  } else if (document['deadline'] is String) {
    deadline = DateFormat.yMd().add_jm().parse(document['deadline']);
  } else {
    deadline = DateTime.now();
  }

  TextEditingController deadlineController = TextEditingController(
      text: DateFormat.yMd().add_jm().format(deadline ?? DateTime.now()));

  return AlertDialog(
    title: const Text('Edit Task'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReusableTextFormField(
          controller: titleController,
          hintText: 'Task Title',
        ),
        const SizedBox(height: 10),
        ReusableTextFormField(
          controller: descriptionController,
          hintText: 'Task Description',
        ),
        const SizedBox(height: 10),
        ReusableTextFormField(
          controller: durationController,
          hintText: 'Expected Task Duration (in hours)',
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            DateTime? picked =
                await selectDateTime(context, deadline ?? DateTime.now());
            if (picked != null) {
              deadlineController.text =
                  DateFormat.yMd().add_jm().format(picked);
            }
          },
          child: IgnorePointer(
            child: ReusableTextFormField(
              controller: deadlineController,
              hintText: 'Select Deadline',
            ),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(document.id)
              .update({
            'title': titleController.text,
            'description': descriptionController.text,
            'duration': durationController.text,
            'deadline': Timestamp.fromDate(
              DateFormat.yMd().add_jm().parse(deadlineController.text),
            ),
          });
          Navigator.of(context).pop();
        },
        child: const Text('Save'),
      ),
    ],
  );
}

Future<DateTime?> selectDateTime(
    BuildContext context, DateTime initialDate) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
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
