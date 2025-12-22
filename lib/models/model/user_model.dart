class UserModel {
  int id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? usergroupstatus;
  // String? fcmToken;
  int? groupId;
  num totalpoints;
  int? qiCustomerId;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.usergroupstatus,
    // required this.fcmToken,
    required this.groupId,
    required this.totalpoints,
    required this.qiCustomerId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      usergroupstatus: json['usergroupstatus'],
      // fcmToken: json['fcmToken'],
      groupId: json['groupId'],
      totalpoints: json['totalpoints'] ?? 0,
      qiCustomerId: json['qiCustomerId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'usergroupstatus': usergroupstatus,
      'groupId': groupId,
      'totalpoints': totalpoints,
      'qiCustomerId': qiCustomerId,
    };
  }
}
