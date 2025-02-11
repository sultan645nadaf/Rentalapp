import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electronicsrent/Screens/categories/category_list.dart';
import 'package:electronicsrent/Screens/firebase_services.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
          future:
              _service.categories.orderBy('catName', descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container(
                height: 100,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Error loading categories'),
                        Text('See all')
                      ],
                    ),
                  ],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Container(
              height: 150, // Adjusted height
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Categories')),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, CategoryList.id);
                        },
                        child: Row(
                          children: [
                            Text(
                              'see all',
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var doc = snapshot.data?.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            height: 100, // Adjusted height
                            child: Column(
                              children: [
                                Image.network(
                                  doc?['image'],
                                  height: 50, // Adjusted image height
                                ),
                                Text(
                                  doc?['catName'],
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12), // Adjusted text size
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
