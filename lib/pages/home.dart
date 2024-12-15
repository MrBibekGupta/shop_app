import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/pages/category_product.dart';
import 'package:shop_app/pages/product_details.dart';
import 'package:shop_app/services/database.dart';
import 'package:shop_app/services/shared_pref.dart';
import 'package:shop_app/widget/support_widget.dart';

// Home screen widget that handles the UI for the home page.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false; // Flag to manage search mode
  List categories = [
    "images/headphone_icon.png",
    "images/laptop.png",
    "images/watch.png",
    "images/TV.png"
  ]; // Category images

  List Categoryname = [
    "Headphones",
    "Laptop",
    "Watch",
    "TV",
  ]; // Category names

  var queryResultSet = []; // Stores the results of the search query
  var tempSearchStore = []; // Stores temporary search results during typing
  TextEditingController searchcontroller = TextEditingController(); // Controller for the search text field

  // Initiates search based on user input
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1); // Capitalizes first letter of input
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data()); // Adds search results to queryResultSet
        }
      });
    } else {
      tempSearchStore = []; // Clears previous search results
      queryResultSet.forEach((element) {
        if (element['UpdatedName'].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element); // Adds matching results to tempSearchStore
          });
        }
      });
    }
  }

  // Retrieves user data from shared preferences (e.g., username, user image)
  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref(); // Loads user data during the widget's initialization
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2), // Sets the background color of the screen
      body: name == null
          ? Center(child: CircularProgressIndicator()) // Displays a loading spinner if user data is not available
          : SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with user greeting and profile picture
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey, " + name!,
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                        Text(
                          "Good Morning",
                          style: AppWidget.lightTextFeildStyle(),
                        ),
                      ],
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          image!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              // Search bar section
              Container(
                margin: const EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  onChanged: (value) {
                    initiateSearch(value.toUpperCase()); // Initiates search on text change
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Products",
                      hintStyle: AppWidget.lightTextFeildStyle(),
                      prefixIcon: search
                          ? GestureDetector(
                          onTap: () {
                            // Resets the search when the close icon is tapped
                            search = false;
                            tempSearchStore = [];
                            queryResultSet = [];
                            searchcontroller.text = "";
                            setState(() {});
                          },
                          child: Icon(Icons.close))
                          : Icon(
                        Icons.search,
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(height: 20.0),
              // Search results display
              search
                  ? ListView(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                primary: false,
                shrinkWrap: true,
                children: tempSearchStore.map((element) {
                  return buildResultCard(element); // Displays search results
                }).toList(),
              )
                  : Column(
                children: [
                  // Categories section
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Categories", style: AppWidget.semiboldTextFeildStyle()),
                        Text("see all", style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 18.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Category tiles (e.g., All, Headphones, Laptops)
                  Row(
                    children: [
                      Container(
                          height: 130,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(right: 20.0),
                          decoration: BoxDecoration(
                              color: Color(0xFFFD6F3E), borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                                "All",
                                style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                              ))),
                      Expanded(
                        child: Container(
                          height: 130,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: categories.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return CategoryTile(
                                  image: categories[index],
                                  name: Categoryname[index],
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  // Displaying all products section
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("All Products", style: AppWidget.semiboldTextFeildStyle()),
                        Text("see all", style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 18.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 240,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Example product items displayed horizontally
                        buildProductCard("headphone2.png", "Headphone", "NRP 1000"),
                        buildProductCard("watch2.png", "Apple Watch", "NRP 3000"),
                        buildProductCard("laptop2.png", "Laptop", "NRP 100000"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a product card
  Widget buildProductCard(String image, String name, String price) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "images/$image",
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          Text(name, style: AppWidget.semiboldTextFeildStyle()),
          SizedBox(height: 10.0),
          Row(
            children: [
              Text(
                price,
                style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 50.0),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Color(0xFFfd6f3e), borderRadius: BorderRadius.circular(7)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ))
            ],
          )
        ],
      ),
    );
  }

  // Builds a result card for search results
  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductDetail(detail: data["Detail"], image: data["Image"], name: data["Name"], price: data["Price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(data["Image"], height: 70, width: 70, fit: BoxFit.cover)),
            SizedBox(width: 20.0),
            Text(data["Name"], style: AppWidget.semiboldTextFeildStyle())
          ],
        ),
      ),
    );
  }
}

// Widget for category tiles in the home screen
class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProduct(category: name))); // Navigates to category page on tap
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            Icon(Icons.arrow_forward) // Arrow icon indicating navigation
          ],
        ),
      ),
    );
  }
}
