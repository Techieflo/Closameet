import 'package:closameet/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "";
  TextEditingController username_control = TextEditingController();
  TextEditingController email_control = TextEditingController();
  TextEditingController password_control = TextEditingController();
  TextEditingController cpassword_control = TextEditingController();
  var formkey = GlobalKey<FormState>();
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> register() async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email_control.text.trim(),
          password: password_control.text.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      showToast(e.toString().substring(36, e.toString().length));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  //user name text field
                  child: TextFormField(
                    controller: username_control,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a username";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20.0,
                              ),
                            ),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(color: Colors.blue)),
                        hintText: "User Name",
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.person)),
                  ),
                ),

                // Email text field
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: email_control,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Email Adress";
                      } else if (!value.contains("@")) {
                        return "Please Enter a valid email adress";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20.0,
                              ),
                            ),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(color: Colors.blue)),
                        hintText: "Email Adress",
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.mail)),
                  ),
                ),
                // password field
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a password";
                      } else if (value.length < 6) {
                        return "Passsword lenght cannot be less than six";
                      } else if (value != cpassword_control.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    controller: password_control,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20.0,
                              ),
                            ),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(color: Colors.blue)),
                        hintText: "Password",
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.lock)),
                  ),
                ),
                // confirm password
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please, confirm password";
                      } else if (value != password_control.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                    controller: cpassword_control,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              20.0,
                            ),
                          ),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: "Confirm Password",
                      fillColor: Colors.grey[200],
                      filled: true,
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                ),
                //sign up button
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0)),
                  width: double.infinity,
                  child: FlatButton(
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        bool shouldnavigate = await register();
                        DocumentReference ref = FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection("UserName")
                            .doc("firstname");
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot snapshot =
                              await transaction.get(ref);
                          if (!snapshot.exists) {
                            ref.set({
                              "firstname":
                                  username_control.text.toString().trim()
                            });
                          }
                        });
                        if (shouldnavigate) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        } else {
                          print("an error occured!. try again");
                        }
                      }
                    },
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      FlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textColor: Colors.blue,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
