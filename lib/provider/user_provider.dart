import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('user').snapshots();
});