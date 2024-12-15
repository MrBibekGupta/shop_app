import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/pages/bottomnav.dart';
import 'package:shop_app/pages/home.dart';
import 'package:shop_app/pages/signup.dart';
import 'package:shop_app/widget/support_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = ""; // Variables to store email and password input

  TextEditingController mailcontroller = new TextEditingController(); // Controller for email input field
  TextEditingController passwordcontroller = new TextEditingController(); // Controller for password input field

  final _formkey = GlobalKey<FormState>(); // Global key for form validation

  // Function to handle user login
  userLogin() async {
    try {
      // Attempt to sign in the user using Firebase authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav())); // Navigate to BottomNav page on success
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 20.0),
            )));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 20.0),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey, // Attach form key for validation
          child: Container(
            margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/loging.png"), // Login image
                SizedBox(height: 20.0,),

                // Sign in title
                Center(child: Text("Sign In", style: AppWidget.boldTextFeildStyle(), )),
                SizedBox(height: 20.0,),

                // Subheading text
                Text("Please enter the details below to\n                      continue", style: AppWidget.lightTextFeildStyle(), ),
                SizedBox(height: 10.0,),

                // Email field label
                Text("Email", style: AppWidget.boldTextFeildStyle(), ),
                SizedBox(height: 10.0,),

                // Email input field with validation
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'please Enter your Email'; // Show error if email is empty
                      }
                    },
                    controller: mailcontroller, // Bind controller to the email field
                    decoration: InputDecoration(border: InputBorder.none, hintText: "Email"),
                  ),
                ),

                SizedBox(height: 10.0,),

                // Password field label
                Text("Password", style: AppWidget.boldTextFeildStyle(), ),
                SizedBox(height: 20.0,),

                // Password input field with validation
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'please Enter your Password'; // Show error if password is empty
                      }
                    },
                    controller: passwordcontroller, // Bind controller to the password field
                    decoration: InputDecoration(border: InputBorder.none, hintText: "Password"),
                  ),
                ),

                SizedBox(height: 10.0,),

                // Forgot password link
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                  ],
                ),

                SizedBox(height: 10.0,),

                // Login button
                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){ // Check if form is valid
                      setState(() {
                        email = mailcontroller.text;
                        password = passwordcontroller.text;
                      });
                      userLogin(); // Call login function
                    }
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                      child: Center(child: Text("LOGIN", style: TextStyle(color: Colors.white, fontSize:18.0, fontWeight: FontWeight.bold ),)),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                // Sign up prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ? ", style: AppWidget.lightTextFeildStyle(), ),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())); // Navigate to sign-up page
                        },
                        child: Text("Sign Up", style: TextStyle(color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.bold),)),
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
