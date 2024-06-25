import 'package:app/utils/GlobalsWidgets.dart';
import 'package:flutter/material.dart';

class ImageViewPage extends StatelessWidget {
  final String src;
  const ImageViewPage({required this.src, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Просмотр изображения"),
      ),
      body: Expanded(
        child: Center(
          child: Image.network(GlobalsWidgets.getPhoto(src)),
        ),
      ),
    );
  }
}
