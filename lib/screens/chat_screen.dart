import 'package:bot_chat/constants/const.dart';
import 'package:bot_chat/provider/chats_provider.dart';
import 'package:bot_chat/services/assets_manager.dart';
import 'package:bot_chat/widgets/chat_widget.dart';
import 'package:bot_chat/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    _scrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsProvider = Provider.of<ChatsProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.botImage,
          ),
        ),
        title: const Text(
          'ChatBot',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child:
               ListView.builder(
                  controller: _scrollController,
                  itemCount: chatsProvider.getChatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                        message: chatsProvider.getChatList[index].msg,
                        chatIndex: chatsProvider.getChatList[index].index);
                  }),
            ),
            Consumer<ChatsProvider>(
              builder: (context, value, child) => value.getIsTyping
                  ? const SpinKitThreeBounce(
                      color: whiteColor,
                      size: 18,
                    )
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(
                          color: whiteColor,
                        ),
                        decoration: const InputDecoration.collapsed(
                            hintStyle: TextStyle(color: greyColor),
                            hintText: "How can I help you?"),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessage(chatsProvider: chatsProvider);
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: chatsProvider.getIsTyping
                          ? null
                          : () async {
                              await sendMessage(chatsProvider: chatsProvider);
                            },
                      icon: const Icon(
                        Icons.send,
                        color: whiteColor,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage({required ChatsProvider chatsProvider}) async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "Please type a message"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    String prompt = "";
    try {
      chatsProvider.isTypingToTrue();
      chatsProvider.addUserMessage(textEditingController.text);
      prompt = textEditingController.text;
      textEditingController.clear();
      focusNode.unfocus();

      await chatsProvider.sendMessageAndGetAnswer(
          msg: prompt, model: 'gpt-3.5-turbo');

      prompt = "";
      setState(() {});
    } catch (e) {
      debugPrint("error $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(label: e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollListToEnd();
        chatsProvider.isTypingToFalse();
      });
    }
  }

  void scrollListToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
  }
}
