import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';

class CategoryCardWidget extends StatelessWidget {
  final Category category;

  const CategoryCardWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFF0c4160),
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 0,
                offset: Offset(0, 2),
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            category.name,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}