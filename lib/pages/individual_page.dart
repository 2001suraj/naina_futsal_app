import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/const/app_color.dart';
import 'package:futsal_app/const/app_size.dart';
import 'package:futsal_app/model/futsal_model.dart';
import 'package:futsal_app/pages/book_now_page.dart';
import 'package:futsal_app/provider/futsal_provider.dart';
import 'package:futsal_app/widgets/texts.dart';

class IndividualPage extends ConsumerWidget {
  static const String routeName = ' individual page';
  IndividualPage({super.key, required this.model});

  final FutsalModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMore = ref.watch(showMoreProvider);

    final wordCount = RegExp(r'\b\w+\b').allMatches(model.description ?? 'NA').length;
    final displayedText = ref.read(showMoreProvider) ? (model.description ?? 'NA') : (model.description ?? 'NA').split(' ').take(30).join(' ');
    return Scaffold(
      appBar: AppBar(
        title: texts(text: model.name ?? 'NA'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  height: 169,
                  width: double.infinity,
                  image: NetworkImage(model.image ?? 'NA'),
                  fit: BoxFit.cover,
                ),
              ),
              texts(text: model.name ?? 'NA', weight: FontWeight.w700, size: 31, font: 'Urbanist'),
              AppSize.normalheight,
              Padding(
                padding: const EdgeInsets.only(left: 38.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColor.primaryColor,
                    ),
                    AppSize.normalwidth,
                    texts(text: model.location ?? 'NA', weight: FontWeight.w500, size: 14, font: 'Urbanist'),
                  ],
                ),
              ),
              AppSize.minheight,
              Padding(
                padding: const EdgeInsets.only(left: 38.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.phone,
                      color: AppColor.primaryColor,
                    ),
                    AppSize.normalwidth,
                    texts(text: model.phone ?? 'NA', weight: FontWeight.w500, size: 14, font: 'Urbanist'),
                  ],
                ),
              ),
              AppSize.normalheight,
              const Divider(),
              texts(text: 'Description', weight: FontWeight.w600, size: 20, font: 'Urbanist'),
              Text(
                displayedText,
                style: const TextStyle(color: AppColor.greyColor, fontSize: 14, fontWeight: FontWeight.w400),
              ),
              if (wordCount > 50)
                TextButton(
                  onPressed: () {
                    log(ref.read(showMoreProvider).toString());
                    ref.read(showMoreProvider.notifier).state = !showMore;
                  },
                  child: texts(text: showMore ? 'Show Less' : 'Read More', color: AppColor.primaryColor),
                ),
              AppSize.maxheight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  texts(text: 'Gallery Photos', weight: FontWeight.w700, size: 19, font: 'Urbanist'),
                  AppSize.normalwidth,
                  GestureDetector(
                      onTap: () {}, child: texts(text: 'See All', weight: FontWeight.w700, size: 19, font: 'Urbanist', color: AppColor.primaryColor)),
                ],
              ),
              SizedBox(
                height: 107,
                width: double.infinity,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.photo?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(image: NetworkImage(model.photo?[index]), fit: BoxFit.cover),
                          color: AppColor.greyColor,
                        ),
                        width: 135,
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  texts(text: "Rs ${model.price}", size: 18, weight: FontWeight.w700, color: AppColor.primaryColor),
                  texts(
                    text: " /hour",
                    size: 11,
                    weight: FontWeight.w400,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  height: 47,
                  minWidth: 214,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: AppColor.primaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, BookNowPage.routeName, arguments: model);
                  },
                  child: texts(
                    text: "Book Now!",
                    color: AppColor.white,
                    size: 17,
                    weight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
