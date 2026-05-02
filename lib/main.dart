import 'package:flutter/material.dart';
import 'app/app.dart';
import 'package:firebase_core/firebase_core.dart'; // Importante
import 'firebase_options.dart'; // El archivo que acabas de generar

void main() async {
  // Asegura que Flutter esté listo antes de iniciar Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase para Android, Web, etc.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    
);

print("Firebase conectado con éxito en: ${DefaultFirebaseOptions.currentPlatform.projectId}");

  runApp(const MyApp());
}
