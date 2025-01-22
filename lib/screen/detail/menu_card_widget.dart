import 'package:flutter/material.dart';

class MenuCardWidget extends StatelessWidget {
  final String title;

  const MenuCardWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.blueGrey,
                blurRadius: 0,
                offset: Offset(0, 0),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))
                  ]),
              const SizedBox.square(dimension: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 90,
                  minHeight: 90,
                  maxWidth: 90,
                  minWidth: 90,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://raw.githubusercontent.com/romydewantara/Resources/refs/heads/main/images/Restaurant/banner.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
