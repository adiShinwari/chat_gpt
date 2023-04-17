class ChatModel {
  final String msg;
  final int index;

  ChatModel({
    required this.index,
    required this.msg,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        index: json['msg'],
        msg: json['chatIndex'],
      );
}
