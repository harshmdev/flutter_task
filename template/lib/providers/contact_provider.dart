import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ContactsNotifier extends StateNotifier<List<String>> {
  ContactsNotifier() : super([]) {
    storedContactsList();
  }

  Future<void> storedContactsList() async {
    final getInstance = await SharedPreferences.getInstance();
    List<String>? fetchContactsList = getInstance.getStringList("Contacts");
    if(fetchContactsList != null) {
      state = fetchContactsList;
    }else {
      state = [];
    }
  }

  Future<void> addContactToData(String contact) async {
    final getInstance = await SharedPreferences.getInstance();
    List<String>? fetchContactsList = getInstance.getStringList("Contacts");
    if(fetchContactsList == null) {
      state = [contact];
    } else {
      state = [...fetchContactsList , contact];
    }
    await getInstance.setStringList("Contacts", state);
  }

  Future<void> editContactDetails(String contact , int index) async {
    final getInstance = await SharedPreferences.getInstance();
    List<String> fetchContactsList = getInstance.getStringList("Contacts")!;
    fetchContactsList[index] = contact;
    state = [...fetchContactsList];
    await getInstance.setStringList("Contacts", state);
  }

  Future<void> removeContacts(List<int> indexList) async {
    final getInstance = await SharedPreferences.getInstance();
    List<String> fetchContactsList = getInstance.getStringList("Contacts")!;
    indexList.sort();
    List<int> descendingIndex = indexList.reversed.toList();
    for (var i in descendingIndex){
      fetchContactsList.removeAt(i);
    }
    indexList.clear();
    state = [...fetchContactsList];
    await getInstance.setStringList("Contacts", state);
  }

}

final contactsProvider = StateNotifierProvider<ContactsNotifier , List<String>>((ref) {
  return ContactsNotifier();
});