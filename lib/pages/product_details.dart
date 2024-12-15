import 'package:flutter/cupertino.dart'; // Import for Cupertino widgets (iOS style components)
import 'package:flutter/material.dart'; // Flutter material design package
import 'package:shop_app/services/database.dart'; // Custom service to interact with the database
import 'package:shop_app/services/shared_pref.dart'; // Custom shared preferences service
import 'package:shop_app/widget/support_widget.dart'; // Custom widget styles and helper methods

class ProductDetail extends StatefulWidget {
  String image, name, detail, price; // Variables to hold product details like image, name, description, and price

  // Constructor to initialize product details
  ProductDetail({
    required this.detail,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState(); // Create state for managing the widget
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, mail, image; // Variables to hold user's details like name, email, and image

  // Function to fetch user details from shared preferences
  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName(); // Fetch the user's name
    mail = await SharedPreferenceHelper().getUserEmail(); // Fetch the user's email
    image = await SharedPreferenceHelper().getUserImage(); // Fetch the user's image
    setState(() {}); // Refresh the UI after fetching the details
  }

  // Function to load user details when the widget is initialized
  ontheload() async {
    await getthesharedpref(); // Fetch user details
    setState(() {}); // Refresh the UI after loading the data
  }

  @override
  void initState() {
    super.initState();
    ontheload(); // Load user details when the widget is first created
  }

  // Function to confirm the order and store order details in the database
  void confirmOrder() async {
    try {
      // Create a map with the order details to be stored
      Map<String, dynamic> orderInfoMap = {
        "Product": widget.name, // Product name
        "Price": widget.price, // Product price
        "Name": name, // User's name
        "Email": mail, // User's email
        "Image": image, // User's image
        "ProductImage": widget.image, // Product image
        "Status": "On the way!", // Order status
      };

      // Call the database method to store the order details
      await DatabaseMethods().orderDetails(orderInfoMap);

      // Show a success dialog after placing the order
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green), // Check icon for success
                  SizedBox(width: 10),
                  Text("Order Placed Successfully") // Success message
                ],
              )
            ],
          ),
        ),
      );
    } catch (e) {
      print("Error confirming order: $e"); // Log the error
      // Show a failure dialog if the order placement fails
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text("Failed to place order. Please try again."), // Failure message
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfef5f1), // Light background color for the screen
      body: Container(
        padding: EdgeInsets.only(top: 50.0), // Padding at the top of the container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align elements to the left
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to the previous screen when the back arrow is tapped
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0), // Margin for the back button
                    padding: EdgeInsets.all(10), // Padding inside the back button container
                    decoration: BoxDecoration(
                      border: Border.all(), // Border for the back button
                      borderRadius: BorderRadius.circular(30), // Rounded corners for the back button
                    ),
                    child: Icon(Icons.arrow_back_ios_new_outlined), // Back arrow icon
                  ),
                ),
                Center(
                  child: Image.network(
                    widget.image, // Display the product image
                    height: 400, // Set the image height
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0), // Padding inside the product detail container
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the details section
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), // Rounded top-left corner
                    topRight: Radius.circular(20), // Rounded top-right corner
                  ),
                ),
                width: MediaQuery.of(context).size.width, // Full screen width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between product name and price
                      children: [
                        Text(widget.name, style: AppWidget.boldTextFeildStyle()), // Display product name
                        Text(
                          widget.price, // Display product price
                          style: TextStyle(
                            color: Color(0xFFfd6f3e), // Orange color for price
                            fontSize: 23.0, // Font size for the price
                            fontWeight: FontWeight.bold, // Bold font weight for price
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0), // Spacing between product name and details
                    Text("Details", style: AppWidget.semiboldTextFeildStyle()), // Display 'Details' heading
                    SizedBox(height: 10.0), // Spacing between 'Details' and product description
                    Text(widget.detail), // Display product details
                    SizedBox(height: 90.0), // Spacing before the "Buy Now" button
                    GestureDetector(
                      onTap: confirmOrder, // Trigger the order confirmation when tapped
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0), // Vertical padding for the button
                        decoration: BoxDecoration(
                          color: Color(0xFFfd6f3e), // Orange background for the button
                          borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                        ),
                        width: MediaQuery.of(context).size.width, // Full screen width for the button
                        child: Center(
                          child: Text(
                            "Buy Now", // Button text
                            style: TextStyle(
                              color: Colors.white, // White text color
                              fontSize: 20.0, // Font size for the button text
                              fontWeight: FontWeight.bold, // Bold font weight for the button text
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
