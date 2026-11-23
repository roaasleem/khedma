import 'package:flutter/material.dart';

class EditWorkerProfileScreen extends StatelessWidget {
  const EditWorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: Text('Edit Worker Profile'),
      ),
    );
  }
}