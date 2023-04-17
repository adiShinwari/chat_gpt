import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatsProvider with ChangeNotifier {
  bool _isTyping = false;

  final List<ChatModel> _chatList = [];
  List get getChatList {
    return _chatList;
  }

  bool get getIsTyping {
    return _isTyping;
  }

  isTypingToTrue() {
    _isTyping = true;
    notifyListeners();
  }

  isTypingToFalse() {
    _isTyping = false;
    notifyListeners();
  }

  void addUserMessage(String message) {
    _chatList.add(ChatModel(index: 0, msg: message));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswer(
      {required String msg, required String model}) async {
    _chatList.addAll(
      await ApiService.sendMessageGPT(
        message: msg,
        modelId: model,
      ),
    );

    notifyListeners();
  }
}
