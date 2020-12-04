import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'item_widget.dart';

class ImageWidget extends StatelessWidget implements ItemWidget{
  final Image _image;
  final Uri itemUri;

  ImageProvider get provider => _image.image;

  ImageWidget(this.itemUri) :_image = Image.file(
      new File(itemUri.toFilePath()),
      fit: BoxFit.contain), super(key: Key("img:${itemUri.toFilePath()}"));

  @override
  Widget build(BuildContext context) => _image;


}
