import 'package:flutter/material.dart'; // Importing Flutter's material design library for UI components
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore for database operations
import 'package:shop_app/admin/home_admin.dart'; // The admin home page (after successful login)
import 'package:shop_app/widget/support_widget.dart'; // Custom widget for text styling (Assumed to be implemented elsewhere)

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key}); // Constructor for AdminLogin widget

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

// Controllers to handle user input for username and password fields
TextEditingController usernamecontroller = new TextEditingController();
TextEditingController userpasswordcontroller = new TextEditingController();

class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Allows the page to be scrollable
        child: Container(
          margin:
          EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 40.0), // Container margin
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
            children: [
              // Admin panel image at the top
              Center(child: Image.asset("images/admin.png")),
              // Title text for the page
              Center(
                child: Text(
                  "Admin Panel",
                  style: AppWidget.semiboldTextFeildStyle(), // Custom text style
                ),
              ),
              SizedBox(height: 20.0), // Spacer

              // Username label
              Text(
                "Username",
                style: AppWidget.semiboldTextFeildStyle(), // Custom text style
              ),
              SizedBox(height: 20.0), // Spacer

              // Username input field wrapped in a styled container
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Colors.greenAccent, // Background color
                    borderRadius: BorderRadius.circular(10)), // Rounded corners
                child: TextFormField(
                  controller: usernamecontroller, // Controller for username input
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Username"), // No border and hint text
                ),
              ),
              SizedBox(height: 20.0), // Spacer

              // Password label
              Text(
                "Password",
                style: AppWidget.semiboldTextFeildStyle(), // Custom text style
              ),
              SizedBox(height: 20.0), // Spacer

              // Password input field wrapped in a styled container
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Colors.greenAccent, // Background color
                    borderRadius: BorderRadius.circular(10)), // Rounded corners
                child: TextFormField(
                  obscureText: true, // Hide the password text
                  controller: userpasswordcontroller, // Controller for password input
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Password"), // No border and hint text
                ),
              ),
              SizedBox(height: 30.0), // Spacer

              // Login button that triggers the login process when tapped
              GestureDetector(
                onTap: () {
                  loginAdmin(); // Call the login function when tapped
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2, // Set button width
                    padding: EdgeInsets.all(18), // Padding for the button
                    decoration: BoxDecoration(
                        color: Colors.green, // Button background color
                        borderRadius: BorderRadius.circular(10)), // Rounded corners
                    child: Center(
                        child: Text(
                          "LOGIN", // Button text
                          style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 18.0, // Font size
                              fontWeight: FontWeight.bold), // Bold text style
                        )),
                  ),
                ),
              ),
              SizedBox(height: 20.0), // Spacer
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle the admin login process
  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        // Check if the entered username matches any record in Firestore
        if (result.data()['username'] != usernamecontroller.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Your id is not correct", // Show error if username doesn't match
                style: TextStyle(fontSize: 20.0),
              )));
        }
        // Check if the entered password matches any record in Firestore
        else if (result.data()['password'] !=
            userpasswordcontroller.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Your password is not correct", // Show error if password doesn't match
                style: TextStyle(fontSize: 20.0),
              )));
        }
        else {
          // If both username and password are correct, navigate to the Admin home page
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeAdmin()));
        }
      });
    });
  }
}
