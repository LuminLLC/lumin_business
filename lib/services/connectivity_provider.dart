// import 'dart:async'; 

// class ConnectivityProvider  {
//   final Connectivity _connectivity = Connectivity();
//   final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

//   Stream<bool> get connectionStatus => _connectionStatusController.stream;

//   ConnectivityProvider() {
//     _initConnectivity();
//     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   Future<void> _initConnectivity() async {
//     final result = await _connectivity.checkConnectivity();
//     _updateConnectionStatus(result);
//   }

//   void _updateConnectionStatus(List<ConnectivityResult> results) {
//     _connectionStatusController.add(results.any((result) => result != ConnectivityResult.none));
//   }

//   void dispose() {
//     _connectionStatusController.close();
//   }
// }
