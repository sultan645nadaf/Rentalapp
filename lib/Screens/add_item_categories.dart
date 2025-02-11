import 'package:electronicsrent/Screens/services/database_service.dart';
import 'package:electronicsrent/Screens/services/storage_service.dart';
import 'package:electronicsrent/Screens/user_details_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductFormScreen extends StatefulWidget {
  static const String id = 'product_form_screen';

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = '';
  double _price = 0.0;
  int _quantity = 0;
  String _description = '';
  List<File> _images = [];
  final List<String> _categories = ['Laptop', 'Smartphone', 'Cooler', 'Camera','Home Appliances'];

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      List<String> imageUrls = [];
      for (File image in _images) {
        String? imageUrl = await StorageService().uploadImage(image);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      String productId = await DatabaseService().addProduct({
        'name': _name,
        'category': _category,
        'price': _price,
        'quantity': _quantity,
        'description': _description,
        'imageUrls': imageUrls,
      });

      Navigator.pushNamed(
        context,
        UserDetailsScreen.id,
        arguments: {
          'productId': productId,
          'productName': _name,
          'productImageUrl': imageUrls.isNotEmpty ? imageUrls[0] : null,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _quantity = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: Text('Pick Images'),
                ),
                SizedBox(height: 20),
                _images.isEmpty
                    ? Text('No images selected')
                    : Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _images.map((image) {
                          return Image.file(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        }).toList(),
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
