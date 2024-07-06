import 'package:app/generated/l10n.dart';
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
        title: Text(S.of(context).image_view),
      ),
      body: Expanded(
        child: Center(
          child: Image.network(GlobalsWidgets.getPhoto(src)),
        ),
      ),
    );
  }
}
