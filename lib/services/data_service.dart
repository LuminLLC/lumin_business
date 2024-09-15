import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'firebase_api.dart';

class DataService<T> {
  final String _boxName;
  final String _firebaseCollection;
  final FirebaseApi _firebaseApi = FirebaseApi();
  late Box<T> _box;
  Timer? _backupTimer;

  DataService(this._boxName, this._firebaseCollection);

  Future<void> initialize() async {
    _box = await Hive.openBox<T>(_boxName);
    scheduleBackup();
  }

  Future<void> create(String key, T data) async {
    await _box.put(key, data);
  }

  T? read(String key) {
    return _box.get(key);
  }

  Future<void> update(String key, T data) async {
    await _box.put(key, data);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  Map<String, T> readAll() {
    return Map.fromEntries(_box.toMap().entries.map((entry) => MapEntry<String, T>(entry.key.toString(), entry.value)));
  }

  Future<void> backupToFirestore() async {
    final data = readAll();
    await _firebaseApi.batchUpdateDocuments<T>(_firebaseCollection, data);
    if (kDebugMode) {
      print('Backup completed at ${DateTime.now()}');
    }
  }

  Future<void> restoreFromFirestore() async {
    final data = await _firebaseApi.readAllDocuments<T>(_firebaseCollection);
    await _box.putAll(data);
  }

  void scheduleBackup() {
    // Cancel any existing timer
    _backupTimer?.cancel();
    
    // Schedule a new backup every 6 hours
    _backupTimer = Timer.periodic(Duration(hours: 6), (_) {
      backupToFirestore();
    });
  }

  void dispose() {
    _backupTimer?.cancel();
  }
}