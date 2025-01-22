import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:template/providers/contact_provider.dart';
import 'package:template/providers/image_path_provider.dart';
import 'package:template/providers/selected_list_provider.dart';
import 'package:template/widget/contact_card.dart';
import 'package:template/widget/new_contact.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _addContactScreen(String id, int index) async{
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewContact(
              id: id,
              index: index,
            ));
    // ignore: avoid_print
    ref.read(listProvider.notifier).clearList();
    ref.read(pathProvider.notifier).clearImagePath();
  }

  @override
  Widget build(BuildContext context) {
    final contactList = ref.watch(contactsProvider);
    final selectedList = ref.watch(listProvider);
    if (contactList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Contact List"),
        ),
        body: Center(
          child: Text("No Contacts!"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addContactScreen("0",0);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
        actions: [
          if (selectedList.length == 1) ...[
            TextButton(
              onPressed: () {
                _addContactScreen("1", selectedList[0]);
              },
              child: const Text("Edit"),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(contactsProvider.notifier)
                    .removeContacts(selectedList);
              },
              child: const Text("Delete"),
            ),
          ] else if (selectedList.length > 1) ...[
            TextButton(
              onPressed: () {
                ref
                    .read(contactsProvider.notifier)
                    .removeContacts(selectedList);
              },
              child: const Text("Delete"),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (ctx, index) {
                return ContactCard(contact: contactList[index], index: index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addContactScreen("0",0);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
