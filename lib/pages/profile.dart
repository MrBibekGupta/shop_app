import 'dart:io'; // Import for File handling (to use File for image uploading)

import 'package:firebase_storage/firebase_storage.dart'; // Firebase storage package (not used in this code directly, possibly for future use)
import 'package:flutter/material.dart'; // Flutter material package
import 'package:image_picker/image_picker.dart'; // Image picker package to select images from gallery or camera
import 'package:random_string/random_string.dart'; // To generate random strings (used for unique file names)
import 'package:shop_app/pages/onboarding.dart'; // Onboarding page to navigate after sign out or delete
import 'package:shop_app/services/auth.dart'; // Authentication services (SignOut, delete user)
import 'package:shop_app/services/shared_pref.dart'; // Shared preferences service to get and save user data
import 'package:shop_app/widget/support_widget.dart'; // Custom widget helper methods for consistent styling
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase for image upload (storage) and database interaction

class Profile extends StatefulWidget {
  const Profile({super.key}); // Constructor for the Profile widget

  @override
  State<Profile> createState() => _ProfileState(); // State creation for Profile screen
}

class _ProfileState extends State<Profile> {
  String? image, name, email; // Variables to hold user data (image, name, email)
  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker to pick images
  File? selectedImage; // Variable to store the selected image file

  // Method to fetch user data from SharedPreferences
  getthesharedpref() async {
    image = await SharedPreferenceHelper().getUserImage(); // Fetch user image
    name = await SharedPreferenceHelper().getUserName(); // Fetch user name
    email = await SharedPreferenceHelper().getUserEmail(); // Fetch user email
    setState(() {}); // Rebuild UI after data is fetched
  }

  @override
  void initState() {
    getthesharedpref(); // Call the method to load data from SharedPreferences on initial load
    super.initState(); // Call the superclass initState()
  }

  // Method to pick an image from the gallery
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery); // Pick image from gallery
    selectedImage = File(image!.path); // Convert the picked image to a File object
    uploadItem(); // Upload the selected image
    setState(() {}); // Rebuild UI after image selection
  }

  // Method to upload the selected image to Supabase storage
  uploadItem() async {
    if (selectedImage != null) {
      try {
        // Extract file extension from the selected image's path
        String fileExtension = selectedImage!.path.split('.').last;

        // Generate a unique file name with the random string and file extension
        String fileName = '${randomAlphaNumeric(10)}.$fileExtension';

        // Upload the image to the 'images' bucket on Supabase storage
        await Supabase.instance.client.storage
            .from('images') // Replace 'images' with your actual Supabase bucket name
            .upload(fileName, selectedImage!);

        // Get the public URL of the uploaded image
        final publicUrl = Supabase.instance.client.storage
            .from('images') // Replace 'images' with your actual Supabase bucket name
            .getPublicUrl(fileName);

        print('Public URL: $publicUrl'); // Print the public URL of the uploaded image

        // Save the public URL of the uploaded image to SharedPreferences
        await SharedPreferenceHelper().saveUserImage(publicUrl);
      } catch (e) {
        print('Error uploading image: $e'); // Log any errors that occur during the upload
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2), // Set app bar color
        title: Text(
          "Profile", // App bar title
          style: AppWidget.boldTextFeildStyle(), // Apply custom bold text style from helper widget
        ),
      ),
      backgroundColor: Color(0xfff2f2f2), // Set background color for the profile screen
      body: name == null // Check if name is null (waiting for data)
          ? Center(child: CircularProgressIndicator()) // Show a loading spinner while waiting for user data
          : Container(
        child: Column(
          children: [
            // Display profile image (either picked or from URL)
            selectedImage != null
                ? GestureDetector(
              onTap: () {
                getImage(); // Open gallery to select a new image
              },
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60), // Round the corners of the image
                  child: Image.file(
                    selectedImage!, // Display the selected image
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.cover, // Ensure the image covers the circle area
                  ),
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                getImage(); // Open gallery to select a new image
              },
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60), // Round the corners of the image
                  child: Image.network(
                    image!, // Display the user's current image from the network
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.cover, // Ensure the image covers the circle area
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0, // Add spacing below the image
            ),
            // Display user name
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0), // Horizontal margins
              child: Material(
                elevation: 3.0, // Add shadow effect
                borderRadius: BorderRadius.circular(10), // Rounded corners
                child: Container(
                  padding: EdgeInsets.all(10.0), // Padding inside the container
                  width: MediaQuery.of(context).size.width, // Full width of the screen
                  decoration: BoxDecoration(
                      color: Colors.white, // Set background color
                      borderRadius: BorderRadius.circular(10)), // Set rounded corners
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline, // Icon for user profile
                        size: 35.0, // Icon size
                      ),
                      SizedBox(width: 10.0), // Spacing between icon and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                        children: [
                          Text(
                            "Name", // Label for the name field
                            style: AppWidget.lightTextFeildStyle(), // Apply custom text style
                          ),
                          Text(
                            name!, // Display the user's name
                            style: AppWidget.semiboldTextFeildStyle(), // Apply custom text style
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0), // Spacing below the name section
            // Display user email (similar to name section)
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.mail_outline, // Icon for email field
                        size: 35.0,
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email", // Label for the email field
                            style: AppWidget.lightTextFeildStyle(),
                          ),
                          Text(
                            email!, // Display the user's email
                            style: AppWidget.semiboldTextFeildStyle(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // Log out button
            GestureDetector(
              onTap: () async {
                await AuthMethods().SignOut().then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboarding())); // Navigate to Onboarding after sign out
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout, // Icon for log out
                          size: 35.0,
                        ),
                        SizedBox(width: 10.0),
                        Text("LogOut", style: AppWidget.semiboldTextFeildStyle(),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // Delete account button
            GestureDetector(
              onTap: () async {
                await AuthMethods().deleteuser().then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboarding())); // Navigate to Onboarding after account deletion
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline, // Icon for delete account
                          size: 35.0,
                        ),
                        SizedBox(width: 10.0),
                        Text("Delete Account", style: AppWidget.semiboldTextFeildStyle(),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
