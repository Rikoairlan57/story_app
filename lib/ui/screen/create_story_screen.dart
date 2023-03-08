import 'package:flutter/material.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Add Story"),
    );
  }
}
