import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/pages/booking_screen.dart';
import 'package:futsal_app/pages/home_screen.dart';
import 'package:futsal_app/pages/profile_screen.dart';
import 'package:futsal_app/provider/basic_provider.dart';

class BottomNavigationScreen extends ConsumerWidget {
  static const String routeName = ' bottom navigation screen';
  BottomNavigationScreen({super.key});
  final List<Widget> pages = [HomeScreen(), BookingScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentPageIndexProvider);
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(currentPageIndexProvider.notifier).state = index;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Booking'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
