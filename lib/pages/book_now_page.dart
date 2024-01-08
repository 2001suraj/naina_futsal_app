import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/const/app_color.dart';
import 'package:futsal_app/const/app_size.dart';
import 'package:futsal_app/model/futsal_model.dart';
import 'package:futsal_app/pages/bottom_navigation_screen.dart';
import 'package:futsal_app/provider/basic_provider.dart';
import 'package:futsal_app/service/futsal_firebase.dart';
import 'package:futsal_app/widgets/texts.dart';
import 'package:intl/intl.dart';

class BookNowPage extends ConsumerStatefulWidget {
  static const String routeName = 'book now page';

  BookNowPage({super.key, required this.model});

  final FutsalModel model;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookNowPageState();
}

TimeOfDay? fromDate;
TimeOfDay? toDate;

class _BookNowPageState extends ConsumerState<BookNowPage> {
  int selectedCardIndex = 0;

  void _onCardTapped(int index) {
    setState(() {
      selectedCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    String formattedDate = ref.watch(formattedDateProvider);

    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        title: texts(text: "Booking"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  texts(text: "Choose Day", size: 17, weight: FontWeight.w700, font: "Urbanist"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      texts(text: formattedDate, size: 15, weight: FontWeight.w600, font: "Urbanist"),
                      IconButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2025),
                            );
                            if (picked != null && picked != selectedDate) {
                              ref.read(selectedDateProvider.notifier).state == picked;
                              ref.read(formattedDateProvider.notifier).state = DateFormat('MMM dd yyyy').format(picked);
                            }
                            log(selectedDate.toString());
                          },
                          icon: const Icon(Icons.calendar_month)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        texts(text: "From", size: 17, weight: FontWeight.w700),
                        AppSize.minheight,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColor.shadowColor,
                          ),
                          width: 120,
                          alignment: Alignment.center,
                          child: DropdownButton<TimeOfDay>(
                            value: fromDate,
                            onChanged: (TimeOfDay? newValue) {
                              setState(() {
                                fromDate = newValue;
                              });
                            },
                            items: List.generate(
                              15,
                              (index) {
                                final hour = index + 6;
                                return DropdownMenuItem<TimeOfDay>(
                                  value: TimeOfDay(hour: hour, minute: 0),
                                  child: texts(text: '${hour % 12 == 0 ? 12 : hour % 12} ${hour < 12 ? 'AM' : 'PM'}'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        texts(text: "To", size: 17, weight: FontWeight.w700),
                        AppSize.minheight,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColor.shadowColor,
                          ),
                          width: 120,
                          alignment: Alignment.center,
                          child: DropdownButton<TimeOfDay>(
                            value: toDate,
                            onChanged: (TimeOfDay? newValue) {
                              setState(() {
                                toDate = newValue;
                              });
                            },
                            items: List.generate(
                              15,
                              (index) {
                                final hour = index + 6;
                                return DropdownMenuItem<TimeOfDay>(
                                  value: TimeOfDay(hour: hour, minute: 0),
                                  child: texts(text: '${hour % 12 == 0 ? 12 : hour % 12} ${hour < 12 ? 'AM' : 'PM'}'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 185,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.white,
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCard(0, 'Court 1'),
                      buildCard(1, 'Court 2'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCard(2, 'Court 3'),
                      buildCard(3, 'Court 4'),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          height: 150,
          color: AppColor.white,
          child: Align(
            alignment: Alignment.center,
            child: MaterialButton(
              height: 53,
              minWidth: 328,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: AppColor.primaryColor,
              onPressed: () {
                FutsalFirebase().bookFutsal(
                  FutsalModel(
                    name: widget.model.name,
                    image: widget.model.image,
                    price: widget.model.price,
                    location: widget.model.location,
                    rating: widget.model.rating,
                    description: widget.model.description,
                    photo: widget.model.photo,
                    phone: widget.model.phone,
                    day: formattedDate,
                    court: 'Court ${selectedCardIndex + 1}',
                    status: 'Booked',
                    timeFrom: fromDate?.hour.toString() ?? '1 Am',
                    timeTo: toDate?.hour.toString() ?? '2 Am',
                  ),
                );

                ref.read(currentPageIndexProvider.notifier).state = 1;
                Navigator.pushReplacementNamed(context, BottomNavigationScreen.routeName);
              },
              child: texts(
                text: "Book Now!",
                color: AppColor.white,
                size: 17,
                weight: FontWeight.w600,
              ),
            ),
          )),
    );
  }

  Widget buildCard(int index, String cardTitle) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 132,
        height: 38,
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            cardTitle,
            style: TextStyle(
              color: selectedCardIndex == index ? Colors.green : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
