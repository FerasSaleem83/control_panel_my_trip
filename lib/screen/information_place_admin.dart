// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_trip_controle_panel/screen/splash_screen.dart';
import 'package:my_trip_controle_panel/screen/updateplace.dart';
import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';

class InformationPlaceAdmin extends StatefulWidget {
  final String placeId;

  bool islogin = true;

  InformationPlaceAdmin({
    required this.placeId,
    super.key,
  });

  @override
  State<InformationPlaceAdmin> createState() => _InformationPlaceAdminState();
}

class _InformationPlaceAdminState extends State<InformationPlaceAdmin> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> dataFuture;

  int _currentIndex = 0;
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Future<DocumentSnapshot<Map<String, dynamic>>> getData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('trip_budget')
        .doc(widget.placeId)
        .get();

    return snapshot;
  }

  @override
  void initState() {
    super.initState();
    dataFuture = getData();
    dataFuture.then((snapshot) {
      double latitude = snapshot.data()?['latitude'].toDouble() ??
          0; // استخراج اسم المكان من قاعدة البيانات
      double longitude = snapshot.data()?['longitude'].toDouble() ??
          0; // استخراج اسم المكان من قاعدة البيانات
      String placeName = snapshot.data()?['place_name'].toDouble() ??
          0; // استخراج اسم المكان من قاعدة البيانات

      markers.add(
        Marker(
          markerId: const MarkerId('stored_location'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: placeName,
          ),
        ),
      );
    });
  }

  // دالة لحذف بيانات المكان
  Future<void> deletePlace() async {
    try {
      await FirebaseFirestore.instance
          .collection('trip_budget')
          .doc(widget.placeId)
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
            'حدث خطأ أثناء حذف المكان',
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
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            String placeName = snapshot.data!['place_name'];
            final List<String> imageUrls =
                (snapshot.data!['image_urls'] as List).cast<String>();
            double toBudget = snapshot.data!['to_budget'].toDouble();
            double fromBudget = snapshot.data!['from_budget'].toDouble();
            double longitude = snapshot.data!['longitude'].toDouble();
            double latitude = snapshot.data!['latitude'].toDouble();
            double numberVisitors =
                snapshot.data!['number_Visitors'].toDouble();

            return Scaffold(
              appBar: StyleAppBar(
                title: 'اسم المكان: $placeName',
                actionBar: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 38, 35, 35),
                          titleTextStyle: const TextStyle(color: Colors.black),
                          content: const Text(
                            'هل أنت متأكد أنك تريد حذف هذا المكان؟ ',
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
                                      deletePlace();
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: const Color.fromARGB(24, 0, 101, 7),
                        child: Expanded(
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
                            items: imageUrls.map((imageUrl) {
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
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < imageUrls.length; i++)
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              width: 15.0,
                              height: 15.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == i
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        ' عدد الزوار: $numberVisitors',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 300,
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
                                      latitude,
                                      longitude,
                                    ),
                                    zoom: 17,
                                  ),
                                  markers: markers,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: const Color.fromARGB(255, 83, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'الميزانية:',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'من: $fromBudget',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        Text(
                                          'إلى: $toBudget',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
                      builder: (context) => UpdatePlace(
                          placeName: placeName,
                          fromBudget: fromBudget,
                          toBudget: toBudget,
                          placeId: widget.placeId),
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
          } else {
            return const Center(
              child: Text('لا يوجد بيانات'),
            );
          }
        });
  }
}
