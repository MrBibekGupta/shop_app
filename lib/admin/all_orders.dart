import 'package:flutter/material.dart'; // Importing Flutter's material design components
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore for database operations
import 'package:shop_app/services/database.dart'; // Custom database service for accessing Firestore
import 'package:shop_app/widget/support_widget.dart'; // Custom widget for styling (Assumed to be implemented elsewhere)

class AllOrders extends StatefulWidget {
  const AllOrders({super.key}); // Constructor for AllOrders widget

  @override
  State<AllOrders> createState() => _AllOrdersState(); // Creates the state for this widget
}

class _AllOrdersState extends State<AllOrders> {
  // A stream to listen for changes in the orders collection from Firestore
  Stream<QuerySnapshot>? orderStream;

  @override
  void initState() {
    super.initState();
    getOrdersOnLoad(); // Fetch the orders when the widget is initialized
  }

  // Function to fetch orders from the database on load
  void getOrdersOnLoad() async {
    orderStream = await DatabaseMethods().allorders(); // Fetch all orders using a custom method
    setState(() {}); // Refresh the widget to display the fetched data
  }

  // Function to build the UI for all orders using StreamBuilder
  Widget allOrders() {
    return StreamBuilder<QuerySnapshot>(
      stream: orderStream, // Listening for updates to the orderStream
      builder: (context, snapshot) {
        // If the data is still loading, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // If there was an error fetching the data, show an error message
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred!"));
        }
        // If no data is available, show a message indicating no orders
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No orders available!"));
        }

        // Display the list of orders if data is available
        return ListView.builder(
          padding: EdgeInsets.zero, // No extra padding for the list
          itemCount: snapshot.data!.docs.length, // Number of items (orders)
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index]; // Get the order document

            return Container(
              margin: EdgeInsets.only(bottom: 20.0), // Space between order items
              child: Material(
                elevation: 3.0, // Elevation for shadow effect
                borderRadius: BorderRadius.circular(10), // Rounded corners
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 05),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the order card
                    borderRadius: BorderRadius.circular(10), // Rounded corners for the card
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align children to the top
                    children: [
                      // Display the product image if available
                      if (ds["Image"] != null)
                        Image.network(
                          ds["Image"],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      Spacer(), // Spacer between image and text content
                      Padding(
                        padding: const EdgeInsets.only(right: 05.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                          children: [
                            // Display product name
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "Name: ${ds["Name"]}",
                                style: AppWidget.semiboldTextFeildStyle(), // Custom text style
                              ),
                            ),
                            SizedBox(height: 1.0),
                            // Display email address
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "Email: ${ds["Email"]}",
                                style: AppWidget.lightTextFeildStyle(), // Custom text style
                              ),
                            ),
                            SizedBox(height: 1.0),
                            // Display product name
                            Text(
                              "Product: ${ds["Product"]}",
                              style: AppWidget.semiboldTextFeildStyle(), // Custom text style
                            ),
                            // Display product price
                            Text(
                              "Price: ${ds["Price"]}",
                              style: TextStyle(
                                  color: const Color(0xFFfd6f3e), // Custom color for price
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold), // Bold font for price
                            ),
                            SizedBox(height: 10.0),
                            // "Done" button to mark the order as completed
                            GestureDetector(
                              onTap: () async {
                                // Update the status of the order when tapped
                                await DatabaseMethods().updateStatus(ds.id);
                                setState(() {}); // Refresh the UI to reflect the change
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                width: 150,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFfd6f3e), // Button color
                                  borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                                ),
                                child: Center(
                                  child: Text(
                                    "Done", // Text for the button
                                    style: AppWidget.semiboldTextFeildStyle(), // Custom text style
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // The main UI structure of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "All Orders", // Title for the app bar
            style: AppWidget.boldTextFeildStyle(), // Custom text style
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0), // Margin around the content
        child: Column(
          children: [Expanded(child: allOrders())], // The orders are displayed here
        ),
      ),
    );
  }
}
