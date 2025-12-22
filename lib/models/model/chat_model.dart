class ChatModel {
  int? id;
  String firstName;
  String lastName;
  String phone;
  String message;
  String messageType;
  String date;

  ChatModel(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.message,
      required this.messageType,
      required this.date});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phone: json['phone'],
        message: json['message'],
        messageType: json['messageType'],
        date: json['date']);
  }
}
