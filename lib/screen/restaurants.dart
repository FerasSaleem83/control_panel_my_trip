import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_trip_controle_panel/screen/add_restaurant.dart';
import 'package:my_trip_controle_panel/screen/information_restaurant_admin.dart';
import 'package:my_trip_controle_panel/screen/splash_screen.dart';
import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  late Stream<List<DocumentSnapshot>> tripsStream;
  var _isUploading = false;
  late Future<DocumentSnapshot<Map<String, dynamic>>> futureBuilder;

  _uploadData() {
    setState(() {
      _isUploading = true;
    });
    tripsStream = FirebaseFirestore.instance
        .collection('restaurant_budget')
        .snapshots()
        .map((snapshot) => snapshot.docs);

    setState(() {
      _isUploading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _uploadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StyleAppBar(title: 'صفحة المطاعم'),
      body: Background(
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: tripsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (_isUploading) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData || !_isUploading) {
              List<DocumentSnapshot> trips = snapshot.data!;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // عدد الأعمدة
                      mainAxisSpacing: 2, // المسافة العمودية بين الصفوف
                      childAspectRatio: 2,
                      mainAxisExtent: 300,
                    ),
                    itemCount: (trips.length / 2).ceil(), // عدد الصفوف
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: trips
                            .sublist(
                          index * 2,
                          (index * 2) + 2 > trips.length
                              ? trips.length
                              : (index * 2) + 2,
                        )
                            .map((trip) {
                          String restaurantName = trip['restaurant_name'];
                          final List<String> imageUrls =
                              (trip['image_urls'] as List).cast<String>();
                          double latitude = trip['latitude'];
                          double longitude = trip['longitude'];
                          int numberVisitors = trip['number_Visitors'];
                          int restaurantCapacity = trip['restaurant_capacity'];
                          int fromBudget = trip['budget'];
                          String restaurantId = trip['restaurantId'];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InformationRestaurantAdmin(
                                    restaurantName: restaurantName,
                                    imageUrls: imageUrls,
                                    latitude: latitude,
                                    longitude: longitude,
                                    numberVisitors: numberVisitors,
                                    restaurantCapacity: restaurantCapacity,
                                    budget: fromBudget,
                                    restaurantId: restaurantId,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(75.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 6.0,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(35)),
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black,
                                      Colors.black,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SizedBox(
                                      width: 160,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 4.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              gradient: const LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black,
                                                  Colors.black,
                                                ],
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(imageUrls[0]),
                                              radius: 75,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 20, 1, 119),
                                            ),
                                          ),
                                          Text(
                                            restaurantName,
                                            style: const TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('لا يوجد بيانات'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        splashColor: const Color.fromARGB(255, 79, 82, 83),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRestaurantPage(),
            ),
          );
        },
        tooltip: 'Add',
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}
