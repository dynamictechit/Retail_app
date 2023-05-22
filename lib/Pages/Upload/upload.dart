import 'dart:io';
import 'package:bizmodo_emenu/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Config/utils.dart';
import '../../Theme/style.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File? image;
  String frontPath = 'no_file_choosen'.tr;
  Future pickContactImage() async {
    try {
      //final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.camera);
      int? fileSizeInBytes = await image?.length();
      double fileSizeInKB = fileSizeInBytes! / 1024;
      double fileSizeInMB = fileSizeInKB / 1024;
      print('size ${fileSizeInMB}');
      print(fileSizeInMB);
      if (image != null && fileSizeInMB <= 1) {
        final imageTemporary = File(image.path);
        frontPath = image.path;
        setState(() {
          this.image = imageTemporary;
        });
      } else if (fileSizeInMB > 1) {
        return showToast('file_size_isGreater'.tr);
      } else {
        return showToast('no_image_picked'.tr);
      }
    } on PlatformException catch (ex) {
      print('Failed to pick Image: $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload'.tr),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'selected_customer'.tr + ':',
              style: appBarHeaderStyle,
            ),
            Text('Walk-in'),
            SizedBox(
              height: 20,
            ),
            Text(
              'Upload Image:',
              style: appBarHeaderStyle,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                pickContactImage();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: kWhiteColor),
                child: (image != null)
                    ? Center(
                        child: Image.file(
                          image!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}