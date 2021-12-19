import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool hideMainForm = false;
  bool isLoading = true;
  UserModel loggedInUser = UserModel();

  String errorMessage;
  String selectedBatch;
  String selectedDiv;
  String selectedDept;

  String selectedBatchId;
  String selectedDivId;
  String selectedDeptId;

  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  User user = FirebaseAuth.instance.currentUser;
  var batchData = [];
  var deptData = [];
  var divData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  
  fetchData(){
    selectedBatch = "";
    selectedDiv = "";
    selectedDept = "";

      selectedBatchId = "";
      selectedDivId = "";
      selectedDeptId = "";

    batchData.clear();
    deptData.clear();
    divData.clear();
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      print(value.data());
      this.loggedInUser = UserModel.fromMap(value.data());
      firstNameEditingController.text = loggedInUser.firstName;
      secondNameEditingController.text = loggedInUser.secondName;
      FirebaseFirestore.instance.collection('batches').get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          batchData.add(value.docs[i].data());
          if (loggedInUser.batchId == value.docs[i].data()['batchId']) {
            selectedBatchId = value.docs[i].data()['batchId'];
            selectedBatch = value.docs[i].data()['batchId'];
          }
        }
        FirebaseFirestore.instance.collection('divisions').get().then((value) {
          for (int i = 0; i < value.docs.length; i++) {
            divData.add(value.docs[i].data());
            if (loggedInUser.divId == value.docs[i].data()['divId']) {
              selectedDivId = value.docs[i].data()['divId'];
              selectedDiv = value.docs[i].data()['divId'];
            }
          }
          FirebaseFirestore.instance.collection('department').get().then((value) {
            for (int i = 0; i < value.docs.length; i++) {
              deptData.add(value.docs[i].data());
              if (loggedInUser.deptId == value.docs[i].data()['deptId']) {
                selectedDeptId = value.docs[i].data()['deptId'];
                selectedDept = value.docs[i].data()['deptId'];
              }
            }

            setState(() {
              isLoading = false;
            });
          });
        });
      });
    });



  }
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.power_settings_new))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xffFB9481),
            )),
        title: const Text("Student Connect"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Student Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        SizedBox(height: 65),
                        firstNameField,
                        SizedBox(height: 20),
                        secondNameField,
                        SizedBox(height: 20),
                        subForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget subForm() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: Color(0xffC4C4C4)),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton(
              hint: Text("Choose Batch"),
              underline: Container(),
              isExpanded: true,
              value: selectedBatch,
              items: batchData
                  .map((e) => DropdownMenuItem(
                        child: Text(e['batchName']),
                        value: e['batchId'],
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedBatchId = value.toString();
                  selectedBatch = value.toString();
                });
              }),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: Color(0xffC4C4C4)),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton(
              underline: Container(),
              hint: Text("Choose Department"),
              isExpanded: true,
              value: selectedDept,
              items: deptData
                  .map((e) => DropdownMenuItem(
                        child: Text(e['deptName']),
                        value: e['deptId'],
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDeptId = value.toString();
                  selectedDept = value.toString();
                });
              }),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: Color(0xffC4C4C4)),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton(
              underline: Container(),
              hint: Text("Choose Division"),
              isExpanded: true,
              value: selectedDiv,
              items: divData
                  .map((e) => DropdownMenuItem(
                        child: Text(e['divName']),
                        value: e['divId'],
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDivId = value.toString();
                  selectedDiv = value.toString();
                });
              }),
        ),
        SizedBox(
          height: 30,
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
          child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                print(loggedInUser.deptId);
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(loggedInUser.uid)
                    .update({
                  "batchId": selectedBatchId,
                  "deptId": selectedDeptId,
                  "divId": selectedDivId,
                  "firstName": firstNameEditingController.text,
                  "secondName": secondNameEditingController.text,
                  "uid": loggedInUser.uid,
                }).then((value) => fetchData());
              },
              child: Text(
                "Save Changes",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }
}
