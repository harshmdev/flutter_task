import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ContactTemplate {
  ContactTemplate({
    required this.path,
    required this.name,
    required this.mobile,
    required this.mail,
    required this.address,
  }) : id = uuid.v4();

  
  final String id;
  final String path;
  final String name;
  final String mobile;
  final String mail;
  final String address;

}
