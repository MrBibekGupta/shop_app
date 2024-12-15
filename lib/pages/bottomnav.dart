import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Importing curved navigation bar package for custom navigation
import 'package:flutter/material.dart'; // Importing Flutter material design components
import 'package:shop_app/pages/home.dart'; // Importing the Home page
import 'package:shop_app/pages/Order.dart'; // Importing the Order page
import 'package:shop_app/pages/profile.dart'; // Importing the Profile page

// Defining the BottomNav widget which has a state for managing bottom navigation and page changes
class BottomNav extends StatefulWidget {
  const BottomNav({super.key}); // Constructor for BottomNav widget

  @override
  State<BottomNav> createState() => _BottomNavState(); // Creates the state for BottomNav widget
}

class _BottomNavState extends State<BottomNav> {
  // Declare a list of pages that correspond to each tab in the bottom navigation
  late List<Widget> pages;

  late Home HomePage; // Variable for the Home page
  late Order order; // Variable for the Order page
  late Profile profile; // Variable for the Profile page
  int currentTabIndex = 0; // Variable to track the currently selected tab (default is 0, the Home tab)

  @override
  void initState() {
    super.initState();
    // Initialize the page variables with the respective page widgets
    HomePage = Home();
    order = Order();
    profile = Profile();
    // Populate the 'pages' list with the corresponding page widgets
    pages = [HomePage, order, profile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body of the Scaffold will display the page corresponding to the selected tab
      body: pages[currentTabIndex], // Display the current page based on 'currentTabIndex'

      // Bottom navigation bar that allows switching between pages
      bottomNavigationBar: CurvedNavigationBar(
        height: 65, // Height of the bottom navigation bar
        backgroundColor: Color(0xfff2f2f2), // Background color of the bottom navigation bar
        color: Colors.black, // Color of the navigation items
        animationDuration: Duration(milliseconds: 500), // Duration of the animation when switching tabs
        onTap: (int index) {
          // This function gets called when a tab is tapped, updating the selected tab index
          setState(() {
            currentTabIndex = index; // Update the current tab index based on the tapped tab
          });
        },
        // Define the items in the bottom navigation bar: home, orders, and profile icons
        items: [
          Icon(
            Icons.home_outlined, // Home icon
            color: Colors.white, // Icon color
          ),
          Icon(
            Icons.shopping_bag_outlined, // Orders icon
            color: Colors.white, // Icon color
          ),
          Icon(
            Icons.person_outlined, // Profile icon
            color: Colors.white, // Icon color
          )
        ],
      ),
    );
  }
}
