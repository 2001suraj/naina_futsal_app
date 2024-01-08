import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/const/app_color.dart';
import 'package:futsal_app/const/app_size.dart';
import 'package:futsal_app/model/futsal_model.dart';
import 'package:futsal_app/pages/individual_page.dart';
import 'package:futsal_app/provider/basic_provider.dart';
import 'package:futsal_app/provider/futsal_provider.dart';
import 'package:futsal_app/widgets/texts.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var futsalData = ref.watch(futsalDataProvider);
    final search = ref.watch(searchTextProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  onChanged: (value) {
                    ref.read(searchTextProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: MaterialButton(
                      onPressed: () {},
                      child: const Image(image: AssetImage('assets/images/setting.png')),
                    ),
                    hintText: 'Search',
                    fillColor: AppColor.textFieldColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: AppColor.primaryColor,
                  onPressed: () {},
                  child: texts(text: "All Futsal", color: AppColor.white, weight: FontWeight.w600, size: 15),
                ),
              ),
              AppSize.normalheight,
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 10),
                child: texts(text: "Near you", weight: FontWeight.w600, size: 17),
              ),
              Container(
                  color: AppColor.bgColor,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: futsalData.when(
                      data: (data) {
                        List filteredDocs = data.docs.where((doc) => doc['name'].toString().toLowerCase().contains(search.toLowerCase())).toList();
                        return ListView.builder(
                            itemCount: filteredDocs.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, IndividualPage.routeName,
                                      arguments: FutsalModel(
                                        name: filteredDocs[index]['name'],
                                        location: filteredDocs[index]['address'],
                                        price: filteredDocs[index]['price'],
                                        phone: filteredDocs[index]['phone'],
                                        description: filteredDocs[index]['description'],
                                        rating: filteredDocs[index]['rating'],
                                        image: filteredDocs[index]['image'],
                                        photo: filteredDocs[index]['photo'],
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
                                  child: Row(children: [
                                    Image(
                                      height: 90,
                                      width: 100,
                                      image: NetworkImage(filteredDocs[index]['image']),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      width: 120,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(width: 100, child: texts(text: filteredDocs[index]['name'])),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: AppColor.primaryColor,
                                              ),
                                              SizedBox(width: 70, child: texts(text: filteredDocs[index]['address'])),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: AppColor.yellow,
                                              ),
                                              texts(text: filteredDocs[index]['rating']),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              texts(
                                                  text: "Rs ${filteredDocs[index]['price']}",
                                                  size: 18,
                                                  weight: FontWeight.w700,
                                                  color: AppColor.primaryColor),
                                              texts(
                                                text: " /hrs",
                                                size: 11,
                                                weight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            size: 25,
                                            color: AppColor.primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                            });
                      },
                      error: (e, r) => Text(e.toString()),
                      loading: () => Center(
                            child: CircularProgressIndicator(),
                          )))
            ],
          ),
        ),
      ),
    );
  }
}
