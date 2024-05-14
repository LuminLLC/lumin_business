// import 'package:flutter/material.dart';

// class TryScreen extends StatefulWidget {
//   @override
//   _TryScreenState createState() => _TryScreenState();
// }

// class _TryScreenState extends State<TryScreen> {
//   bool _isLoading = true;

//   void _showDialog() {
    
//     // Simulating an asynchronous operation

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Progress"),
//           content: StatefulBuilder(
//             builder: ((context, state) {
//               Future.delayed(Duration(seconds: 3)).whenComplete(
//                 () => state(() {
//                   _isLoading = false;
//                 }),
//               );
//               return _isLoading
//                   ? SizedBox(
//                       height: 100,
//                       child: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                   : Text("Operation completed!");
//             }),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//     ;
//   }

//   @override
//   Widget build(BuildContext context) {
//     setState(() {
//       _isLoading = true;
//     });
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("AlertDialog with CircularProgressIndicator"),
//       ),
//       body: Center(
//         child: TextButton(
//           onPressed: _showDialog,
//           child: Text("Show Dialog"),
//         ),
//       ),
//     );
//   }
// }
