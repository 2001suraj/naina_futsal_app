import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final checkBoxValueProvider = StateProvider<bool>((ref) {
  return false;
});
final isLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

final currentPageIndexProvider = StateProvider<int>((ref) {
  return 0;
});


final searchTextProvider = StateProvider.autoDispose<String>((ref) {
  return '' ;
});
final formattedDateProvider = StateProvider<String>((ref) {
  return DateFormat('MMM dd yyyy').format(DateTime.now());
});
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
