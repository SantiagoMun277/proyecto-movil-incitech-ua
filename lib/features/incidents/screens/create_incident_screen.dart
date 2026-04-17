import 'package:flutter/material.dart';

class CreateIncidentScreen extends StatelessWidget {
  const CreateIncidentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8DEBE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8DEBE),
        elevation: 0,
        title: const Text(
          'Crear incidente',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Times New Roman',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Text(
          'Aquí irá el formulario de crear incidente',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Times New Roman',
          ),
        ),
      ),
    );
  }
}