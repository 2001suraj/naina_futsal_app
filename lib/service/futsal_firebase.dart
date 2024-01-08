import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futsal_app/model/futsal_model.dart';

class FutsalFirebase {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addFutsal(FutsalModel model) async {
    await firebaseFirestore.collection('futsal').doc(model.name).set(
      {
        "name": model.name,
        "image": '',
        "address": model.location,
        "phone": model.phone,
        "rating": model.rating,
        "price": model.price,
        "description": model.description,
        "photo": [],
      },
    );
  }

  Future<void> bookFutsal(FutsalModel model) async {
    await firebaseFirestore.collection('booking').doc().set(
      {
        "name": model.name,
        "image": model.image,
        "address": model.location,
        "phone": model.phone,
        "rating": model.rating,
        "price": model.price,
        "description": model.description,
        "court": model.court,
        "status": model.status,
        "timeFrom": model.timeFrom,
        "timeTo": model.timeTo,
        "photo": model.photo,
        "day": model.day,
      },
    );
  }
  Future<void> updateFutsal(FutsalModel model, String id) async {
    await firebaseFirestore.collection('booking').doc(id).update(
      {
        "name": model.name,
        "image": model.image,
        "address": model.location,
        "phone": model.phone,
        "rating": model.rating,
        "price": model.price,
        "description": model.description,
        "court": model.court,
        "status": model.status,
        "timeFrom": model.timeFrom,
        "timeTo": model.timeTo,
        "photo": model.photo,
        "day": model.day,
      },
    );
  }
}
