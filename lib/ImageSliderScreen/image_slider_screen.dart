import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';

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

class _ImageSliderScreenState extends State<ImageSliderScreen>
    with SingleTickerProviderStateMixin {
  static List<String> links = [];
  TabController? tabController;

  getLinks() async {
    links = [
      widget.urlImg1,
      widget.urlImg2,
      widget.urlImg3,
      widget.urlImg4,
      widget.urlImg5
    ];
  }

  @override
  void initState() {
    super.initState();
    getLinks();
    tabController = TabController(length: links.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            widget.title,
            style: TextStyle(fontFamily: 'Varela', letterSpacing: 2.0),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 6, right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      widget.address,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Varela',
                          letterSpacing: 2),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Carousel(
                    indicatorBarColor: Colors.black.withOpacity(0.2),
                    autoScrollDuration: Duration(seconds: 2),
                    animationPageDuration: Duration(milliseconds: 500),
                    activateIndicatorColor: Colors.black,
                    animationPageCurve: Curves.easeIn,
                    indicatorBarHeight: 30,
                    indicatorHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.grey,
                    stopAtEnd: false,
                    autoScroll: true,
                    items: [
                      Image.network(links[0]),
                      Image.network(links[1]),
                      Image.network(links[2]),
                      Image.network(links[3]),
                      Image.network(links[4]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Center(
                  child: Text(
                    "\$ ${widget.itemPrice}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Bebas',
                        letterSpacing: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.brush_outlined),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.itemColor,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone_outlined),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                widget.userNumber,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
