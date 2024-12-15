import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Cloud Firestore package for database interaction
import 'package:flutter/material.dart'; // Importing Flutter material design components
import 'package:shop_app/pages/product_details.dart'; // Importing the ProductDetails page
import 'package:shop_app/services/database.dart'; // Importing the DatabaseMethods service for interacting with the database
import 'package:shop_app/widget/support_widget.dart'; // Importing custom widget for styling

// Defining the CategoryProduct widget, which displays products based on a category
class CategoryProduct extends StatefulWidget {
  String category; // The category name passed to this widget

  CategoryProduct({required this.category}); // Constructor to receive the category name

  @override
  State<CategoryProduct> createState() => _CategoryProductState(); // Create the state for this widget
}

class _CategoryProductState extends State<CategoryProduct> {
  // Stream to handle the category products data
  Stream? CategoryStream;

  // Method to load products for the given category
  getontheload() async {
    CategoryStream = await DatabaseMethods().getProducts(widget.category); // Fetch the products for the selected category from the database
    setState(() {}); // Refresh the widget to display the fetched products
  }

  @override
  void initState() {
    super.initState();
    getontheload(); // Call the method to load products when the widget is initialized
  }

  // Widget to display all the products in a grid format
  Widget allProducts() {
    return StreamBuilder(
      stream: CategoryStream, // The stream of data (products) for the category
      builder: (context, AsyncSnapshot snapshot) {
        // Check if the snapshot contains data
        return snapshot.hasData
            ? GridView.builder(
          padding: EdgeInsets.zero, // Remove padding around the grid
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Set the number of columns in the grid
              childAspectRatio: 0.6, // Aspect ratio for each item
              mainAxisSpacing: 10.0, // Space between rows
              crossAxisSpacing: 10.0), // Space between columns
          itemCount: snapshot.data.docs.length, // Set the number of items to the number of documents fetched
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index]; // Get the product data at the current index

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white, // Background color of each product container
                borderRadius: BorderRadius.circular(10), // Rounded corners for the container
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
                children: [
                  SizedBox(height: 10.0),
                  Image.network(
                    ds["Image"], // Fetch the product image from Firestore
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover, // Ensure the image covers the given space
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    ds["Name"], // Display the product name
                    style: AppWidget.semiboldTextFeildStyle(), // Custom styling for text
                  ),
                  Spacer(), // Add space between the name and the price
                  Row(
                    children: [
                      Text(
                        ds["Price"], // Display the product price
                        style: TextStyle(
                          color: Color(0xFFfd6f3e), // Set the price text color
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold, // Make the price bold
                        ),
                      ),
                      SizedBox(width: 20.0),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the product details page when the "add" icon is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                detail: ds["Detail"], // Pass product details to the ProductDetail page
                                image: ds["Image"], // Pass the product image
                                name: ds["Name"], // Pass the product name
                                price: ds["Price"], // Pass the product price
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xFFfd6f3e), // Background color for the "add" button
                            borderRadius: BorderRadius.circular(7), // Rounded corners for the button
                          ),
                          child: Icon(
                            Icons.add, // Add icon to indicate adding to cart or more details
                            color: Colors.white, // White color for the icon
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        )
            : Container(); // Show an empty container if no data is available
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2), // Background color for the whole screen
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2), // App bar color
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0), // Margin around the body content
        child: Column(
          children: [
            Expanded(child: allProducts()), // Display the products in the grid view
          ],
        ),
      ),
    );
  }
}
