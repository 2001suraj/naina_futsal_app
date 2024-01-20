import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/const/app_color.dart';
import 'package:futsal_app/const/app_size.dart';
import 'package:futsal_app/model/futsal_model.dart';
import 'package:futsal_app/pages/add_futsal_page.dart';
import 'package:futsal_app/pages/individual_page.dart';
import 'package:futsal_app/provider/basic_provider.dart';
import 'package:futsal_app/provider/futsal_provider.dart';
import 'package:futsal_app/service/futsal_firebase.dart';
import 'package:futsal_app/widgets/texts.dart';

class BookingScreen extends ConsumerWidget {
  static const String routeName = 'BookingScreen';
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingData = ref.watch(bookingDataProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSize.largeheight,
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    texts(text: "Bookings", size: 24, weight: FontWeight.w700),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AddFutsalPage.routeName);
                      },
                      child: texts(text: "Add"),
                    )
                  ],
                ),
              ),
              Container(
                color: AppColor.bgColor,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,
                child: bookingData.when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data.docs.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, IndividualPage.routeName,
                                    arguments: FutsalModel(
                                      name: data.docs[index]['name'],
                                      location: data.docs[index]['address'],
                                      price: data.docs[index]['price'],
                                      phone: data.docs[index]['phone'],
                                      description: data.docs[index]['description'],
                                      rating: data.docs[index]['rating'],
                                      image: data.docs[index]['image'],
                                      photo: data.docs[index]['photo'],
                                    ));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: AppColor.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 18.0, right: 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image(
                                            height: 85,
                                            width: 90,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(data.docs[index]['image']),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 10, top: 10),
                                        width: 230,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            texts(
                                              text: data.docs[index]['name'],
                                              size: 14,
                                              weight: FontWeight.w700,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 15,
                                                  color: AppColor.primaryColor,
                                                ),
                                                texts(
                                                  text: data.docs[index]['address'],
                                                  size: 14,
                                                  weight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                            texts(
                                              text: "${data.docs[index]['timeFrom']}am - ${data.docs[index]['timeTo']}am",
                                              size: 14,
                                              weight: FontWeight.w400,
                                            ),
                                            MaterialButton(
                                              height: 21,
                                              minWidth: 70,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              color: data.docs[index]['status'].toString().toLowerCase() == ("Booked".toLowerCase())
                                                  ? AppColor.bgColor
                                                  : AppColor.bgRedColor,
                                              onPressed: () {},
                                              child: texts(
                                                text: data.docs[index]['status'],
                                                weight: FontWeight.w400,
                                                size: 11,
                                                color: data.docs[index]['status'].toString().toLowerCase() == ("Booked".toLowerCase())
                                                    ? AppColor.primaryColor
                                                    : AppColor.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 28.0),
                                      child: Divider(),
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: data.docs[index]['status'].toString().toLowerCase() == ("Booked").toLowerCase()
                                                ? AppColor.primaryColor
                                                : AppColor.red),
                                      ),
                                      onPressed: () {
                                        if (data.docs[index]['status'].toString().toLowerCase() == ("Booked").toLowerCase()) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  surfaceTintColor: AppColor.white,
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      texts(text: "Cancel Booking", color: AppColor.red, size: 22, weight: FontWeight.w700),
                                                      AppSize.normalheight,
                                                      texts(
                                                          text: "Are you sure you want to cancel your booking?",
                                                          size: 14,
                                                          weight: FontWeight.w500,
                                                          align: TextAlign.center),
                                                      AppSize.maxheight,
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          MaterialButton(
                                                            height: 42,
                                                            minWidth: 120,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                            color: AppColor.bgColor,
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: texts(text: "Cancel", color: AppColor.primaryColor, size: 13),
                                                          ),
                                                          AppSize.normalwidth,
                                                          MaterialButton(
                                                            height: 42,
                                                            minWidth: 120,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                            color: AppColor.primaryColor,
                                                            onPressed: () {
                                                              FutsalFirebase().updateFutsal(
                                                                  FutsalModel(
                                                                    name: data.docs[index]['name'],
                                                                    image: data.docs[index]['image'],
                                                                    price: data.docs[index]['price'],
                                                                    location: data.docs[index]['address'],
                                                                    rating: data.docs[index]['rating'],
                                                                    description: data.docs[index]['description'],
                                                                    photo: data.docs[index]['photo'],
                                                                    phone: data.docs[index]['phone'],
                                                                    day: data.docs[index]['day'],
                                                                    court: data.docs[index]['court'],
                                                                    status: 'Cancel',
                                                                    timeFrom: data.docs[index]['timeFrom'],
                                                                    timeTo: data.docs[index]['timeTo'],
                                                                  ),
                                                                  data.docs[index].id);
                                                              Navigator.pop(context);
                                                              ref.read(currentPageIndexProvider.notifier).state == 0;
                                                            },
                                                            child: texts(text: "Yes, Continue", color: AppColor.white, size: 13),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });
                                        }
                                        if (data.docs[index]['status'].toString().toLowerCase() == ("Cancel").toLowerCase()) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  surfaceTintColor: AppColor.white,
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      texts(text: "Delete Booking", color: AppColor.red, size: 22, weight: FontWeight.w700),
                                                      AppSize.normalheight,
                                                      texts(
                                                          text: "Are you sure you want to Delete your booking?",
                                                          size: 14,
                                                          weight: FontWeight.w500,
                                                          align: TextAlign.center),
                                                      AppSize.maxheight,
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          MaterialButton(
                                                            height: 42,
                                                            minWidth: 120,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                            color: AppColor.bgColor,
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: texts(text: "Cancel", color: AppColor.primaryColor, size: 13),
                                                          ),
                                                          AppSize.normalwidth,
                                                          MaterialButton(
                                                            height: 42,
                                                            minWidth: 120,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                            color: AppColor.primaryColor,
                                                            onPressed: () {
                                                              FutsalFirebase().delete(data.docs[index].id);
                                                              Navigator.pop(context);
                                                              ref.read(currentPageIndexProvider.notifier).state == 0;
                                                            },
                                                            child: texts(text: "Yes, Continue", color: AppColor.white, size: 13),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });
                                        }
                                      },
                                      child: texts(
                                        text: data.docs[index]['status'].toString().toLowerCase() == ("Booked".toLowerCase())
                                            ? "Cancel Booking"
                                            : "Canceled",
                                        weight: FontWeight.w600,
                                        size: 15,
                                        color: data.docs[index]['status'].toString().toLowerCase() == ("Booked".toLowerCase())
                                            ? AppColor.primaryColor
                                            : AppColor.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    error: (e, r) => Text(e.toString()),
                    loading: () => const Center(child: CircularProgressIndicator())),
              )
            ],
          ),
        ),
      ),
    );
  }
}
