

// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> guardarUsuario({
//     required String uid,
//     required String nombreCompleto,
//     required String correo,
//   }) async {
//     await _firestore.collection('users').doc(uid).set({
//       'uid': uid,
//       'nombreCompleto': nombreCompleto.trim(),
//       'correo': correo.trim(),
//       'genero': 'No responde',
//       'programa': '',
//       'rol': 'usuario',
//       'estado': 'activo',
//       'fotoUrl': '',
//       'creadoEn': FieldValue.serverTimestamp(),
//       'actualizadoEn': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<Map<String, dynamic>?> obtenerUsuario(String uid) async {
//     final doc = await _firestore.collection('users').doc(uid).get();
//     return doc.data();
//   }

//   Future<void> actualizarPerfil({
//     required String uid,
//     required String nombreCompleto,
//     required String genero,
//     required String programa,
//   }) async {
//     await _firestore.collection('users').doc(uid).update({
//       'nombreCompleto': nombreCompleto.trim(),
//       'genero': genero,
//       'programa': programa,
//       'actualizadoEn': FieldValue.serverTimestamp(),
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarUsuario({
    required String uid,
    required String nombreCompleto,
    required String correo,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'nombreCompleto': nombreCompleto.trim(),
      'correo': correo.trim(),
      'genero': 'No responde',
      'programa': '',
      'rol': 'usuario',
      'estado': 'activo',
      'fotoUrl': '',
      'creadoEn': FieldValue.serverTimestamp(),
      'actualizadoEn': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> obtenerUsuario(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> actualizarPerfil({
    required String uid,
    required String nombreCompleto,
    required String correo,
    required String genero,
    required String programa,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'nombreCompleto': nombreCompleto.trim(),
      'correo': correo.trim(),
      'genero': genero,
      'programa': programa,
      'rol': 'usuario',
      'estado': 'activo',
      'fotoUrl': '',
      'actualizadoEn': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}