import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Config {
  bool isStaging = true;

  FirebaseFirestore get firestoreEnv => isStaging
      ? FirebaseFirestore.instanceFor(
          app: Firebase.app(), databaseId: "lbstaging")
      : FirebaseFirestore.instance;
}
