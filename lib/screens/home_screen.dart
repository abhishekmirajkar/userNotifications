import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/model/message_model.dart';
import 'package:college_project/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../drawer.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  MessageModel messageModel = MessageModel();
  List<MessageModel> messages = [];
  List cateData = [];
  TabController _controller;


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    FirebaseFirestore.instance.collection('category').get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        cateData.add(value.docs[i].data());
      }
      FirebaseFirestore.instance
          .collection('messages')
          .where("batchId", isEqualTo: loggedInUser.batchId)
          .where("deptId", isEqualTo: loggedInUser.deptId)
          .where("divId", isEqualTo: loggedInUser.divId)
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          messageModel = messageModelFromJson(json.encode(value.docs[i].data()));
          messages.add(messageModel);
        }
        setState(() {});
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    // List<String> categories = ["a", "b", "c", "d", "e", "f", "g", "h"];

    return DefaultTabController(
        length: cateData.length,
        child: new Scaffold(
            drawer: drawer(),

            appBar: new AppBar(
              title: const Text("Welcome"),
              centerTitle: true,
              bottom: new TabBar(
                isScrollable: true,
                tabs: List<Widget>.generate(cateData.length, (int index) {
                  return new Tab(icon: Icon(Icons.directions_car),
                      text: "${cateData[index]['cateName']}");
                }),

              ),
            ),

            body: new TabBarView(
              children: List<Widget>.generate(
                  cateData.length, (int index) {
                return new Column(children:[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      return messages[i].cateId == cateData[index]['cateId'] ? Column(
                        children: [
                          Text(messages[i].messageData),
                          Text(messages[i].date),
                          Text(messages[i].adminId),
                        ],
                      ): Container();
                    },
                  )
                ]);
              }),
            )
        ));
  }
}
