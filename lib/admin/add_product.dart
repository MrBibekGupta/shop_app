import 'dart:io'; // Importing file handling
import 'package:flutter/material.dart'; // Flutter Material package for UI elements
import 'package:image_picker/image_picker.dart'; // For picking images from the gallery
import 'package:random_string/random_string.dart'; // To generate random strings
import 'package:shop_app/widget/support_widget.dart'; // Custom widget for styling (Assumed to be implemented elsewhere)
import 'package:shop_app/services/database.dart'; // Custom service for database operations (Assumed to be implemented elsewhere)
import 'package:supabase/supabase.dart'; // Supabase package for database and storage operations

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Declaring the ImagePicker to select images from the gallery
  final ImagePicker _picker = ImagePicker();

  // Variable to hold selected image
  File? selectedImage;

  // Controllers to handle the input from TextFields
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();

  // Method to pick an image from the gallery
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path); // Store the picked image
    setState(() {}); // Refresh UI to display selected image
  }

  // Method to upload product details to Supabase
  uploadItem() async {
    // Check if both image and name are provided
    if (selectedImage != null && namecontroller.text.isNotEmpty) {
      String addId = randomAlphaNumeric(10); // Generate a random ID for the product

      // Upload image to Supabase storage and get the image URL
      String? imageUrl = await DatabaseMethods().uploadImageToSupabase(selectedImage!);

      if (imageUrl != null) {
        String firstLetter = namecontroller.text.substring(0, 1).toUpperCase(); // Get the first letter of the product name

        // Create a map to store product details
        Map<String, dynamic> addProduct = {
          "Name": namecontroller.text, // Product name
          "Image": imageUrl,  // Image URL from Supabase
          "SearchKey": firstLetter, // First letter of product name for searching
          "UpdatedName": namecontroller.text.toUpperCase(), // Uppercase product name for search
          "Price": pricecontroller.text, // Product price
          "Detail": detailcontroller.text, // Product description
        };

        // Add the product details to Firebase (or another database service)
        await DatabaseMethods().addProduct(addProduct, value!).then((value) async {
          // Add product to all products collection
          await DatabaseMethods().addAllProducts(addProduct);

          // Clear the selected image and text fields
          selectedImage = null;
          namecontroller.text = "";

          // Show a success message to the user
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Product has been uploaded Successfully!!!",
              style: TextStyle(fontSize: 20.0),
            ),
          ));
        });
      } else {
        // If image upload failed, show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Failed to upload image",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      }
    }
  }

  // Category list for dropdown selection
  String? value;
  final List<String> categoryitem = ['Watch', 'Laptop', 'TV', 'Headphones'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          // Action when back button is tapped
          onTap: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          "Add Product",
          style: AppWidget.semiboldTextFeildStyle(), // Custom text style from support_widget.dart
        ),
      ),
      body: SingleChildScrollView( // Allows scrolling in case the keyboard opens or the content overflows
        child: Container(
          margin: EdgeInsets.all(20.0), // Margin for content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
            children: [
              Text(
                "Upload the Product Image", // Title for the image upload section
                style: AppWidget.lightTextFeildStyle(), // Custom text style
              ),
              SizedBox(height: 20.0),
              selectedImage == null
                  ? GestureDetector(
                // If no image is selected, show an icon to prompt image selection
                onTap: () {
                  getImage(); // Call the getImage function to pick an image
                },
                child: Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.camera_alt_outlined), // Camera icon
                  ),
                ),
              )
                  : Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        selectedImage!, // Display the selected image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Name", style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              _buildTextField(namecontroller), // Product name input field
              SizedBox(height: 20.0),
              Text("Product Price", style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              _buildTextField(pricecontroller), // Product price input field
              SizedBox(height: 20.0),
              Text("Product Detail", style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              _buildTextField(detailcontroller, maxLines: 6), // Product description input field
              SizedBox(height: 20.0),
              Text("Product Category", style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              _buildCategoryDropdown(), // Dropdown to select product category
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: uploadItem, // Trigger the uploadItem function when button is pressed
                  child: Text(
                    "Add Product", // Button text
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build TextField with a controller
  Widget _buildTextField(TextEditingController controller, {int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFececf8), // Light background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: TextField(
        controller: controller, // Use provided controller
        maxLines: maxLines, // Allow multiple lines if needed
        decoration: InputDecoration(border: InputBorder.none), // No border for the TextField
      ),
    );
  }

  // Helper function to build category dropdown
  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFececf8), // Light background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: categoryitem
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: AppWidget.semiboldTextFeildStyle()), // Custom text style
          ))
              .toList(),
          onChanged: (value) => setState(() {
            this.value = value; // Update selected category
          }),
          dropdownColor: Colors.white, // Dropdown background color
          hint: Text("Select Category"), // Dropdown hint text
          iconSize: 36, // Icon size for dropdown arrow
          icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Dropdown icon
          value: value, // The selected category
        ),
      ),
    );
  }
}
