import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  static final FirebaseApi _instance = FirebaseApi._internal();
  factory FirebaseApi() => _instance;
  FirebaseApi._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create
  Future<void> createDocument(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  // Read
  Future<Map<String, dynamic>?> readDocument(String collection, String documentId) async {
    final docSnapshot = await _firestore.collection(collection).doc(documentId).get();
    return docSnapshot.data();
  }

  // Update
  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  // Delete
  Future<void> deleteDocument(String collection, String documentId) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  // Read all documents in a collection
  Future<Map<String, T>> readAllDocuments<T>(String collection) async {
    final querySnapshot = await _firestore.collection(collection).get();
    return Map.fromEntries(querySnapshot.docs.map((doc) => 
      MapEntry(doc.id, doc.data() as T)));
  }

  Future<void> batchUpdateDocuments<T>(String collection, Map<String, T> data) async {
    final batch = FirebaseFirestore.instance.batch();
    data.forEach((key, value) {
      batch.set(FirebaseFirestore.instance.collection(collection).doc(key), value as Map<String, dynamic>);
    });
    await batch.commit();
  }
}