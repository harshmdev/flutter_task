import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/Screens/contact_details_screen.dart';
import 'package:template/providers/selected_list_provider.dart';

class ContactCard extends ConsumerStatefulWidget {
  const ContactCard({super.key, required this.contact, required this.index});

  final String contact;
  final int index;

  @override
  ConsumerState<ContactCard> createState() {
    return _ContactCardState();
  }
}

class _ContactCardState extends ConsumerState<ContactCard> {
  bool? _isLongPressed;

  @override
  Widget build(BuildContext context) {
    List<int> selectedList = ref.watch(listProvider);
    Map<String, dynamic> contactMap = jsonDecode(widget.contact);
    if (selectedList.isEmpty) {
      _isLongPressed = false;
    } else {
      _isLongPressed = true;
    }

    return Card(
      color: selectedList.contains(widget.index) ? Colors.blue : Colors.white,
      child: InkWell(
        onLongPress: () {
          if (selectedList.isEmpty) {
            setState(() {
              _isLongPressed = true;
              selectedList.add(widget.index);
              ref.read(listProvider.notifier).updateList(selectedList);
            });
          }
        },
        onTap: () {
          setState(() {
            if (_isLongPressed!) {
              if (selectedList.contains(widget.index)) {
                selectedList.remove(widget.index);
                ref.read(listProvider.notifier).updateList(selectedList);
              } else {
                selectedList.add(widget.index);
                ref.read(listProvider.notifier).updateList(selectedList);
              }
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ContactDetailsScreen(contact: contactMap)));
            }
          });
        },
        child: Row(
          children: [
            Image.file(
              File(contactMap["image"]),
              width: 100,
              height: 100,
            ),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${contactMap["name"]}"),
                Text("Mobile: ${contactMap["mobile"]}"),
                Text("Email: ${contactMap["email"]}"),
                Text("Address: ${contactMap["address"]}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
