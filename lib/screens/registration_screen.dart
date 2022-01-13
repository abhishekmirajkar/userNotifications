import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  bool hideMainForm = false;
  bool isLoading = true;

  String errorMessage;
  String selectedBatch;
  String selectedDiv;
  String selectedDept;

  String selectedBatchId;
  String selectedDivId;
  String selectedDeptId;

  bool goback = true;

  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  var batchData = [];
  var deptData = [];
  var divData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance.collection('batches').get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        print(value.docs[i].data());
        batchData.add(value.docs[i].data());
      }
    });

    FirebaseFirestore.instance.collection('divisions').get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        divData.add(value.docs[i].data());
        print(value.docs[i].data());
      }
    });

    FirebaseFirestore.instance.collection('department').get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        deptData.add(value.docs[i].data());
        print(value.docs[i].data());
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => goback,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Welcome to \nStudent Connect",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 26),
                          ),
                          SizedBox(height: 45),
                          Text(
                            "You are Signing up as a student",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          hideMainForm
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      subForm(),
                                      SizedBox(height: 50,),
                                      Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).primaryColor,
                                        child: MaterialButton(
                                            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            minWidth: MediaQuery.of(context).size.width,
                                            onPressed: () {
                                              setState(() {
                                                if(selectedDivId.runtimeType != Null && selectedDeptId.runtimeType != Null && selectedBatchId.runtimeType != Null ){
                                                  signUp(emailEditingController.text,
                                                      passwordEditingController.text);
                                                }else{
                                                  Fluttertoast.showToast(msg: "Please select all fields");
                                                }

                                              });
                                            },
                                            child: Text(
                                              hideMainForm ? "SignUp" : "Next",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                    ],
                                  ),
                                )
                              : Form(
                            key: _formKey,
                                child: Column(
                                    children: [
                                      SizedBox(height: 15),
                                      TextFormField(
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
                                          )),
                                      SizedBox(height: 20),
                                      TextFormField(
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
                                          )),
                                      SizedBox(height: 20),
                                      TextFormField(
                                          autofocus: false,
                                          controller: emailEditingController,
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return ("Please Enter Your Email");
                                            }
                                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                                .hasMatch(value)) {
                                              return ("Please Enter a valid email");
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            firstNameEditingController.text = value;
                                          },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.mail),
                                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            hintText: "Email",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          )),
                                      SizedBox(height: 20),
                                      TextFormField(
                                          autofocus: false,
                                          controller: passwordEditingController,
                                          obscureText: true,
                                          validator: (value) {
                                            RegExp regex = new RegExp(r'^.{6,}$');
                                            if (value.isEmpty) {
                                              return ("Password is required for login");
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return ("Enter Valid Password(Min. 6 Character)");
                                            }
                                          },
                                          onSaved: (value) {
                                            firstNameEditingController.text = value;
                                          },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.vpn_key),
                                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            hintText: "Password",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          )),
                                      SizedBox(height: 20),
                                      TextFormField(
                                          autofocus: false,
                                          controller: confirmPasswordEditingController,
                                          obscureText: true,
                                          validator: (value) {
                                            if (confirmPasswordEditingController.text !=
                                                passwordEditingController.text) {
                                              return ("Password don't match");
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            confirmPasswordEditingController.text = value;
                                          },
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.vpn_key),
                                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            hintText: "Confirm Password",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          )),
                                      SizedBox(height: 20),
                                      Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).primaryColor,
                                        child: MaterialButton(
                                            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            minWidth: MediaQuery.of(context).size.width,
                                            onPressed: () {
                                              setState(() {
                                                if (hideMainForm) {
                                                  signUp(emailEditingController.text,
                                                      passwordEditingController.text);
                                                } else {
                                                  if(_formKey.currentState.validate()){
                                                    goback = false;
                                                    hideMainForm = !hideMainForm;
                                                  }

                                                }
                                              });
                                            },
                                            child: Text(
                                              hideMainForm ? "SignUp" : "Next",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Already have an account?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                " Login in",
                                                style: TextStyle(
                                                    color: Color(0xffFB9481),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            )
                                          ]),
                                    ],
                                  ),
                              )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void signUp(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage);
      print(error.code);
    }
    setState(() {
      isLoading = false;
    });
  }

  postDetailsToFirestore() async {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;

    UserModel userModel = UserModel();

    var token = await _firebaseMessaging.getToken();
    print(token);
    // writing all the values
    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;
    userModel.divId = selectedDivId;
    userModel.deptId = selectedDeptId;
    userModel.batchId = selectedBatchId;
    userModel.fcmToekn = token as String;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    setState(() {
      isLoading = false;
    });

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }

  Widget subForm() {
    return Column(
      children: [
        SizedBox(height: 40,),
        Container(
          padding: EdgeInsets.symmetric(horizontal:10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Color(0xffC4C4C4)),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton(
              hint: Text("Choose Batch"),underline: Container(),
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
        SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.symmetric(horizontal:10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Color(0xffC4C4C4)),
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
        SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.symmetric(horizontal:10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Color(0xffC4C4C4)),
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
      ],
    );
  }
}
