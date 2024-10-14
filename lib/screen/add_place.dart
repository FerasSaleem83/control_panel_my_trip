// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, unnecessary_null_comparison

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';
import 'package:my_trip_controle_panel/widget/image_picker.dart';
import 'package:http/http.dart' as http;

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  //final TextEditingController budgetFromController = TextEditingController();
  //final TextEditingController budgetToController = TextEditingController();
  final TextEditingController placeNameController = TextEditingController();
  //final TextEditingController capacityController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  List<Uint8List> _imageDataList = [];
  List<String> _imageNameList = [];
  final List<String> _imageUrlList = [];
  bool heritageSelected = false;
  bool entertainmentSelected = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isUploading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void add() async {
    final valid = formKey.currentState!.validate();
    // print(
    //     "اجدد حالة 'latitude': ${markers.first.position.latitude},    'longitude': ${markers.first.position.longitude},          'from_budget': ${int.parse(budgetFromController.text.trim())},          'to_budget': ${int.parse(budgetToController.text.trim())},          'place_name': ${placeNameController.text.trim()},          'image_urls': $_imageUrlList,          'place_capacity': ${int.parse(capacityController.text.trim())},          'number_Visitors': 0,          'number_chairs_avilable': ${int.parse(capacityController.text.trim())},          'details': ${detailsController.text.trim()},");
    if (!valid || markers.isEmpty) {
      return;
      // print(
      //     'valid: $valid, markers.isEmpty: ${markers.isEmpty}, images.isEmpty: ${_imageDataList.isEmpty}  12  حالة ');
    }

    try {
      setState(() {
        isUploading = true;
      });

      FirebaseStorage storage = FirebaseStorage.instance;

      for (int i = 0; i < _imageDataList.length; i++) {
        String filePath =
            'images/${DateTime.now().millisecondsSinceEpoch}_${_imageNameList[i]}';
        Reference ref = storage.ref().child(filePath);

        // رفع الصورة
        UploadTask uploadTask = ref.putData(_imageDataList[i]);
        TaskSnapshot snapshot = await uploadTask;

        // الحصول على رابط التحميل
        String downloadUrl = await snapshot.ref.getDownloadURL();
        // إضافة الرابط إلى قائمة الروابط
        _imageUrlList.add(downloadUrl);
      }
      if (_imageUrlList.isEmpty) {
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
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            content: const Text(
              'يرجى ادخال صورة على الأقل',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'تم',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      } else {
        if (entertainmentSelected == true) {
          final DocumentReference documentReference =
              await _firestore.collection('trip_budget').add(
            {
              'placeId': '',
              'latitude': markers.first.position.latitude,
              'longitude': markers.first.position.longitude,
              'from_budget': 10, //int.parse(budgetFromController.text.trim()),
              'to_budget': 50, //int.parse(budgetToController.text.trim()),
              'place_name': placeNameController.text.trim(),
              'image_urls': _imageUrlList,
              'place_capacity':
                  10000, //int.parse(capacityController.text.trim()),
              'number_Visitors': 0,
              'number_chairs_avilable':
                  10000, //int.parse(capacityController.text.trim()),
              'details': detailsController.text.trim(),
            },
          );

          DocumentReference placeReference = FirebaseFirestore.instance
              .collection('trip_budget')
              .doc(documentReference.id);
          await placeReference.set({
            'placeId': documentReference.id,
          }, SetOptions(merge: true));

          await _firestore.collection('entertainment_places').add(
            {
              'placeId': '',
              'latitude': markers.first.position.latitude,
              'longitude': markers.first.position.longitude,
              'from_budget': 10, //int.parse(budgetFromController.text.trim()),
              'to_budget': 50, //int.parse(budgetToController.text.trim()),
              'place_name': placeNameController.text.trim(),
              'image_urls': _imageUrlList,
              'place_capacity':
                  10000, //int.parse(capacityController.text.trim()),
              'number_Visitors': 0,
              'number_chairs_avilable':
                  10000, //int.parse(capacityController.text.trim()),
              'details': detailsController.text.trim(),
            },
          );

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 38, 35, 35),
              title: const Text(
                'نجح',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              content: const Text(
                'تم اضافة المكان بنجاح',
                style: TextStyle(
                  color: Colors.white,
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
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
          setState(() {
            isUploading = false;
          });
        } else if (heritageSelected == true) {
          final DocumentReference documentReference =
              await _firestore.collection('trip_budget').add(
            {
              'placeId': '',
              'latitude': markers.first.position.latitude,
              'longitude': markers.first.position.longitude,
              'from_budget': 10, //int.parse(budgetFromController.text.trim()),
              'to_budget': 50, //int.parse(budgetToController.text.trim()),
              'place_name': placeNameController.text.trim(),
              'image_urls': _imageUrlList,
              'place_capacity':
                  10000, //int.parse(capacityController.text.trim()),
              'number_Visitors': 0,
              'number_chairs_avilable':
                  10000, //int.parse(capacityController.text.trim()),
              'details': detailsController.text.trim(),
            },
          );

          DocumentReference placeReference = FirebaseFirestore.instance
              .collection('trip_budget')
              .doc(documentReference.id);

          await placeReference.set({
            'placeId': documentReference.id,
          }, SetOptions(merge: true));

          await _firestore.collection('heritage_places').add(
            {
              'placeId': '',
              'latitude': markers.first.position.latitude,
              'longitude': markers.first.position.longitude,
              'from_budget': 10, //int.parse(budgetFromController.text.trim()),
              'to_budget': 50, //int.parse(budgetToController.text.trim()),
              'place_name': placeNameController.text.trim(),
              'image_urls': _imageUrlList,
              'place_capacity':
                  10000, //int.parse(capacityController.text.trim()),
              'number_Visitors': 0,
              'number_chairs_avilable':
                  10000, //int.parse(capacityController.text.trim()),
              'details': detailsController.text.trim(),
            },
          );

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 38, 35, 35),
              title: const Text(
                'نجح',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              content: const Text(
                'تم اضافة المكان بنجاح',
                style: TextStyle(
                  color: Colors.white,
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
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
          setState(() {
            isUploading = false;
          });
        } else {
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
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              content: const Text(
                'يرجى اختيار نوع المكان',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'تم',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isUploading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.message ?? 'Verification failed'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
            'حدث خطأ أثناء إضافة المكان',
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
    String apiKey = 'AIzaSyA4wJb3uf7Uvr_xT3QkokS8NaNdWD2iWSA';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$locationName&key=$apiKey';

    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = jsonDecode(response.body);

    if (json['status'] == 'OK') {
      double lat = json['results'][0]['geometry']['location']['lat'];
      double lng = json['results'][0]['geometry']['location']['lng'];
      LatLng latLng = LatLng(lat, lng);

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
      appBar: const StyleAppBar(title: 'صفحة إضافة  مكان'),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                'اسم المكان',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'اسم المكان',
                                  hintText: 'ادخل اسم المكان',
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
                                controller: placeNameController,
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى ادخال اسم المكان';
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
                      ),
                      const SizedBox(width: 20),
                      // Expanded(
                      //     child: Column(
                      //   children: [
                      //     const Text(
                      //       'سعة المكان',
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     TextFormField(
                      //       decoration: InputDecoration(
                      //         labelText: 'سعة المكان',
                      //         hintText: 'ادخل سعة المكان',
                      //         fillColor: Colors.grey[100],
                      //         filled: true,
                      //         alignLabelWithHint: true,
                      //         enabledBorder: OutlineInputBorder(
                      //           borderSide: const BorderSide(
                      //             color: Colors.black,
                      //             width: 1.0,
                      //           ),
                      //           borderRadius: BorderRadius.circular(10.0),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderSide: const BorderSide(
                      //             color: Colors.blue,
                      //             width: 2.5,
                      //           ),
                      //           borderRadius: BorderRadius.circular(10.0),
                      //         ),
                      //         contentPadding: const EdgeInsets.symmetric(
                      //           vertical: 5.0,
                      //           horizontal: 20,
                      //         ),
                      //       ),
                      //       controller: capacityController,
                      //       obscureText: false,
                      //       keyboardType: TextInputType.number,
                      //       validator: (value) {
                      //         if (value == null || value.trim().isEmpty) {
                      //           return 'يرجى ادخال سعة المكان';
                      //         }
                      //         return null;
                      //       },
                      //       style: const TextStyle(
                      //         fontSize: 12,
                      //       ),
                      //     ),
                      //   ],
                      // )),
                    ],
                  ),
                  const SizedBox(height: 20),

                  UserImagePicker(
                    onPickImages: (imageData, imageName) {
                      setState(() {
                        _imageDataList = imageData;
                        _imageNameList = imageName;
                      });
                    },
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Column(
                  //           children: [
                  //             const Text(
                  //               'من',
                  //               style: TextStyle(color: Colors.black),
                  //             ),
                  //             TextFormField(
                  //               decoration: InputDecoration(
                  //                 labelText: 'الميزانية',
                  //                 hintText: 'ادخل الميزانية',
                  //                 labelStyle: const TextStyle(
                  //                   color: Colors.black,
                  //                 ),
                  //                 fillColor: Colors.grey[100],
                  //                 filled: true,
                  //                 alignLabelWithHint: true,
                  //                 enabledBorder: OutlineInputBorder(
                  //                   borderSide: const BorderSide(
                  //                     color: Colors.black,
                  //                     width: 1.0,
                  //                   ),
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 focusedBorder: OutlineInputBorder(
                  //                   borderSide: const BorderSide(
                  //                     color: Colors.blue,
                  //                     width: 2.5,
                  //                   ),
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 contentPadding: const EdgeInsets.symmetric(
                  //                   vertical: 5.0,
                  //                   horizontal: 20,
                  //                 ),
                  //               ),
                  //               controller: budgetFromController,
                  //               obscureText: false,
                  //               keyboardType: TextInputType.number,
                  //               validator: (value) {
                  //                 if (value == null || value.trim().isEmpty) {
                  //                   return 'يرجى ادخال الميزانية';
                  //                 }
                  //                 return null;
                  //               },
                  //               style: const TextStyle(
                  //                 fontSize: 12,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 20),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Column(
                  //           children: [
                  //             const Text(
                  //               'إلى',
                  //               style: TextStyle(color: Colors.black),
                  //             ),
                  //             TextFormField(
                  //               decoration: InputDecoration(
                  //                 labelText: 'الميزانية',
                  //                 hintText: 'ادخل الميزانية',
                  //                 labelStyle: const TextStyle(
                  //                   color: Colors.black,
                  //                 ),
                  //                 fillColor: Colors.grey[100],
                  //                 filled: true,
                  //                 alignLabelWithHint: true,
                  //                 enabledBorder: OutlineInputBorder(
                  //                   borderSide: const BorderSide(
                  //                     color: Colors.black,
                  //                     width: 1.0,
                  //                   ),
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 focusedBorder: OutlineInputBorder(
                  //                   borderSide: const BorderSide(
                  //                     color: Colors.blue,
                  //                     width: 2.5,
                  //                   ),
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 contentPadding: const EdgeInsets.symmetric(
                  //                   vertical: 5.0,
                  //                   horizontal: 20,
                  //                 ),
                  //               ),
                  //               controller: budgetToController,
                  //               obscureText: false,
                  //               keyboardType: TextInputType.number,
                  //               validator: (value) {
                  //                 if (value == null || value.trim().isEmpty) {
                  //                   return 'يرجى ادخال الميزانية';
                  //                 }
                  //                 return null;
                  //               },
                  //               style: const TextStyle(
                  //                 fontSize: 12,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (heritageSelected == false) {
                                  heritageSelected = true;
                                  entertainmentSelected = false;
                                } else {
                                  heritageSelected = false;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: heritageSelected == true
                                  ? Colors.white
                                  : Colors.black,
                              backgroundColor: heritageSelected == true
                                  ? Colors.blue
                                  : Colors.grey,
                              fixedSize: const Size(150, 150),
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/image/logoApp.png',
                                  height: 75,
                                  width: 75,
                                ),
                                const Text('أماكن تراثية'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (entertainmentSelected == false) {
                                  entertainmentSelected = true;
                                  heritageSelected = false;
                                } else {
                                  entertainmentSelected = false;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: entertainmentSelected == true
                                  ? Colors.white
                                  : Colors.black,
                              backgroundColor: entertainmentSelected == true
                                  ? Colors.blue
                                  : Colors.grey,
                              fixedSize: const Size(150, 150),
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/image/logoApp.png',
                                  height: 75,
                                  width: 75,
                                ),
                                const Text('أماكن ترفيهية'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'ابحث عن مكان',
                            hintText: 'ادخل اسم المكان',
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
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(15),
                            ),
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            label: const Text(''),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 300,
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                'تفاصيل المكان',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'تفاصيل المكان',
                                  hintText: 'ادخل تفاصيل المكان',
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
                                    vertical: 10.0,
                                    horizontal: 20,
                                  ),
                                ),
                                controller: detailsController,
                                obscureText: false,
                                keyboardType: TextInputType
                                    .multiline, // لتحديد كتابة نص متعدد الأسطر
                                maxLines: null, // يجعل عدد الأسطر غير محدود
                                minLines: 3, // الحد الأدنى لعدد الأسطر المرئية
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى ادخال تفاصيل المكان';
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (isUploading)
                    const CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  if (!isUploading)
                    ElevatedButton(
                      onPressed: add,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('اضافة مكان'),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
