import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm_app/ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;

  setDataToTextField(data) {
    return ListView(
      children: [
        TextFormField(
          controller: _nameController =
              TextEditingController(text: data['name']),
        ),
        TextFormField(
          controller: _phoneController =
              TextEditingController(text: data['phone']),
        ),
        TextFormField(
          controller: _ageController = TextEditingController(text: data['age']),
        ),
        ElevatedButton(
            
            onPressed: () => updateData(), child: const Text("Update")),
        SizedBox(
          height: 10,
        ),
        ElevatedButton.icon(
          
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(
              Icons.arrow_back,
              size: 32,
            ),
            label: Text(
              'Sign Out',
              style: TextStyle(fontSize: 24),
            ))
      ],
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
    }).then((value) => print("Updated Successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-form-data")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            if (data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return setDataToTextField(data);
          },
        ),
      )),
    );
  }
}
