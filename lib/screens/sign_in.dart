import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/screens/chat_room_screen.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/widgets/widget.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key, this.toggleView}) : super(key: key);
  final Function()? toggleView;
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      //saving the  email of the user signing in, locally
      //HelperFunctions.saveUserNameSharedPreference(usernameController.text);
      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserByEmail(emailController.text).then((value) {
        //this means when the getUserByEmail() fn as been carried our successfully, "then"(as in .then((val){})) do trigger what ever function inside(the .then((val){}))
        snapshotUserInfo = value;
        //pass the document gotten into snapshotUserInfo variable of type QuerySnapshot
        //when using .where to get data from the database, it can usually be multiple document
        //.where is used with QuerySnapshot, since its getting all(Query (which is a List)) the document related to the value of the key referenced
        //
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo!.docs[0]["name"]);
            //here we want to locally save the username of the user that's logging in
            //since the email of the user is used to check the database for the document since the document with that email would have the username of the user
            //the document gotten will then be pass into snapshotUserInfo
            //to get the username from the document we use this snapshotUserInfo!.docs[0]["name"]
            //.where is used with QuerySnapshot, since its getting all(Query (which is a List)) the document related to the value of the key referenced
            //that's why we use an index(in this case[0])
            //since a user can use only one email to register as in you cant create(authenticate) multiple users with one email
            //there can only be one of an email in the database
            //essentially the reason we used index[0] and not any othe index is cus there will only be one data gotten
            //even if multiple is expected(QuerySnapshot) cus we are using email as reference and there can be only one of an email
            //you can't authenticate multiple users with one email
            //so when you use the email to reference you'll only get one document.

      });
      authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
            //this means when the signInWithEmailAndPassword() fn as been carried our successfully, "then"(as in .then((val){})) do trigger what ever function inside(the .then((val){}))
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          //the user should be logged in
          //hence we give a value, true
          
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ChatRoomScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[800],
        body: ListView(children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Color.fromARGB(255, 2, 48, 86),
            width: double.infinity,
            height: 70,
            child: Row(
              children: const [
                Text(
                  'MyChat',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 120,
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  //cus the column is taking the whole vertical space, this is to prevent that
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              return value!.isEmpty ? "enter an email" : null;
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: 'email',
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                )),
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              return value!.length < 6
                                  ? "Provide password with 6+ characters"
                                  : null;
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: 'password',
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(colors: [
                            Color(0xff007EF4),
                            Color(0xff2A75BC),
                          ]),
                        ),
                        child: Text('Sign in',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 65,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Text('Sign in with Google',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView!();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Register now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
