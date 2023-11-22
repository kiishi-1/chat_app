import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/screens/conversation_screen.dart';
import 'package:flutter_chat_app/services/database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot? searchSnapshot;
  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: ((context, index) {
              return searchTile(
                username: searchSnapshot!.docs[index]["name"],
                userEmail: searchSnapshot!.docs[index]["email"],
              );
            }))
        : Container();
  }

  ///create a chatroom, send user to conversation screen, pushreplacement
  createChatRoomAndStartConversation({required String userName}) {
    //Constants.myName = await HelperFunctions.getUserNamedSharedPreference();
    //Constants.myName the locally stored username of the currentuser
    if (userName != Constants.myName) {
      //chatRoomId is generated randomly with the getChatRoomId() fn
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      //userName is the searched username
      //Constants.myName the locally stored username of the currentuser

      //
      List<String> users = [userName, Constants.myName];
      //userName is the searched username
      //Constants.myName the locally stored username of the currentuser

      //chatRoomMap is the Map that'll be stored in the firestore databas
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      //chatRoomId is generated randomly with the getChatRoomId() fn
      //chatRoomMap is the Map that'll be stored in the firestore database
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatRoomId: chatRoomId,
            ),
          ));
    } else {
      print("object");
    }
  }

  Widget searchTile({required String username, required String userEmail}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName: username);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(13),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Message",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 48, 86),
        title: const Text(
          "ChatApp",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        hintText: 'Search username',
                        hintStyle: const TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

//generating unique ids
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return " ${b}_$a";
  } else {
    return " ${a}_$b";
  }
}
// substring examples
//String str = 'HelloTutorialKart.';

//int startIndex = 5;
// int endIndex = 13;

//find substring
    // String result = str.substring(startIndex, endIndex);
     
    // print(result);

//output => Tutorial

//NB: startIndex = 5 is T and endIndex = 13 is K
//so we start from T and end on K but we don't add K

//so (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) means

// a = "kiishi"
// b = "nonny"

//a.substring(0, 1) = k - we start from k and end on i but i will not be add
//b.substring(0, 1) = n

//codeUnitAt(0) is the code unit at index 0 which in this case are
// k and n
//so is k > n
// no, i guess cus of there order
