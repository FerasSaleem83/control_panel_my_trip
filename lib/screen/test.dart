// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Multiple Images to Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImagePickerPage(),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final List<Uint8List> _imageDataList = [];
  final List<String> _imageNameList = [];
  final List<String> _imageUrlList = [];

  // اختر صور متعددة من الجهاز
  void _pickImages() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files!;
      _imageDataList.clear();
      _imageNameList.clear();

      for (var file in files) {
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _imageDataList.add(reader.result as Uint8List);
            _imageNameList.add(file.name);
          });
        });
      }
    });
  }

  // رفع الصور إلى Firebase Storage
  Future<void> _uploadImages() async {
    if (_imageDataList.isEmpty) return;

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

    // تحديث أو إنشاء المستند في Firestore وتخزين الروابط في array
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('images').doc('myDoc');

    await docRef.set({
      'image_urls': FieldValue.arrayUnion(_imageUrlList),
      'uploaded_at': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload and Display Multiple Images'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageDataList.isNotEmpty
                ? Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_imageDataList.length, (index) {
                      return Column(
                        children: [
                          Image.memory(
                            _imageDataList[index],
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _imageNameList[index],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }),
                  )
                : const Text('No images selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Select Images'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadImages,
              child: const Text('Upload Images'),
            ),
            const SizedBox(height: 20),
            _imageUrlList.isNotEmpty
                ? Column(
                    children: [
                      const Text('Images uploaded successfully!'),
                      const Text('Download URLs:'),
                      ..._imageUrlList.map((url) => SelectableText(url)),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
