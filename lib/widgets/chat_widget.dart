import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bot_chat/constants/const.dart';
import 'package:bot_chat/services/assets_manager.dart';
import 'package:bot_chat/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.message,
    required this.chatIndex,
  });
  final String message;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: chatIndex == 0
                      ? TextWidget(
                          label: message,
                        )
                      : DefaultTextStyle(
                          style: const TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            repeatForever: false,
                            totalRepeatCount: 1,
                            displayFullTextOnTap: true,
                            animatedTexts: [
                              TyperAnimatedText(
                                message.trim(),
                              ),
                            ],
                          ),
                        ),
                ),
                // chatIndex == 0
                //     ? const SizedBox()
                //     : Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         mainAxisSize: MainAxisSize.min,
                //         children: const [
                //           Icon(
                //             Icons.thumb_up_alt_outlined,
                //             color: whiteColor,
                //           ),
                //           SizedBox(
                //             width: 5,
                //           ),
                //           Icon(
                //             Icons.thumb_down_alt_outlined,
                //             color: whiteColor,
                //           ),
                //         ],
                //       )
              ],
            ),
          ),
        )
      ],
    );
  }
}
