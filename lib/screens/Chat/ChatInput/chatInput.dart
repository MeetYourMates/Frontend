import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/constants.dart';

class ChatInputToolbar extends StatelessWidget {
  /// To function where you can make api calls and play
  /// with the [ChatMessage] obeject before make calls.
  final Function(String send) onSend;

  final Size size;

  /// To function where you can show modal or something similar from outside
  /// with the [plusButton] on ChatInputToolbar Widget.
  final Function onExtra;

  /// HintText, if nothing passed shown "Please type here..."
  final String hintText;

  /// inputMax Lines of the TextField
  final int inputMaxLines;

  /// Max Character count allowed in the Text field
  final int maxInputLength;

  /// [textEditingController] required as this text Editing controller controls if the character
  /// are cleared, this can be done both from outside and inside
  final TextEditingController textEditingController;

  /// Style for the [TextField].
  final TextStyle inputTextStyle;

  /// Should the Input TextField be autofocused when user enters this screen
  final bool autoFocus;

  /// Should the message be sent by hitting enter on web or text input action
  /// Can be useful for tablet or web usage
  final bool sendOnEnter;

  ///Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  ///Defaults to [TextCapitalization.none]. Must not be null.
  final TextCapitalization textCapitalization;

  const ChatInputToolbar(
      {Key key,
      @required this.onSend,
      this.hintText = "Type here...",
      this.inputMaxLines = 6,
      this.maxInputLength = 500,
      this.sendOnEnter = false,
      this.textCapitalization = TextCapitalization.none,
      this.autoFocus = false,
      @required this.textEditingController,
      @required this.inputTextStyle,
      this.onExtra,
      this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String textValue = "";
    Logger logger = new Logger(level: Level.error);

    return Container(
      padding: EdgeInsets.only(bottom: 4.0),
      /* decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            //color: Colors.red[500],
            ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ), */
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /**============================================
           *               Plus Button for Extras
           *=============================================**/
          Container(
            padding: EdgeInsets.only(left: 4.0),
            child: GestureDetector(
              onTap: onExtra,
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ),
          ),
          /**============================================
           *               CHAT INPUT
           *=============================================**/
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: TextField(
                  //AutoFocusText Fiels
                  autofocus: false,
                  onChanged: (value) {
                    textValue = value;
                    logger.d(textValue);
                  },
                  onSubmitted: (value) {
                    if (sendOnEnter) {
                      onSend(value);
                    }
                  },
                  textInputAction: TextInputAction.newline,
                  buildCounter: (
                    BuildContext context, {
                    int currentLength,
                    int maxLength,
                    bool isFocused,
                  }) =>
                      null,
                  decoration: InputDecoration(
                    hintText: hintText,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Colors.deepPurple[500],
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  textCapitalization: textCapitalization,
                  controller: textEditingController,
                  style: inputTextStyle,
                  maxLength: maxInputLength,
                  minLines: 1,
                  maxLines: inputMaxLines,
                ),
              ),
            ),
          ),
          /**============================================
           *               Send Button
           *=============================================**/
          Container(
            padding: EdgeInsets.only(right: 4.0),
            child: FloatingActionButton(
              onPressed: () {
                if (textValue.isNotEmpty && textValue != null && textValue != "") {
                  onSend(textValue);
                  textEditingController.clear();
                }
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
          ),
          /* IconButton(
            icon: Icon(Icons.send),
            onPressed: textValue.length != 0
                ? () => {
                      onSend(textValue),
                      logger.d(textValue),
                    }
                : null,
          ), */
        ],
      ),
    );
  }
}
