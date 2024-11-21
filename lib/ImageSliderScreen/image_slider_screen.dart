import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late ScrollController _scrollController; // Define the ScrollController

  getLinks() {
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
    _scrollController = ScrollController(); // Initialize the ScrollController
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the ScrollController
    tabController?.dispose(); // Dispose of the TabController
    super.dispose();
  }

  String? url;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.teal,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            widget.title,
            style: const TextStyle(fontFamily: 'Varela', letterSpacing: 2.0),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          controller: _scrollController, // Attach the ScrollController
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 6, right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      widget.address,
                      style: const TextStyle(
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: size.height * 0.5,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Carousel(
                    indicatorBarColor: Colors.black.withOpacity(0.2),
                    autoScrollDuration: const Duration(seconds: 3),
                    animationPageDuration: const Duration(milliseconds: 500),
                    activateIndicatorColor: Colors.black,
                    animationPageCurve: Curves.easeIn,
                    indicatorBarHeight: 30,
                    indicatorHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.white,
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
                padding: const EdgeInsets.only(left: 5, top: 10),
                child: Center(
                  child: Text(
                    "\$ ${widget.itemPrice}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Bebas',
                        letterSpacing: 2),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.brush_outlined),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.itemColor,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                widget.userNumber,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 368),
                  child: ElevatedButton(
                    onPressed: () async {
                      url =
                          "https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.lng}";
                      if (await launchUrl(Uri.parse(url!))) {
                        await launchUrl(Uri.parse(url!));
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                    child: const Text(
                      "Check Seller Location",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
