import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:template/providers/contact_provider.dart';
import 'package:template/providers/image_path_provider.dart';
import 'package:template/providers/selected_list_provider.dart';
import 'package:template/widget/image_input.dart';

class NewContact extends ConsumerStatefulWidget {
  const NewContact({super.key, required this.id, required this.index});

  final String id;
  final int index;

  @override
  ConsumerState<NewContact> createState() {
    return _NewContact();
  }
}

class _NewContact extends ConsumerState<NewContact> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void editForm(String imgPath, int index) {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String mobileNo = _mobileController.text;
      String email = _emailController.text;
      String address = _addressController.text;

      Map<String, String> contactDetails = {
        "image": imgPath,
        "name": name,
        "mobile": mobileNo,
        "email": email,
        "address": address,
      };

      String contactDetailsString = jsonEncode(contactDetails);
      ref
          .read(contactsProvider.notifier)
          .editContactDetails(contactDetailsString, index);
      ref.read(pathProvider.notifier).clearImagePath();
      ref.read(listProvider.notifier).clearList();
      Navigator.pop(context);
    }
  }

  Future<void> changeDefaults(int index) async {
    final getInstance = await SharedPreferences.getInstance();
    List<String> contactsList = getInstance.getStringList("Contacts")!;
    Map<String, dynamic> contactMap = jsonDecode(contactsList[index]);
    String imgPath = contactMap["image"]!;
    ref.read(pathProvider.notifier).updateImagePath(imgPath);
    _nameController.text = contactMap["name"]!;
    _addressController.text = contactMap["address"]!;
    _emailController.text = contactMap["email"]!;
    _mobileController.text = contactMap["mobile"]!;
  }

  void saveForm(String imgPath) {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String mobileNo = _mobileController.text;
      String email = _emailController.text;
      String address = _addressController.text;

      Map<String, String> contactDetails = {
        "image": imgPath,
        "name": name,
        "mobile": mobileNo,
        "email": email,
        "address": address,
      };

      String contactDetailsString = jsonEncode(contactDetails);
      ref
          .read(contactsProvider.notifier)
          .addContactToData(contactDetailsString);
      ref.read(pathProvider.notifier).clearImagePath();
      ref.read(listProvider.notifier).clearList();
      Navigator.pop(context);
      _nameController.clear();
      _addressController.clear();
      _emailController.clear();
      _mobileController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != "0") {
      changeDefaults(widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    String imgPath = ref.watch(pathProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Contact Details"),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              imgPath == ""
                  ? ImageInput()
                  : ImageInput(
                      imgPath: imgPath,
                    ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Name"),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 3 ||
                            value.trim().length > 50) {
                          return "Invalid Input. Characters should be between 3 to 50.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(labelText: "Mobile"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return "Invalid Mobile No.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains("@")) {
                            return "Enter valid email id.";
                          }
                          return null;
                        }),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: "Address"),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a valid address";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.id == "0")
                          ElevatedButton(
                              onPressed: () {
                                _formKey.currentState!.reset();
                              },
                              child: Text("Reset")),
                        ElevatedButton(
                            onPressed: () {
                              if (widget.id == "1") {
                                return editForm(imgPath, widget.index);
                              }
                              if (imgPath == "" || imgPath.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Input Error"),
                                        content: const Text("Provide Image"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Ok"))
                                        ],
                                      );
                                    }
                                  );
                              } else {
                                return saveForm(imgPath);
                              }
                            },
                            child:
                                widget.id == "0" ? Text("Add") : Text("Edit")),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
