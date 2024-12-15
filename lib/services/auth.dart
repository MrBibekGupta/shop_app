import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase authentication package

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance; // Instance of FirebaseAuth to interact with Firebase Authentication

  // Method to sign out the current user
  Future SignOut() async {
    // Sign out the user from Firebase Authentication
    await FirebaseAuth.instance.signOut();
  }

  // Method to delete the current user
  Future deleteuser() async {
    // Get the current user from Firebase Authentication
    User? user = await FirebaseAuth.instance.currentUser;

    // Delete the user if they are not null
    user?.delete();
  }
}
