import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/const/app_color.dart';
import 'package:futsal_app/model/futsal_model.dart';
import 'package:futsal_app/pages/bottom_navigation_screen.dart';
import 'package:futsal_app/provider/basic_provider.dart';
import 'package:futsal_app/service/futsal_firebase.dart';
import 'package:futsal_app/service/image_storage.dart';
import 'package:futsal_app/widgets/text_field.dart';
import 'package:futsal_app/widgets/texts.dart';
import 'package:image_picker/image_picker.dart';

class AddFutsalPage extends ConsumerStatefulWidget {
  static const String routeName = 'add futsal_Screen';
  const AddFutsalPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFutsalPageState();
}

class _AddFutsalPageState extends ConsumerState<AddFutsalPage> {
  XFile? image;
  List<XFile>? photos;
  final TextEditingController title = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController des = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController rating = TextEditingController();
  Future<void> pickImage() async {
    var media = ImagePicker();
    final List<XFile> pickedMedia = await media.pickMultipleMedia();

    setState(() {
      photos = pickedMedia;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: AppColor.primaryColor,
              onPressed: () async {
                List<File> photoList = photos?.map((xFile) => File(xFile.path)).toList() ?? [];

                await FutsalFirebase().addFutsal(
                  FutsalModel(
                    name: title.text,
                    location: location.text,
                    phone: phone.text,
                    rating: rating.text,
                    price: price.text,
                    description: des.text,
                  ),
                );
                var photo = File(image!.path);
                await IamgeStorage().storeImage(photo: photo, name: title.text);
                await IamgeStorage().addPhotos(photos: photoList, name: title.text);
                ref.read(currentPageIndexProvider.notifier).state = 0;
                Navigator.pushReplacementNamed(context, BottomNavigationScreen.routeName);
              },
              child: texts(text: "add", color: AppColor.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.grey, image: DecorationImage(image: AssetImage('assets/images/image1.png'), fit: BoxFit.cover)),
                      )
                    : Container(
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 80,
                  child: TextButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final img = await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          image = img;
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Upload a photo',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          )
                        ],
                      )),
                ),
              ],
            ),
            NormalTextField(
              controller: title,
              text: 'Title',
            ),
            NormalTextField(
              controller: location,
              text: 'location',
            ),
            NormalTextField(
              controller: phone,
              text: 'phone',
            ),
            NormalTextField(
              controller: price,
              text: 'price',
            ),
            NormalTextField(
              line: 5,
              controller: des,
              text: 'description',
            ),
            NormalTextField(
              controller: rating,
              text: 'rating',
            ),
            photos == null
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        for (int i = 0; i < photos!.length; i++)
                          Container(
                              width: 120,
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(photos![i].path),
                                  fit: BoxFit.cover,
                                ),
                              )),
                      ],
                    ),
                  ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: AppColor.primaryColor,
              onPressed: () {
                pickImage();
              },
              child: texts(
                text: "Add Images",
              ),
            )
          ],
        ),
      ),
    );
  }
}
