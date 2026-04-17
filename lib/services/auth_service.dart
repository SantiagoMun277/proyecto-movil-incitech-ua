
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<UserCredential> iniciarSesion({
//     required String correo,
//     required String contrasena,
//   }) async {
//     return await _auth.signInWithEmailAndPassword(
//       email: correo.trim(),
//       password: contrasena.trim(),
//     );
//   }

//   Future<UserCredential> registrarUsuario({
//     required String correo,
//     required String contrasena,
//   }) async {
//     return await _auth.createUserWithEmailAndPassword(
//       email: correo.trim(),
//       password: contrasena.trim(),
//     );
//   }

//   Future<void> cerrarSesion() async {
//     await _auth.signOut();
//   }

//   User? get usuarioActual => _auth.currentUser;

//   String obtenerMensajeError(Object error) {
//     if (error is FirebaseAuthException) {
//       switch (error.code) {
//         case 'invalid-email':
//           return 'El correo no es válido.';
//         case 'email-already-in-use':
//           return 'Ese correo ya está registrado.';
//         case 'weak-password':
//           return 'La contraseña es demasiado débil.';
//         case 'invalid-credential':
//           return 'Correo o contraseña incorrectos.';
//         case 'user-disabled':
//           return 'Esta cuenta fue deshabilitada.';
//         case 'too-many-requests':
//           return 'Demasiados intentos. Intenta más tarde.';
//         case 'network-request-failed':
//           return 'Sin conexión a internet.';
//         default:
//           return error.message ?? 'Ocurrió un error.';
//       }
//     }
//     return 'Ocurrió un error inesperado.';
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena.trim(),
    );
  }

  Future<UserCredential> registrarUsuario({
    required String correo,
    required String contrasena,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena.trim(),
    );
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  Future<void> cambiarContrasena({
    required String contrasenaActual,
    required String nuevaContrasena,
  }) async {
    final usuario = _auth.currentUser;

    if (usuario == null || usuario.email == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No hay usuario autenticado.',
      );
    }

    final credencial = EmailAuthProvider.credential(
      email: usuario.email!,
      password: contrasenaActual.trim(),
    );

    await usuario.reauthenticateWithCredential(credencial);
    await usuario.updatePassword(nuevaContrasena.trim());
  }

  User? get usuarioActual => _auth.currentUser;

  String obtenerMensajeError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'El correo no es válido.';
        case 'email-already-in-use':
          return 'Ese correo ya está registrado.';
        case 'weak-password':
          return 'La contraseña es demasiado débil.';
        case 'invalid-credential':
        case 'wrong-password':
          return 'Correo o contraseña incorrectos.';
        case 'user-disabled':
          return 'Esta cuenta fue deshabilitada.';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta más tarde.';
        case 'network-request-failed':
          return 'Sin conexión a internet.';
        case 'requires-recent-login':
          return 'Debes iniciar sesión de nuevo para cambiar la contraseña.';
        default:
          return error.message ?? 'Ocurrió un error.';
      }
    }
    return 'Ocurrió un error inesperado.';
  }
}