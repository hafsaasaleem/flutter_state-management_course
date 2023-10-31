// ignore_for_file: unnecessary_cast

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const UserInfoScreen(),
      routes: {
        '/new-info': (context) => const UserInputScreen(),
      },
    );
  }
}

class UserInfo {
  final String name;
  final String id;
  final String age;
  UserInfo({
    required this.name,
    required this.age,
  }) : id = const Uuid().v4();
}

class NewUserInfo extends ValueNotifier<List<UserInfo>> {
  NewUserInfo.sharedInstance() : super([]);
  static final NewUserInfo _sharedInstance = NewUserInfo.sharedInstance();
  factory NewUserInfo() => _sharedInstance;

  int get length => value.length;

  void addInfo({required UserInfo userInformation}) {
    final userInfo = value;
    userInfo.add(userInformation);
    value = userInfo;
    notifyListeners();
  }

  void removeInfo({required UserInfo userInformation}) {
    final userInfo = value;
    if (userInfo.contains(userInformation)) {
      userInfo.remove(userInformation);
      notifyListeners();
    }
  }
}

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Your Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  hintText: 'Enter Your name....'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  hintText: 'Enter Your age....'),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.cyan,
              child: TextButton(
                onPressed: () {
                  final userInfo = UserInfo(
                      name: _nameController.text, age: _ageController.text);
                  log('press');
                  if (userInfo.name.isEmpty) {
                    return;
                  }
                  NewUserInfo().addInfo(userInformation: userInfo);
                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info Page"),
      ),
      body: ValueListenableBuilder(
        valueListenable: NewUserInfo(),
        builder: (context, value, child) {
          final userInfo = value as List<UserInfo>;
          if (userInfo.isEmpty) {
            return const Center(
              child: Text("No Data Available"),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: userInfo.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(userInfo[index].name),
                  subtitle: Text("Age: ${userInfo[index].age}"),
                  trailing: IconButton(
                    onPressed: () {
                      NewUserInfo()
                          .removeInfo(userInformation: userInfo[index]);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/new-info');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
































// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Page"),
//       ),
//       body: ValueListenableBuilder(
//           valueListenable: ContactBook(),
//           builder: (context, value, child) {
//             final contacts = value as List<Contact>;
//             return ListView.builder(
//               padding: const EdgeInsets.all(8.0),
//               itemCount: contacts.length,
//               itemBuilder: (context, index) {
//                 final contact = contacts[index];
//                 return Dismissible(
//                   onDismissed: (direction) {
//                     ContactBook().removeContact(contact: contact);
//                   },
//                   key: ValueKey(contact.id),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Material(
//                       color: Colors.white,
//                       elevation: 6.0,
//                       child: ListTile(
//                         title: Text(contact.name),
//                         subtitle: Text(contact.number),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.of(context).pushNamed('/new-contact');
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class AddNewContact extends StatefulWidget {
//   const AddNewContact({super.key});

//   @override
//   State<AddNewContact> createState() => _AddNewContactState();
// }

// class _AddNewContactState extends State<AddNewContact> {
//   late final TextEditingController _nameController;
//   late final TextEditingController _numberController;

//   @override
//   void initState() {
//     _nameController = TextEditingController();
//     _numberController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _numberController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add a new contact"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter a new contact name here...',
//                 enabledBorder: OutlineInputBorder(),
//                 focusedBorder: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _numberController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 hintText: 'Enter a number here...',
//                 enabledBorder: OutlineInputBorder(),
//                 focusedBorder: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton(
//               style: TextButton.styleFrom(
//                 padding: const EdgeInsets.all(12),
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 final contact = Contact(
//                   name: _nameController.text,
//                   number: _numberController.text,
//                 );
//                 ContactBook().addContact(contact: contact);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Add Contact'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Contact {
//   final String name;
//   final String id;
//   final String number;

//   Contact({
//     required this.name,
//     required this.number,
//   }) : id = const Uuid().v4();
// }

// class ContactBook extends ValueNotifier<List<Contact>> {
//   ContactBook.sharedInstance() : super([]);
//   static final ContactBook _sharedInstance = ContactBook.sharedInstance();
//   factory ContactBook() => _sharedInstance;
//   // final List<Contact> _contacts = [];
//   int get length => value.length;

//   void addContact({required Contact contact}) {
//     // value.add(contact);
//     final contacts = value;
//     contacts.add(contact);
//     value = contacts;
//     notifyListeners();
//   }

//   void removeContact({required Contact contact}) {
//     // value.remove(contact);
//     final contacts = value;
//     if (contacts.contains(contact)) {
//       contacts.remove(contact);
//       notifyListeners();
//     }
//   }

//   Contact? contact({required int atIndex}) =>
//       value.length > atIndex ? value[atIndex] : null;
// }
