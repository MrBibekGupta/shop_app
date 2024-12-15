import 'dart:io'; // Importing file handling
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firebase Firestore package
import 'package:supabase/supabase.dart'; // Import for Supabase SDK
import 'package:supabase_flutter/supabase_flutter.dart'; // Import for Supabase Flutter SDK
import 'package:random_string/random_string.dart'; // Import for generating random strings

class DatabaseMethods {
  // Method to upload an image to Supabase
  Future<String?> uploadImageToSupabase(File selectedImage) async {
    try {
      // Extract the original file extension from the selected image
      String fileExtension = selectedImage.path.split('.').last;

      // Generate a unique filename with the original file extension
      String filename = '${randomAlphaNumeric(10)}.$fileExtension';

      // Upload the image to Supabase storage, into the 'images' bucket
      await Supabase.instance.client.storage
          .from('images') // Your Supabase storage bucket name
          .upload(filename, selectedImage);

      // Retrieve the public URL of the uploaded image
      String imageUrl = Supabase.instance.client.storage
          .from('images') // Your bucket name
          .getPublicUrl(filename);

      return imageUrl; // Return the public URL
    } catch (e) {
      print('Error uploading image: $e'); // Catch and print any error that occurs
      return null; // Return null in case of error
    }
  }

  // Method to add user details to Firestore under the "users" collection
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users") // Firestore collection name
        .doc(id) // Document ID for the user
        .set(userInfoMap); // Set the user data to Firestore
  }

  // Method to add product details to Firestore under the "Products" collection
  Future addAllProducts(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Products") // Firestore collection for products
        .add(userInfoMap); // Add new product data to the collection
  }

  // Method to add product to a specific category collection in Firestore
  Future addProduct(Map<String, dynamic> userInfoMap, String categoryname) async {
    return await FirebaseFirestore.instance
        .collection(categoryname) // Dynamic category collection
        .add(userInfoMap); // Add product data to the collection
  }

  // Method to update order status to 'Delivered'
  updateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders") // Firestore collection for orders
        .doc(id) // Order document ID
        .update({"Status": "Delivered"}); // Update the status field
  }

  // Method to retrieve products based on category
  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return await FirebaseFirestore.instance.collection(category).snapshots(); // Return a stream of product data for the given category
  }

  // Method to get all orders where the status is "On the way!"
  Future<Stream<QuerySnapshot>> allorders() async {
    return await FirebaseFirestore.instance
        .collection("Orders") // Firestore collection for orders
        .where("Status", isEqualTo: "On the way!") // Filter by status
        .snapshots(); // Return a stream of orders with "On the way!" status
  }

  // Method to get orders for a specific user based on their email
  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return await FirebaseFirestore.instance
        .collection("Orders") // Firestore collection for orders
        .where("Email", isEqualTo: email) // Filter orders by email
        .snapshots(); // Return a stream of orders for the given email
  }

  // Method to add order details to Firestore under the "Orders" collection
  Future orderDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Orders") // Firestore collection for orders
        .add(userInfoMap); // Add new order data to the collection
  }

  // Method to search for products by the first letter of the product's search key
  Future<QuerySnapshot> search(String updatedname) async {
    return await FirebaseFirestore.instance
        .collection("Products") // Firestore collection for products
        .where("SearchKey", isEqualTo: updatedname.substring(0, 1).toUpperCase()) // Filter by the first letter of the search key
        .get(); // Get the products that match the search key
  }
}

// Extension on String class (though it seems unnecessary here)
extension on String {
  get error => null; // Placeholder, no functionality defined here
}
