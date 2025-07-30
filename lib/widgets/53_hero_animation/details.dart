import 'package:flutter/material.dart';
import 'module.dart';

class DetailsScreen extends StatelessWidget {
  final ItemModel item;
  const DetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(title: Text(item.title)),
      body: Hero(
        tag: item.title,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
