class UserModel {
  String uid;
  String email;
  String firstName;
  String secondName;
  String batchId;
  String deptId;
  String divId;
  String fcmToekn;

  UserModel({this.uid, this.email, this.firstName, this.secondName,this.batchId,this.deptId,this.divId,this.fcmToekn});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      batchId: map['batchId'],
      deptId: map['deptId'],
      divId: map['divId'],
      fcmToekn: map['fcmToekn'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'batchId':batchId,
      'deptId':deptId,
      'divId':divId,
      'fcmToekn':fcmToekn
    };
  }
}
