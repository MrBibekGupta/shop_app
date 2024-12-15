import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'package:shop_app/pages/login.dart';
import 'package:shop_app/services/database.dart';
import 'package:shop_app/services/shared_pref.dart';
import 'package:shop_app/widget/support_widget.dart';
import 'bottomnav.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Variables for storing input data
  String? name, email, password;

  // Controllers for text form fields
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  // Form key to validate form fields
  final _formkey = GlobalKey<FormState>();

  // Function to handle user registration
  registration() async {
    if (password != null && name != null && email != null) {
      try {
        // Create user with email and password using Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Registered Successfully", style: TextStyle(fontSize: 20.0),)));

        // Generate a random user ID
        String Id = randomAlphaNumeric(10);

        // Save user details to shared preferences
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserImage("https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a");

        // Map user info to be stored in Firebase Firestore
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": Id,
          "Image":
          "https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a"
        };

        // Add user details to Firestore database
        await DatabaseMethods().addUserDetails(userInfoMap, Id);

        // Navigate to the BottomNav screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav()));

      } on FirebaseException catch (e) {
        // Handle Firebase exceptions
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Password Provided is too Weak", style: TextStyle(fontSize: 20.0),)));
        }
        else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Account Already exists", style: TextStyle(fontSize: 20.0),)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Form(
            key: _formkey, // Form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image at the top
                Image.asset("images/loging.png"),
                SizedBox(height: 01.0),

                // Title and description for sign up
                Center(child: Text("Sign Up", style: AppWidget.boldTextFeildStyle(), )),
                SizedBox(height: 1.0),
                Text("Please enter the details below to\n                      continue", style: AppWidget.lightTextFeildStyle(), ),

                SizedBox(height: 1.0),

                // Name field
                Text("Name", style: AppWidget.boldTextFeildStyle(), ),
                SizedBox(height: 1.0),
                Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Name';
                        }
                      },
                      controller: namecontroller,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Name"),
                    )),

                SizedBox(height: 1.0),

                // Email field
                Text("Email", style: AppWidget.boldTextFeildStyle(), ),
                SizedBox(height: 1.0),
                Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Email';
                        }
                      },
                      controller: mailcontroller,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Email"),
                    )),

                SizedBox(height: 1.0),

                // Password field
                Text("Password", style: AppWidget.boldTextFeildStyle(), ),
                SizedBox(height: 10.0),
                Container(
                    padding: EdgeInsets.only(left: 20.0),
                    decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      obscureText: true, // To hide the password input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Password';
                        }
                      },
                      controller: passwordcontroller,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Password"),
                    )),

                SizedBox(height: 10.0),

                // Sign-up button
                GestureDetector(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        name = namecontroller.text;
                        email = mailcontroller.text;
                        password = passwordcontroller.text;
                      });
                    }
                    registration(); // Call registration function
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                      child: Center(child: Text("SIGN UP", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ),

                SizedBox(height: 5.0),

                // Option for users who already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: AppWidget.lightTextFeildStyle()),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text("Sign In", style: TextStyle(color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
