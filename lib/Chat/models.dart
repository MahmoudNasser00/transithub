class ReceiveMessageModel {
  int? id;
  String? messageContent;
  String? time;
  bool? isRead;
  bool? isDeleted;
  String? sender;
  String? recever;
  Null applicationUserSender;
  Null applicationUserResever;

  ReceiveMessageModel(
      {this.id,
      this.messageContent,
      this.time,
      this.isRead,
      this.isDeleted,
      this.sender,
      this.recever,
      this.applicationUserSender,
      this.applicationUserResever});

  ReceiveMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageContent = json['messageContent'];
    time = json['time'];
    isRead = json['isRead'];
    isDeleted = json['isDeleted'];
    sender = json['sender'];
    recever = json['recever'];
    applicationUserSender = json['applicationUserSender'];
    applicationUserResever = json['applicationUserResever'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['messageContent'] = this.messageContent;
    data['time'] = this.time;
    data['isRead'] = this.isRead;
    data['isDeleted'] = this.isDeleted;
    data['sender'] = this.sender;
    data['recever'] = this.recever;
    data['applicationUserSender'] = this.applicationUserSender;
    data['applicationUserResever'] = this.applicationUserResever;
    return data;
  }
}
