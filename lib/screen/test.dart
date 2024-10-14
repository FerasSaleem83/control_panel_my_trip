// // import 'dart:html' as html;
// // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await Firebase.initializeApp();
// // //   runApp(MyApp());
// // // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Upload Image to Firebase',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: ImagePickerPage(),
// //     );
// //   }
// // }

// // class ImagePickerPage extends StatefulWidget {
// //   @override
// //   _ImagePickerPageState createState() => _ImagePickerPageState();
// // }

// // class _ImagePickerPageState extends State<ImagePickerPage> {
// //   Uint8List? _imageData;
// //   String? _imageName;
// //   String? _imageUrl;

// //   // اختر صورة من الجهاز
// //   void _pickImage() async {
// //     final html.FileUploadInputElement uploadInput =
// //         html.FileUploadInputElement();
// //     uploadInput.accept = 'image/*';
// //     uploadInput.click();

// //     uploadInput.onChange.listen((e) {
// //       final file = uploadInput.files!.first;
// //       final reader = html.FileReader();

// //       reader.readAsArrayBuffer(file);
// //       reader.onLoadEnd.listen((e) {
// //         setState(() {
// //           _imageData = reader.result as Uint8List;
// //           _imageName = file.name;
// //         });
// //       });
// //     });
// //   }

// //   // رفع الصورة إلى Firebase Storage
// //   Future<void> _uploadImage() async {
// //     if (_imageData == null) return;

// //     try {
// //       // حدد مسار التخزين
// //       String filePath =
// //           'images/${DateTime.now().millisecondsSinceEpoch}_${_imageName}';
// //       FirebaseStorage storage = FirebaseStorage.instance;
// //       Reference ref = storage.ref().child(filePath);

// //       // رفع الصورة
// //       UploadTask uploadTask = ref.putData(_imageData!);
// //       TaskSnapshot snapshot = await uploadTask;

// //       // الحصول على رابط التحميل
// //       String downloadUrl = await snapshot.ref.getDownloadURL();

// //       // تخزين الرابط في Firestore
// //       await FirebaseFirestore.instance.collection('images').add({
// //         'image_name': _imageName,
// //         'image_url': downloadUrl,
// //         'uploaded_at': Timestamp.now(),
// //       });

// //       setState(() {
// //         _imageUrl = downloadUrl;
// //       });

// //       print('Upload successful. Image URL: $downloadUrl');
// //     } catch (e) {
// //       print('Failed to upload image: $e');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Upload and Display Image'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               _imageData != null
// //                   ? Column(
// //                       children: [
// //                         Image.memory(_imageData!),
// //                         SizedBox(height: 10),
// //                         Text(
// //                           _imageName ?? '',
// //                           style: TextStyle(
// //                               fontSize: 16, fontWeight: FontWeight.bold),
// //                         ),
// //                       ],
// //                     )
// //                   : Text('No image selected'),
// //               SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _pickImage,
// //                 child: Text('Select Image'),
// //               ),
// //               SizedBox(height: 10),
// //               ElevatedButton(
// //                 onPressed: _uploadImage,
// //                 child: Text('Upload Image'),
// //               ),
// //               SizedBox(height: 20),
// //               _imageUrl != null
// //                   ? Column(
// //                       children: [
// //                         Text('Image uploaded successfully!'),
// //                         Text('Download URL:'),
// //                         SelectableText(_imageUrl ?? ''),
// //                       ],
// //                     )
// //                   : Container(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:html' as html;
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Upload Multiple Images to Firebase',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ImagePickerPage(),
//     );
//   }
// }

// class ImagePickerPage extends StatefulWidget {
//   @override
//   _ImagePickerPageState createState() => _ImagePickerPageState();
// }

// class _ImagePickerPageState extends State<ImagePickerPage> {
//   List<Uint8List> _imageDataList = [];
//   List<String> _imageNameList = [];
//   List<String> _imageUrlList = [];

//   // اختر صور متعددة من الجهاز
//   void _pickImages() async {
//     final html.FileUploadInputElement uploadInput =
//         html.FileUploadInputElement();
//     uploadInput.accept = 'image/*';
//     uploadInput.multiple = true;
//     uploadInput.click();

//     uploadInput.onChange.listen((e) {
//       final files = uploadInput.files!;
//       _imageDataList.clear();
//       _imageNameList.clear();

//       for (var file in files) {
//         final reader = html.FileReader();

//         reader.readAsArrayBuffer(file);
//         reader.onLoadEnd.listen((e) {
//           setState(() {
//             _imageDataList.add(reader.result as Uint8List);
//             _imageNameList.add(file.name);
//           });
//         });
//       }
//     });
//   }

//   // رفع الصور إلى Firebase Storage
//   Future<void> _uploadImages() async {
//     if (_imageDataList.isEmpty) return;

//     try {
//       FirebaseStorage storage = FirebaseStorage.instance;

//       for (int i = 0; i < _imageDataList.length; i++) {
//         String filePath =
//             'images/${DateTime.now().millisecondsSinceEpoch}_${_imageNameList[i]}';
//         Reference ref = storage.ref().child(filePath);

//         // رفع الصورة
//         UploadTask uploadTask = ref.putData(_imageDataList[i]);
//         TaskSnapshot snapshot = await uploadTask;

//         // الحصول على رابط التحميل
//         String downloadUrl = await snapshot.ref.getDownloadURL();

//         // تخزين الرابط في Firestore
//         await FirebaseFirestore.instance.collection('images').add({
//           'image_name': _imageNameList[i],
//           'image_url': downloadUrl,
//           'uploaded_at': Timestamp.now(),
//         });

//         setState(() {
//           _imageUrlList.add(downloadUrl);
//         });
//       }

//       print('Upload successful. Images URLs: $_imageUrlList');
//     } catch (e) {
//       print('Failed to upload images: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload and Display Multiple Images'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _imageDataList.isNotEmpty
//                 ? Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: List.generate(_imageDataList.length, (index) {
//                       return Column(
//                         children: [
//                           Image.memory(
//                             _imageDataList[index],
//                             width: 100,
//                             height: 100,
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             _imageNameList[index],
//                             style: TextStyle(
//                                 fontSize: 14, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       );
//                     }),
//                   )
//                 : Text('No images selected'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImages,
//               child: Text('Select Images'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _uploadImages,
//               child: Text('Upload Images'),
//             ),
//             SizedBox(height: 20),
//             _imageUrlList.isNotEmpty
//                 ? Column(
//                     children: [
//                       Text('Images uploaded successfully!'),
//                       Text('Download URLs:'),
//                       ..._imageUrlList
//                           .map((url) => SelectableText(url))
//                           .toList(),
//                     ],
//                   )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Multiple Images to Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImagePickerPage(),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  List<Uint8List> _imageDataList = [];
  List<String> _imageNameList = [];
  List<String> _imageUrlList = [];

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

    try {
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

      print('Upload successful. Images URLs: $_imageUrlList');
    } catch (e) {
      print('Failed to upload images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload and Display Multiple Images'),
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
                          SizedBox(height: 5),
                          Text(
                            _imageNameList[index],
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }),
                  )
                : Text('No images selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Select Images'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadImages,
              child: Text('Upload Images'),
            ),
            SizedBox(height: 20),
            _imageUrlList.isNotEmpty
                ? Column(
                    children: [
                      Text('Images uploaded successfully!'),
                      Text('Download URLs:'),
                      ..._imageUrlList
                          .map((url) => SelectableText(url))
                          .toList(),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
