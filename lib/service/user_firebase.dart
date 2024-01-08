import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futsal_app/model/user_model.dart';

class UserFirebase {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel model) async {
    await firebaseFirestore.collection('user').doc(model.email).set({"name": model.name, "email": model.email, "phone": model.phone});
  }
}
