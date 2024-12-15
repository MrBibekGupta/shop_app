import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import for fetching data
import 'package:flutter/material.dart'; // Flutter material design package
import 'package:shop_app/services/database.dart'; // Custom service to interact with the database
import 'package:shop_app/services/shared_pref.dart'; // Custom shared preferences service
import 'package:shop_app/widget/support_widget.dart'; // Custom widget styles and helper methods

class Order extends StatefulWidget {
  const Order({super.key}); // Constructor to create the Order widget

  @override
  State<Order> createState() => _OrderState(); // State for managing the Order widget
}

class _OrderState extends State<Order> {
  String? email; // Variable to hold the user's email

  // Function to fetch the user's email from shared preferences
  getthesharedpref() async {
    email = await SharedPreferenceHelper().getUserEmail(); // Fetch email from shared preferences
    setState(() {}); // Refresh the UI after fetching the email
  }

  Stream? orderStream; // Stream to listen for order updates from Firestore

  // Function to load orders from the database based on the user's email
  getontheload() async {
    await getthesharedpref(); // Fetch the email before loading orders
    orderStream = await DatabaseMethods().getOrders(email!); // Fetch orders from the database
    setState(() {}); // Refresh UI after fetching the orders
  }

  @override
  void initState() {
    getontheload(); // Load orders when the widget is first created
    super.initState();
  }

  // Widget to display all orders in a list
  Widget allOrders() {
    return StreamBuilder(
        stream: orderStream, // Stream for fetching orders in real-time
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData // Check if the snapshot has data
              ? ListView.builder(
              padding: EdgeInsets.zero, // Remove any padding for the ListView
              itemCount: snapshot.data.docs.length, // Total number of orders
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index]; // Access order data for each item

                return Container(
                  margin: EdgeInsets.only(bottom: 20.0), // Bottom margin for spacing between orders
                  child: Material(
                    elevation: 3.0, // Shadow effect for the order card
                    borderRadius: BorderRadius.circular(10), // Rounded corners for the card
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0), // Padding inside the card
                      width: MediaQuery.of(context).size.width, // Full width of the screen
                      decoration: BoxDecoration(
                          color: Colors.white, // White background for the order card
                          borderRadius: BorderRadius.circular(10)), // Rounded corners
                      child: Row(
                        children: [
                          // Display product image
                          Image.network(
                            ds["ProductImage"], // Fetch the product image URL from Firestore
                            height: 100, // Set image height
                            width: 100, // Set image width
                            fit: BoxFit.cover, // Ensure the image covers the space
                          ),
                          Spacer(), // Spacer to push content to the right
                          Padding(
                            padding: const EdgeInsets.only(right: 40.0), // Right padding for text
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Left-align the text
                              children: [
                                // Product name text
                                Text(
                                  ds["Product"], // Display product name from Firestore
                                  style: AppWidget.semiboldTextFeildStyle(),
                                ),
                                // Product price text with custom styling
                                Text(
                                  "" + ds["Price"],
                                  style: TextStyle(
                                      color: Color(0xFFfd6f3e), // Orange color for price
                                      fontSize: 23.0, // Font size for price
                                      fontWeight: FontWeight.bold), // Bold font weight
                                ),
                                // Product status text with custom styling
                                Text(
                                  "Status : " + ds["Status"],
                                  style: TextStyle(
                                      color: Color(0xFFfd6f3e), // Orange color for status
                                      fontSize: 18.0, // Font size for status
                                      fontWeight: FontWeight.bold), // Bold font weight
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })
              : Container(); // If there is no data, show an empty container
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2), // Light background color for the screen
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2), // Set app bar background to match screen
        title: Text(
          "Current Orders", // Title of the app bar
          style: AppWidget.boldTextFeildStyle(), // Custom style for the title
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0), // Margin around the body
        child: Column(
          children: [
            Expanded(child: allOrders()) // Display orders inside a scrollable column
          ],
        ),
      ),
    );
  }
}
