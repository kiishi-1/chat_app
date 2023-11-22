import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/authentiate.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/screens/conversation_screen.dart';
import 'package:flutter_chat_app/screens/search.dart';
import 'package:flutter_chat_app/screens/sign_in.dart';
import 'package:flutter_chat_app/services/auth.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  AuthMethods authMethods = AuthMethods();
  Widget chatRoomList() {
    //realtime chat meaning the use of StreamBuilder
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ChatRoom")
            .where("users", arrayContains: Constants.myName)
            //.where("users", arrayContains: Constants.myName) means inside the "ChatRoom" collection, find the documents that has the value(which is a List) of the "users" key
            //which contains the username of the  user signed in(that was also stored locally and passed into Constants.myName in the initstate)
            //
            .snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                return ChatRoomTile(
                  userName: snapshot.data!.docs[index]["chatroomId"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                  chatRoomId: snapshot.data!.docs[index]["chatroomId"],
                );
              }));
        }));
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNamedSharedPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 48, 86),
        title: Text(
          "ChatApp",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              await authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  ChatRoomTile({Key? key, required this.userName, required this.chatRoomId})
      : super(key: key);
  final String userName;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        height: 70,
        color: Colors.black26,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }
}
