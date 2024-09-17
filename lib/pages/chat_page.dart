import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sm_chatapp/components/my_chat_bubble.dart';
import 'package:sm_chatapp/services/auth/auth_service.dart';
import 'package:sm_chatapp/services/chat/chat_service.dart';

import '../components/my_textfield.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
//input controller
  final TextEditingController _messageController = TextEditingController();
  //chat services
  final _chatService = ChatService();
  //auth service
  final _authService = AuthService();
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    // add listener to focus node
    myFocusNode.addListener(
      () {},
    );
  }

  void sendMessage() async {
    //check if textfeild is blank to avoid sending blank messages
    if (_messageController.text.isNotEmpty) {
      //send the message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
    }

    //clear the text controller
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 5,
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(child: _buildMessageList()),
          // user input
          _buildUserInput(context)
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }

        // listview
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

//build each message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // is current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    // align messages on the right if sender , on the left, if otehrwise
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            MyChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
          ],
        ));
  }

  // build user input
  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          //textfeild (takes up most space)
          Expanded(
              child: MyTextField(
            textController: _messageController,
            hintText: "Type a message",
            obscureText: false,
          )),
          Container(
            margin: const EdgeInsets.only(right: 25),
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: IconButton(
                onPressed: sendMessage,
                icon: Icon(
                  Icons.send_rounded,
                  color: Theme.of(context).colorScheme.tertiary,
                )),
          )
        ],
      ),
    );
  }
}
