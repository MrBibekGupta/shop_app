import 'package:flutter/material.dart';
// import 'package:shoppingapp/pages/signup.dart'; // Sign-up page import is commented out

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 235, 231), // Light background color
      body: Container(
        margin: EdgeInsets.only(top: 30.0), // Top margin for the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Left-align the content
          children: [
            Image.asset("images/headphone.PNG"), // Display an image (headphones)

            Padding(
              padding: const EdgeInsets.only(left: 20.0), // Padding to the left of the text
              child: Text(
                "Explore\nThe Best\nProducts", // Main onboarding text
                style: TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 40.0, // Font size
                    fontWeight: FontWeight.bold), // Bold font weight
              ),
            ),

            SizedBox(height: 20.0,), // Space between the text and button

            // Button wrapped in a GestureDetector for interaction
            GestureDetector(
              onTap: (){
                // The action to perform on tap is currently commented out (e.g., navigating to SignUp screen)
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20.0), // Right margin for the button
                    padding: EdgeInsets.all(30), // Padding inside the button
                    decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle), // Circular black button
                    child:  Text(
                      "Next", // Button text
                      style: TextStyle(
                          color: Colors.white, // Text color (white)
                          fontSize: 20.0, // Text size
                          fontWeight: FontWeight.bold), // Bold text style
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
