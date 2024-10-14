// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';

class UpdateRestaurant extends StatefulWidget {
  final String restaurantName;
  final int restaurantCapacity;
  final int budget;
  final String restaurantId;

  const UpdateRestaurant({
    required this.restaurantName,
    required this.restaurantCapacity,
    required this.budget,
    required this.restaurantId,
    super.key,
  });

  @override
  State<UpdateRestaurant> createState() => _UpdateRestaurantState();
}

class _UpdateRestaurantState extends State<UpdateRestaurant> {
  final TextEditingController _restaurantNameController =
      TextEditingController();
  final TextEditingController _restaurantCapacityController =
      TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    _restaurantNameController.text = widget.restaurantName;
    _restaurantCapacityController.text = widget.restaurantCapacity.toString();
    _budgetController.text = widget.budget.toString();
  }

  void _updatRestaurant() async {
    try {
      setState(() {
        _isUploading = true;
      });
      await FirebaseFirestore.instance
          .collection('restaurant_budget')
          .doc(widget.restaurantId)
          .set({
        'budget': int.parse(_budgetController.text.trim()),
        'restaurant_name': _restaurantNameController.text.trim(),
        'restaurant_capacity':
            int.parse(_restaurantCapacityController.text.trim()),
      }, SetOptions(merge: true));

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
            'تم تحديث بيانات المطعم',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isUploading = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'تم',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
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
            'حدث خطأ في التحقق',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
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
      appBar: const StyleAppBar(title: 'تحديث البيانات'),
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 114, 139, 164),
                      filled: true,
                      alignLabelWithHint: true,
                      labelText: 'اسم المطعم',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 9, 41, 248),
                        ),
                      ),
                    ),
                    controller: _restaurantNameController,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 114, 139, 164),
                      filled: true,
                      alignLabelWithHint: true,
                      labelText: 'سعة المطعم',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 9, 41, 248),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    controller: _restaurantCapacityController,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 114, 139, 164),
                      filled: true,
                      alignLabelWithHint: true,
                      labelText: 'الميزانية',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 9, 41, 248),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    controller: _budgetController,
                  ),
                  const SizedBox(height: 15),
                  if (_isUploading)
                    const CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  if (!_isUploading)
                    ElevatedButton(
                      onPressed: _updatRestaurant,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 50, 189),
                      ),
                      child: const Text(
                        'تحديث',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
