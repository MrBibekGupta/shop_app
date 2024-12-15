import 'package:flutter/material.dart'; // Importing Flutter's material design components
import 'package:shop_app/admin/add_product.dart'; // Importing the AddProduct screen
import 'package:shop_app/admin/all_orders.dart'; // Importing the AllOrders screen
import 'package:shop_app/widget/support_widget.dart'; // Importing custom widgets for styling (Assumed to be implemented elsewhere)

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key}); // Constructor for HomeAdmin widget

  @override
  State<HomeAdmin> createState() => _HomeAdminState(); // Creates the state for this widget
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2), // Setting the background color for the scaffold
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2), // AppBar color matches the background
        title: Text(
          "Home Admin", // Title text for the app bar
          style: AppWidget.boldTextFeildStyle(), // Custom text style for the title
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0), // Margin around the content
        child: Column(
          children: [
            SizedBox(height: 50.0,), // Adds space between elements
            // GestureDetector for "Add Product" button
            GestureDetector(
              onTap: (){
                // Navigating to AddProduct screen when tapped
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProduct()));
              },
              child: Material(
                elevation: 3.0, // Shadow effect for the button
                borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0), // Padding inside the button
                  width: MediaQuery.of(context).size.width, // Full width of the screen
                  decoration: BoxDecoration(
                      color: Colors.white, // Background color of the button
                      borderRadius: BorderRadius.circular(10)), // Rounded corners for the button
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the button contents
                    children: [
                      Icon(
                        Icons.add, // Add icon for the button
                        size: 50.0, // Size of the icon
                      ),
                      SizedBox(width: 20.0,), // Space between the icon and text
                      Text(
                        "Add Product", // Text label for the button
                        style: AppWidget.boldTextFeildStyle(), // Custom text style for the button label
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 80.0,), // Adds space between buttons
            // GestureDetector for "All Orders" button
            GestureDetector(
              onTap: (){
                // Navigating to AllOrders screen when tapped
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AllOrders()));
              },
              child: Material(
                elevation: 3.0, // Shadow effect for the button
                borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0), // Padding inside the button
                  width: MediaQuery.of(context).size.width, // Full width of the screen
                  decoration: BoxDecoration(
                      color: Colors.white, // Background color of the button
                      borderRadius: BorderRadius.circular(10)), // Rounded corners for the button
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the button contents
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined, // Icon for viewing all orders
                        size: 50.0, // Size of the icon
                      ),
                      SizedBox(width: 20.0,), // Space between the icon and text
                      Text(
                        "All Orders", // Text label for the button
                        style: AppWidget.boldTextFeildStyle(), // Custom text style for the button label
                      )
                    ],
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
