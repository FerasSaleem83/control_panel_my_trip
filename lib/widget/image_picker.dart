// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onPickImages,
  });

  final void Function(List<Uint8List> imageDataList, List<String> imageNameList)
      onPickImages;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final List<Uint8List> _imageDataList = [];
  final List<String> _imageNameList = [];

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

      // Once images are loaded, trigger callback to pass image data
      widget.onPickImages(_imageDataList, _imageNameList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }),
              )
            : const Text('No images selected'),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _pickImages,
              icon: const Icon(
                Icons.image,
                color: Colors.black,
              ),
              label: const Text(
                'المعرض',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
