import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactDetailsScreen extends ConsumerStatefulWidget {
  const ContactDetailsScreen({super.key, required this.contact});

  final Map<String, dynamic> contact;

  @override
  ConsumerState<ContactDetailsScreen> createState() {
    return _ContactDetailsScreen();
  }
}

class _ContactDetailsScreen extends ConsumerState<ContactDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> contact = widget.contact;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Details"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 80,
              backgroundImage: FileImage(File(contact["image"])),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Name: ${contact["name"]}"),
            SizedBox(
              height: 10,
            ),
            Text("Mobile: ${contact["mobile"]}"),
            SizedBox(
              height: 10,
            ),
            Text("Email: ${contact["email"]}"),
            SizedBox(
              height: 10,
            ),
            Text("Address: ${contact["address"]}"),
          ],
        ),
      ),
    );
  }
}
