// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_trip_controle_panel/screen/update_restaurant.dart';
import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';

class InformationRestaurantAdmin extends StatefulWidget {
  final String restaurantName;
  final List<String> imageUrls;
  final double latitude;
  final double longitude;
  final int numberVisitors;
  final int restaurantCapacity;
  final int budget;
  final String restaurantId;

  bool islogin = true;

  InformationRestaurantAdmin({
    required this.restaurantName,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
    required this.numberVisitors,
    required this.restaurantCapacity,
    required this.budget,
    required this.restaurantId,
    super.key,
  });

  @override
  State<InformationRestaurantAdmin> createState() =>
      _InformationRestaurantAdminState();
}

class _InformationRestaurantAdminState
    extends State<InformationRestaurantAdmin> {
  int _currentIndex = 0;
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
        markerId: const MarkerId('stored_location'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.restaurantName,
        ),
      ),
    );
  }

  // دالة لحذف بيانات المكان
  Future<void> deleteRestaurant() async {
    try {
      await FirebaseFirestore.instance
          .collection('restaurant_budget')
          .doc(widget.restaurantId)
          .delete();
      Navigator.pop(context);
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 38, 35, 35),
          title: const Text(
            'خطأ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          content: const Text(
            'حدث خطأ أثناء حذف المطعم',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 83, 0, 0),
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'حسناً',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleAppBar(
        title: 'اسم المطعم: ${widget.restaurantName}',
        actionBar: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 38, 35, 35),
                  titleTextStyle: const TextStyle(color: Colors.black),
                  content: const Text(
                    'هل أنت متأكد أنك تريد حذف هذا المطعم؟ ',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              deleteRestaurant();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text(
                              'حذف',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 83, 0, 0),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text(
                              'الغاء',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.delete),
        ),
      ),
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(24, 0, 101, 7),
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 300.0,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: _currentIndex,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                      items: widget.imageUrls.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.imageUrls.length; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: 15.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == i ? Colors.black : Colors.grey,
                      ),
                    ),
                ],
              ),
              Text(
                ' عدد الزوار: ${widget.numberVisitors}',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                ' سعة المطعم: ${widget.restaurantCapacity}',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 2,
                child: GoogleMap(
                  onMapCreated: (controller) {
                    setState(
                      () {
                        mapController = controller;
                      },
                    );
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.latitude,
                      widget.longitude,
                    ),
                    zoom: 17,
                  ),
                  markers: markers,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'الميزانية:',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'أقل ميزانية: ${widget.budget}',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        splashColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateRestaurant(
                  restaurantName: widget.restaurantName,
                  restaurantCapacity: widget.restaurantCapacity,
                  budget: widget.budget,
                  restaurantId: widget.restaurantId),
            ),
          );
        },
        tooltip: 'Update',
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      ),
    );
  }
}
