import 'package:flutter/material.dart';

class ImageSliderScreen extends StatefulWidget {
  final String title, urlImg1, urlImg2, urlImg3, urlImg4, urlImg5;
  final String itemColor, itemPrice, description, address, userNumber;
  final double lat, lng;
  const ImageSliderScreen(
      {super.key,
      required this.title,
      required this.urlImg1,
      required this.urlImg2,
      required this.urlImg3,
      required this.urlImg4,
      required this.urlImg5,
      required this.itemColor,
      required this.itemPrice,
      required this.description,
      required this.address,
      required this.userNumber,
      required this.lat,
      required this.lng});

  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Image Slider Screen"),
        ),
      ),
    );
  }
}
