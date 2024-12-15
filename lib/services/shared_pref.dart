import 'package:shared_preferences/shared_preferences.dart'; // Importing SharedPreferences package

class SharedPreferenceHelper {
  // Defining keys for storing user data
  static String userIdkey = "USERKEY";
  static String userNamekey = "USERNAMEKEY";
  static String userEmailkey = "USEREMAILKEY";
  static String userImagekey = "USERIMAGEKEY";

  // Method to save user ID to shared preferences
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Getting shared preferences instance
    return prefs.setString(userIdkey, getUserId); // Saving user ID to shared preferences
  }

  // Method to save user name to shared preferences
  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Getting shared preferences instance
    return prefs.setString(userNamekey, getUserName); // Saving user name to shared preferences
  }

  // Method to save user email to shared preferences
  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Getting shared preferences instance
    return prefs.setString(userEmailkey, getUserEmail); // Saving user email to shared preferences
  }

  // Method to save user image URL to shared preferences
  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Getting shared preferences instance
    return prefs.setString(userImagekey, getUserImage); // Saving user image URL to shared preferences
  }

  // Method to retrieve user ID from shared preferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Getting shared preferences instance
    return prefs.getString(userIdkey); // Returning saved user ID
  }

  // Method to retrieve user name from shared preferences
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Getting shared preferences instance
    return prefs.getString(userNamekey); // Returning saved user name
  }

  // Method to retrieve user email from shared preferences
  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Getting shared preferences instance
    return prefs.getString(userEmailkey); // Returning saved user email
  }

  // Method to retrieve user image URL from shared preferences
  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Getting shared preferences instance
    return prefs.getString(userImagekey); // Returning saved user image URL
  }
}
