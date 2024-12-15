import 'package:flutter/material.dart'; // Importing the Material package for Flutter widgets and themes

class AppWidget {
  // Method to return a bold text style
  static TextStyle boldTextFeildStyle() {
    return TextStyle(
        color: Colors.black, // Text color is black
        fontSize: 28.0, // Font size is 28
        fontWeight: FontWeight.bold); // Font weight is bold
  }

  // Method to return a light text style with a medium weight
  static TextStyle lightTextFeildStyle() {
    return TextStyle(
        color: Colors.black54, // Text color is a lighter shade of black
        fontSize: 20.0, // Font size is 20
        fontWeight: FontWeight.w500); // Font weight is medium (500)
  }

  // Method to return a semibold text style
  static TextStyle semiboldTextFeildStyle() {
    return TextStyle(
        color: Colors.black, // Text color is black
        fontSize: 20.0, // Font size is 20
        fontWeight: FontWeight.bold); // Font weight is bold
  }
}
