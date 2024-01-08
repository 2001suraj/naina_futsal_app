import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final showMoreProvider = StateProvider<bool>((ref) {
  return false;
});

final futsalDataProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('futsal').snapshots();
});
final bookingDataProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('booking').snapshots();
});
