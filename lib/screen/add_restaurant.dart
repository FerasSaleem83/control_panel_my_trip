// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';
//import 'package:my_trip_controle_panel/widget/image_picker.dart';

class AddRestaurantPage extends StatefulWidget {
  const AddRestaurantPage({super.key});

  @override
  State<AddRestaurantPage> createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<File> images = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isUploading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void add() async {
    final valid = formKey.currentState!.validate();
    if (!valid || markers.isEmpty || images.isEmpty) {
      return;
    }
    try {
      setState(() {
        isUploading = true;
      });

      final List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        final imagePath =
            'images/${restaurantNameController.text.trim()}/${restaurantNameController.text.trim()}_$i.jpg';
        final UploadTask uploadTask =
            FirebaseStorage.instance.ref().child(imagePath).putFile(images[i]);
        final TaskSnapshot downloadUrl = (await uploadTask);
        final String url = await downloadUrl.ref.getDownloadURL();
        imageUrls.add(url);
      }

      final DocumentReference documentReference =
          await _firestore.collection('restaurant_budget').add(
        {
          'restaurantId': '',
          'latitude': markers.first.position.latitude,
          'longitude': markers.first.position.longitude,
          'budget': int.parse(budgetController.text.trim()),
          'restaurant_name': restaurantNameController.text.trim(),
          'image_urls': imageUrls,
          'restaurant_capacity': int.parse(capacityController.text.trim()),
          'number_Visitors': 0,
          'number_chairs_avilable': int.parse(capacityController.text.trim()),
        },
      );

      DocumentReference restaurantReference = FirebaseFirestore.instance
          .collection('restaurant_budget')
          .doc(documentReference.id);
      await restaurantReference.set({
        'restaurantId': documentReference.id,
      }, SetOptions(merge: true));

      setState(() {
        isUploading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 38, 35, 35),
          title: const Text(
            'نجح',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          content: const Text(
            'تم اضافة المطعم بنجاح',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text(
                      'تم',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } catch (e) {
      setState(() {
        isUploading = false;
      });
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
            'حدث خطأ أثناء إضافة المطعم',
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

  void searchLocation() async {
    String locationName = searchController.text;
    List<Location> locations = await locationFromAddress(locationName);

    if (locations.isNotEmpty) {
      Location firstLocation = locations.first;
      LatLng latLng = LatLng(firstLocation.latitude, firstLocation.longitude);

      // تحديث موقع الكاميرا على الخريطة
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 17));

      setState(() {
        markers.clear();
        markers.add(Marker(
          markerId: const MarkerId('selected-location'),
          position: latLng,
        ));
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('خطأ'),
            content: const Text('الموقع غير موجود'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('تم'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StyleAppBar(title: 'صفحة إضافة  مطعم'),
      body: Background(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'اسم المطعم',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'اسم المطعم',
                                hintText: 'ادخل اسم المطعم',
                                fillColor: Colors.grey[100],
                                filled: true,
                                alignLabelWithHint: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 2.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 20,
                                ),
                              ),
                              controller: restaurantNameController,
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'يرجى ادخال اسم المطعم';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'سعة المطعم',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'سعة المطعم',
                                hintText: 'ادخل سعة المطعم',
                                fillColor: Colors.grey[100],
                                filled: true,
                                alignLabelWithHint: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 2.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 20,
                                ),
                              ),
                              controller: capacityController,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'يرجى ادخال سعة المطعم';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  const SizedBox(height: 20),
                  // UserImagePicker(
                  //   onPickImages: (pickedImage) {
                  //     setState(() {
                  //       images = pickedImage;
                  //     });
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'أقل ميزانية',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'الميزانية',
                            hintText: 'ادخل الميزانية',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            fillColor: Colors.grey[100],
                            filled: true,
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 20,
                            ),
                          ),
                          controller: budgetController,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى ادخال الميزانية';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'ابحث عن المطعم',
                            hintText: 'ادخل اسم المطعم',
                            fillColor: Colors.grey[100],
                            filled: true,
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 20,
                            ),
                          ),
                          controller: searchController,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 65,
                        child: Expanded(
                          child: ElevatedButton.icon(
                            onPressed: searchLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              textStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              padding: const EdgeInsets.all(15),
                            ),
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            label: const Text(''),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 250,
                    width: 375,
                    child: GoogleMap(
                      onTap: (position) {
                        setState(() {
                          markers.clear();
                          markers.add(Marker(
                            markerId: const MarkerId('selected-location'),
                            position: position,
                          ));
                        });
                      },
                      onMapCreated: (controller) {
                        setState(
                          () {
                            mapController = controller;
                          },
                        );
                      },
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(
                          31.788938,
                          35.928986,
                        ),
                        zoom: 17,
                      ),
                      markers: markers,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isUploading)
                    const CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: add,
        tooltip: 'اضافة مطعم',
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}
