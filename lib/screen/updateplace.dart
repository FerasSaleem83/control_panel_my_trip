// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';

class UpdatePlace extends StatefulWidget {
  final String placeName;
  final int placeCapacity;
  final int fromBudget;
  final int toBudget;
  final String placeId;

  const UpdatePlace({
    required this.placeName,
    required this.placeCapacity,
    required this.fromBudget,
    required this.toBudget,
    required this.placeId,
    super.key,
  });

  @override
  State<UpdatePlace> createState() => _UpdatePlaceState();
}

class _UpdatePlaceState extends State<UpdatePlace> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _placeCapacityController =
      TextEditingController();
  final TextEditingController _fromBudgetController = TextEditingController();
  final TextEditingController _toBudgetController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    _placeNameController.text = widget.placeName;
    _placeCapacityController.text = widget.placeCapacity.toString();
    _fromBudgetController.text = widget.fromBudget.toString();
    _toBudgetController.text = widget.toBudget.toString();
  }

  void _updatPlace() async {
    try {
      setState(() {
        _isUploading = true;
      });
      await FirebaseFirestore.instance
          .collection('trip_budget')
          .doc(widget.placeId)
          .set({
        'from_budget': int.parse(_fromBudgetController.text.trim()),
        'to_budget': int.parse(_toBudgetController.text.trim()),
        'place_name': _placeNameController.text.trim(),
        'place_capacity': int.parse(_placeCapacityController.text.trim()),
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
            'تم تحديث بيانات المكان',
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
                      labelText: 'اسم المكان',
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
                    controller: _placeNameController,
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
                      labelText: 'سعة المكان',
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
                    controller: _placeCapacityController,
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
                      labelText: 'الميزانية من',
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
                    controller: _fromBudgetController,
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
                      labelText: 'الميزانية إلى',
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
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    controller: _toBudgetController,
                  ),
                  const SizedBox(height: 15),
                  if (_isUploading)
                    const CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  if (!_isUploading)
                    ElevatedButton(
                      onPressed: _updatPlace,
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
