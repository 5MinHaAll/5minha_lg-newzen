// // database/firebase_service.dart
// import 'package:firebase_database/firebase_database.dart';
//
// class FirebaseService {
//   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('random_data');
//
//   Future<void> storeData(Map<String, dynamic> data) async {
//     try {
//       await _dbRef.push().set(data);
//       print("Data added: $data");
//     } catch (e) {
//       print("Error adding data: $e");
//     }
//   }
// }
