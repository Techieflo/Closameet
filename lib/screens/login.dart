import 'package:closameet/screens/homebody.dart';
import 'package:closameet/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController reset_control = TextEditingController();

  TextEditingController username_control = TextEditingController();
  TextEditingController email_control = TextEditingController();
  TextEditingController password_control = TextEditingController();
  TextEditingController cpassword_control = TextEditingController();
  var formkey = GlobalKey<FormState>();
  String email = "", password = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }

  Future<bool> login() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email_control.text.trim(),
          password: password_control.text.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      showToast(e.toString().substring(30, e.toString().length));
    }
    return false;
  }

  Future<void> resetdialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Reset Password",
              style: TextStyle(fontSize: 12),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    controller: reset_control,
                    decoration:
                        const InputDecoration(hintText: "Enter Email Adress"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        color: Colors.blue,
                        onPressed: () async {
                          if (reset_control.text.toString().trim().isNotEmpty) {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: reset_control.text.toString());
                            showToast("Reset link sent to your email");
                            Navigator.pop(context);
                          } else {
                            showToast("Enter email adress");
                          }
                        },
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      if (await auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    });
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),

                // Email text field
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
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
                    controller: email_control,
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
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
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
                const SizedBox(
                  height: 10,
                ),

                //sign in button
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0)),
                  width: double.infinity,
                  child: FlatButton(
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          bool shouldnavigate = await login();
                          if (shouldnavigate) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
                          } else {
                            print("an error occured!. try again");
                          }
                        }
                      }),
                ),
                FlatButton(
                  onPressed: () {
                    resetdialog(context);
                  },
                  child: const Text("Forgot password?"),
                  textColor: Colors.blue,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      FlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()));
                        },
                        child: const Text("Sign Up"),
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
