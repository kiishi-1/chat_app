import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/screens/chat_room_screen.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key, this.toggleView}) : super(key: key);
  final Function()? toggleView;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  // HelperFunctions helperFunctions = HelperFunctions();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  signMeUp() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": usernameController.text,
        "email": emailController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      HelperFunctions.saveUserNameSharedPreference(usernameController.text);
      //saving the users username and email locally

      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        //this means when the signUpWithEmailAndPassword() fn as been carried our successfully, "then"(as in .then((val){})) do trigger what ever function inside(the .then((val){}))

        databaseMethods.uploadUserInfo(userInfoMap);
        //we want to save this to our firestore database when the user has successfully Registered
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        //the user should be logged in
        //hence we give a value, true

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoomScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[800],
        body: isLoading
            ? Container(
                child: const Center(child: CircularProgressIndicator()),
              )
            : ListView(children: [
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
                                    controller: usernameController,
                                    validator: (value) {
                                      return value!.isEmpty || value.length < 2
                                          ? "Please Provide a username"
                                          : null;
                                    },
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        hintText: 'username',
                                        hintStyle: TextStyle(
                                          color: Colors.white54,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        )),
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? "enter an email"
                                          : null;
                                    },
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        hintText: 'email',
                                        hintStyle: TextStyle(
                                          color: Colors.white54,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
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
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        hintText: 'password',
                                        hintStyle: TextStyle(
                                          color: Colors.white54,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        )),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
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
                              signMeUp();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(colors: [
                                  Color(0xff007EF4),
                                  Color(0xff2A75BC),
                                ]),
                              ),
                              child: const Text('Sign up',
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
                            child: const Text('Sign up with Google',
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
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleView!();
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'Sign in now',
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
