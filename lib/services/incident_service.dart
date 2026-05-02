

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';

// class IncidentService {
//   IncidentService({
//     FirebaseFirestore? firestore,
//     FirebaseStorage? storage,
//   })  : _firestore = firestore ?? FirebaseFirestore.instance,
//         _storage = storage ?? FirebaseStorage.instance;

//   final FirebaseFirestore _firestore;
//   final FirebaseStorage _storage;

//   CollectionReference<Map<String, dynamic>> get _collection {
//     return _firestore.collection('incidentes');
//   }

//   Stream<List<IncidentItem>> streamIncidents() {
//     return _collection
//         .orderBy('fechaCreacion', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map(IncidentItem.fromFirestore).toList();
//     });
//   }

//   Stream<List<IncidentItem>> streamMyIncidents(String uid) {
//     final controller = StreamController<List<IncidentItem>>();
//     final usuarioItems = <String, IncidentItem>{};
//     final autorItems = <String, IncidentItem>{};
//     bool hasEmitted = false;

//     void emitMerged() {
//       final merged = {...usuarioItems, ...autorItems}.values.toList();

//       merged.sort((a, b) {
//         final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
//         final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
//         return bDate.compareTo(aDate);
//       });

//       controller.add(merged);
//       hasEmitted = true;
//     }

//     final streamUsuario = _collection
//         .where('uidUsuario', isEqualTo: uid)
//         .orderBy('fechaCreacion', descending: true)
//         .snapshots();

//     final streamAutor = _collection
//         .where('uidAutor', isEqualTo: uid)
//         .orderBy('fechaCreacion', descending: true)
//         .snapshots();

//     late final StreamSubscription usuarioSub;
//     late final StreamSubscription autorSub;

//     controller.onListen = () {
//       debugPrint('streamMyIncidents: iniciando escucha para uid: $uid');

//       usuarioSub = streamUsuario.listen(
//         (snapshot) {
//           debugPrint(
//             'streamMyIncidents: snapshot usuario recibido, docs: ${snapshot.docs.length}',
//           );

//           usuarioItems
//             ..clear()
//             ..addEntries(
//               snapshot.docs.map(
//                 (doc) => MapEntry(doc.id, IncidentItem.fromFirestore(doc)),
//               ),
//             );

//           emitMerged();
//         },
//         onError: (error) {
//           debugPrint('streamMyIncidents: error en streamUsuario: $error');

//           if (!hasEmitted) {
//             controller.add([]);
//             hasEmitted = true;
//           }
//         },
//       );

//       autorSub = streamAutor.listen(
//         (snapshot) {
//           debugPrint(
//             'streamMyIncidents: snapshot autor recibido, docs: ${snapshot.docs.length}',
//           );

//           autorItems
//             ..clear()
//             ..addEntries(
//               snapshot.docs.map(
//                 (doc) => MapEntry(doc.id, IncidentItem.fromFirestore(doc)),
//               ),
//             );

//           emitMerged();
//         },
//         onError: (error) {
//           debugPrint('streamMyIncidents: error en streamAutor: $error');

//           if (!hasEmitted) {
//             controller.add([]);
//             hasEmitted = true;
//           }
//         },
//       );

//       Future.delayed(const Duration(seconds: 5), () {
//         if (!hasEmitted && !controller.isClosed) {
//           debugPrint('streamMyIncidents: timeout - emitiendo lista vacía');
//           controller.add([]);
//           hasEmitted = true;
//         }
//       });
//     };

//     controller.onCancel = () async {
//       debugPrint('streamMyIncidents: cancelando escuchas para uid: $uid');
//       await usuarioSub.cancel();
//       await autorSub.cancel();
//       await controller.close();
//     };

//     return controller.stream;
//   }

//   Future<void> createIncident({
//     required String uid,
//     required String title,
//     required String type,
//     required String campus,
//     required String locationText,
//     required String description,
//     required bool gpsRegistered,
//     required double? gpsLatitude,
//     required double? gpsLongitude,
//     required XFile? imageFile,
//   }) async {
//     if (imageFile == null) {
//       throw Exception('La fotografía del incidente es obligatoria.');
//     }

//     final imageData = await _uploadIncidentImage(
//       uid: uid,
//       imageFile: imageFile,
//     );

//     final now = FieldValue.serverTimestamp();

//     final data = <String, dynamic>{
//       'uidUsuario': uid,
//       'uidAutor': uid,
//       'titulo': title.trim(),
//       'title': title.trim(),
//       'descripcion': description.trim(),
//       'description': description.trim(),
//       'tipo': type.trim(),
//       'type': type.trim(),
//       'sede': campus.trim(),
//       'campus': campus.trim(),
//       'estado': 'reportado',
//       'status': 'reportado',
//       'fechaCreacion': now,
//       'createdAt': now,
//       'fechaTexto': _formatDateTime(DateTime.now()),
//       'fechaCreacionIso': DateTime.now().toIso8601String(),
//       'imageUrl': imageData.downloadUrl,
//       'imagenUrl': imageData.downloadUrl,
//       'storagePath': imageData.storagePath,
//       'imagenStoragePath': imageData.storagePath,
//       'imagenNombre': imageData.fileName,
//     };

//     final cleanLocationText = locationText.trim();

//     if (cleanLocationText.isNotEmpty) {
//       data['ubicacionTexto'] = cleanLocationText;
//       data['ubicacionTextual'] = cleanLocationText;
//       data['locationText'] = cleanLocationText;
//       data['ubicacion'] = cleanLocationText;
//       data['location'] = cleanLocationText;
//     } else {
//       data['ubicacion'] = campus.trim();
//       data['location'] = campus.trim();
//     }

//     if (gpsRegistered && gpsLatitude != null && gpsLongitude != null) {
//       data['gpsRegistrado'] = true;
//       data['gpsRegistrada'] = true;
//       data['gpsRegistered'] = true;
//       data['latitud'] = gpsLatitude;
//       data['longitud'] = gpsLongitude;
//       data['gpsLatitude'] = gpsLatitude;
//       data['gpsLongitude'] = gpsLongitude;
//       data['gpsLatitud'] = gpsLatitude;
//       data['gpsLongitud'] = gpsLongitude;
//       data['gps'] = GeoPoint(gpsLatitude, gpsLongitude);
//     } else {
//       data['gpsRegistrado'] = false;
//       data['gpsRegistrada'] = false;
//       data['gpsRegistered'] = false;
//     }

//     await _collection.add(data);
//   }

//   Future<_UploadedIncidentImage> _uploadIncidentImage({
//     required String uid,
//     required XFile imageFile,
//   }) async {
//     final bytes = await imageFile.readAsBytes();

//     if (bytes.isEmpty) {
//       throw Exception('La imagen está vacía o no se pudo leer.');
//     }

//     final extension = _getFileExtension(imageFile.path);
//     final fileName = 'inc_${DateTime.now().millisecondsSinceEpoch}$extension';

//     final ref = _storage.ref().child('incidentes').child(uid).child(fileName);

//     final metadata = SettableMetadata(
//       contentType: _getContentType(extension),
//     );

//     await ref.putData(bytes, metadata);

//     return _UploadedIncidentImage(
//       downloadUrl: await ref.getDownloadURL(),
//       storagePath: ref.fullPath,
//       fileName: fileName,
//     );
//   }

//   String _getFileExtension(String path) {
//     final cleanPath = path.toLowerCase().trim();

//     if (cleanPath.endsWith('.png')) return '.png';
//     if (cleanPath.endsWith('.webp')) return '.webp';
//     if (cleanPath.endsWith('.jpeg')) return '.jpeg';
//     if (cleanPath.endsWith('.jpg')) return '.jpg';

//     return '.jpg';
//   }

//   String _getContentType(String extension) {
//     switch (extension.toLowerCase()) {
//       case '.png':
//         return 'image/png';
//       case '.webp':
//         return 'image/webp';
//       case '.jpeg':
//       case '.jpg':
//       default:
//         return 'image/jpeg';
//     }
//   }

//   String _formatDateTime(DateTime date) {
//     String twoDigits(int value) => value.toString().padLeft(2, '0');

//     return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} - ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
//   }

//   Future<void> updateIncidentStatus({
//     required String incidentId,
//     required String estado,
//   }) async {
//     await _collection.doc(incidentId).update({
//       'estado': estado,
//       'status': estado,
//       'fechaActualizacion': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> updateIncident({
//     required String incidentId,
//     String? title,
//     String? description,
//     String? type,
//     String? campus,
//     String? locationText,
//     bool? gpsRegistered,
//     double? gpsLatitude,
//     double? gpsLongitude,
//     XFile? imageFile,
//   }) async {
//     final data = <String, dynamic>{};

//     final docRef = _collection.doc(incidentId);
//     final docSnapshot = await docRef.get();

//     if (!docSnapshot.exists) {
//       throw Exception('El incidente no existe o ya fue eliminado.');
//     }

//     final currentData = docSnapshot.data() ?? {};
//     final uidAutor = _readUidOwner(currentData);

//     String? oldStoragePath;

//     if (title != null) {
//       data['titulo'] = title.trim();
//       data['title'] = title.trim();
//     }

//     if (description != null) {
//       data['descripcion'] = description.trim();
//       data['description'] = description.trim();
//     }

//     if (type != null) {
//       data['tipo'] = type.trim();
//       data['type'] = type.trim();
//     }

//     if (campus != null) {
//       data['sede'] = campus.trim();
//       data['campus'] = campus.trim();
//     }

//     if (locationText != null) {
//       final cleanLocationText = locationText.trim();

//       if (cleanLocationText.isNotEmpty) {
//         data['ubicacionTexto'] = cleanLocationText;
//         data['ubicacionTextual'] = cleanLocationText;
//         data['locationText'] = cleanLocationText;
//         data['ubicacion'] = cleanLocationText;
//         data['location'] = cleanLocationText;
//       } else if (campus != null) {
//         data['ubicacion'] = campus.trim();
//         data['location'] = campus.trim();
//       }
//     }

//     if (gpsRegistered != null) {
//       data['gpsRegistrado'] = gpsRegistered;
//       data['gpsRegistrada'] = gpsRegistered;
//       data['gpsRegistered'] = gpsRegistered;

//       if (gpsRegistered && gpsLatitude != null && gpsLongitude != null) {
//         data['latitud'] = gpsLatitude;
//         data['longitud'] = gpsLongitude;
//         data['gpsLatitude'] = gpsLatitude;
//         data['gpsLongitude'] = gpsLongitude;
//         data['gpsLatitud'] = gpsLatitude;
//         data['gpsLongitud'] = gpsLongitude;
//         data['gps'] = GeoPoint(gpsLatitude, gpsLongitude);
//       }
//     }

//     if (imageFile != null) {
//       if (uidAutor == null || uidAutor.trim().isEmpty) {
//         throw Exception(
//           'No se pudo actualizar la imagen porque el incidente no tiene uidAutor o uidUsuario.',
//         );
//       }

//       oldStoragePath = _readCurrentImageStoragePath(currentData);

//       final imageData = await _uploadIncidentImage(
//         uid: uidAutor,
//         imageFile: imageFile,
//       );

//       data['imageUrl'] = imageData.downloadUrl;
//       data['imagenUrl'] = imageData.downloadUrl;
//       data['storagePath'] = imageData.storagePath;
//       data['imagenStoragePath'] = imageData.storagePath;
//       data['imagenNombre'] = imageData.fileName;
//     }

//     if (data.isNotEmpty) {
//       data['fechaActualizacion'] = FieldValue.serverTimestamp();

//       await docRef.update(data);

//       if (imageFile != null && oldStoragePath != null) {
//         final newStoragePath = data['storagePath']?.toString();

//         await _deletePreviousIncidentImage(
//           oldPath: oldStoragePath,
//           newPath: newStoragePath,
//         );
//       }
//     }
//   }

//   String? _readUidOwner(Map<String, dynamic> data) {
//     final value = data['uidAutor'] ??
//         data['uidUsuario'] ??
//         data['usuarioId'] ??
//         data['userId'] ??
//         data['uid'];

//     final text = value?.toString().trim();

//     if (text == null || text.isEmpty || text == 'null') {
//       return null;
//     }

//     return text;
//   }

//   String? _readCurrentImageStoragePath(Map<String, dynamic> data) {
//     final value = data['imagenStoragePath'] ??
//         data['storagePath'] ??
//         data['gsUrl'] ??
//         data['storageUrl'] ??
//         data['imageUrl'] ??
//         data['imagenUrl'];

//     final text = value?.toString().trim();

//     if (text == null || text.isEmpty || text == 'null') {
//       return null;
//     }

//     return text;
//   }

//   Future<void> _deletePreviousIncidentImage({
//     required String oldPath,
//     required String? newPath,
//   }) async {
//     final oldValue = oldPath.trim();
//     final newValue = newPath?.trim();

//     if (oldValue.isEmpty) return;

//     if (newValue != null && newValue.isNotEmpty && oldValue == newValue) {
//       return;
//     }

//     if (oldValue.startsWith('assets/') ||
//         oldValue.startsWith('file://') ||
//         oldValue.startsWith('/')) {
//       return;
//     }

//     try {
//       final Reference oldRef;

//       if (oldValue.startsWith('gs://') ||
//           oldValue.startsWith('http://') ||
//           oldValue.startsWith('https://')) {
//         oldRef = _storage.refFromURL(oldValue);
//       } else {
//         oldRef = _storage.ref(oldValue);
//       }

//       final oldFullPath = oldRef.fullPath.trim();

//       if (newValue != null &&
//           newValue.isNotEmpty &&
//           oldFullPath == newValue) {
//         return;
//       }

//       debugPrint('Eliminando imagen anterior de Storage: $oldFullPath');

//       await oldRef.delete();

//       debugPrint('Imagen anterior eliminada correctamente.');
//     } on FirebaseException catch (error) {
//       if (error.code == 'object-not-found') {
//         debugPrint('La imagen anterior ya no existe en Storage.');
//         return;
//       }

//       debugPrint(
//         'La imagen nueva se guardó, pero no se pudo eliminar la imagen anterior: ${error.code} - ${error.message}',
//       );
//     } catch (error) {
//       debugPrint(
//         'La imagen nueva se guardó, pero ocurrió un error eliminando la anterior: $error',
//       );
//     }
//   }
// }

// class _UploadedIncidentImage {
//   _UploadedIncidentImage({
//     required this.downloadUrl,
//     required this.storagePath,
//     required this.fileName,
//   });

//   final String downloadUrl;
//   final String storagePath;
//   final String fileName;
// }


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';

class IncidentService {
  IncidentService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore.collection('incidentes');
  }

  Stream<List<IncidentItem>> streamIncidents() {
    return _collection
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(IncidentItem.fromFirestore).toList();
    });
  }

  Stream<IncidentItem?> streamIncidentById(String incidentId) {
    return _collection.doc(incidentId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return IncidentItem.fromFirestore(doc);
    });
  }

  Stream<List<IncidentItem>> streamMyIncidents(String uid) {
    final controller = StreamController<List<IncidentItem>>();
    final usuarioItems = <String, IncidentItem>{};
    final autorItems = <String, IncidentItem>{};
    bool hasEmitted = false;

    void emitMerged() {
      final merged = {...usuarioItems, ...autorItems}.values.toList();

      merged.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      controller.add(merged);
      hasEmitted = true;
    }

    final streamUsuario = _collection
        .where('uidUsuario', isEqualTo: uid)
        .orderBy('fechaCreacion', descending: true)
        .snapshots();

    final streamAutor = _collection
        .where('uidAutor', isEqualTo: uid)
        .orderBy('fechaCreacion', descending: true)
        .snapshots();

    late final StreamSubscription usuarioSub;
    late final StreamSubscription autorSub;

    controller.onListen = () {
      debugPrint('streamMyIncidents: iniciando escucha para uid: $uid');

      usuarioSub = streamUsuario.listen(
        (snapshot) {
          debugPrint(
            'streamMyIncidents: snapshot usuario recibido, docs: ${snapshot.docs.length}',
          );

          usuarioItems
            ..clear()
            ..addEntries(
              snapshot.docs.map(
                (doc) => MapEntry(doc.id, IncidentItem.fromFirestore(doc)),
              ),
            );

          emitMerged();
        },
        onError: (error) {
          debugPrint('streamMyIncidents: error en streamUsuario: $error');

          if (!hasEmitted) {
            controller.add([]);
            hasEmitted = true;
          }
        },
      );

      autorSub = streamAutor.listen(
        (snapshot) {
          debugPrint(
            'streamMyIncidents: snapshot autor recibido, docs: ${snapshot.docs.length}',
          );

          autorItems
            ..clear()
            ..addEntries(
              snapshot.docs.map(
                (doc) => MapEntry(doc.id, IncidentItem.fromFirestore(doc)),
              ),
            );

          emitMerged();
        },
        onError: (error) {
          debugPrint('streamMyIncidents: error en streamAutor: $error');

          if (!hasEmitted) {
            controller.add([]);
            hasEmitted = true;
          }
        },
      );

      Future.delayed(const Duration(seconds: 5), () {
        if (!hasEmitted && !controller.isClosed) {
          debugPrint('streamMyIncidents: timeout - emitiendo lista vacía');
          controller.add([]);
          hasEmitted = true;
        }
      });
    };

    controller.onCancel = () async {
      debugPrint('streamMyIncidents: cancelando escuchas para uid: $uid');
      await usuarioSub.cancel();
      await autorSub.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  Future<void> createIncident({
    required String uid,
    required String title,
    required String type,
    required String campus,
    required String locationText,
    required String description,
    required bool gpsRegistered,
    required double? gpsLatitude,
    required double? gpsLongitude,
    required XFile? imageFile,
  }) async {
    if (imageFile == null) {
      throw Exception('La fotografía del incidente es obligatoria.');
    }

    final imageData = await _uploadIncidentImage(
      uid: uid,
      imageFile: imageFile,
    );

    final now = FieldValue.serverTimestamp();

    final data = <String, dynamic>{
      'uidUsuario': uid,
      'uidAutor': uid,
      'titulo': title.trim(),
      'title': title.trim(),
      'descripcion': description.trim(),
      'description': description.trim(),
      'tipo': type.trim(),
      'type': type.trim(),
      'sede': campus.trim(),
      'campus': campus.trim(),
      'estado': 'reportado',
      'status': 'reportado',
      'fechaCreacion': now,
      'createdAt': now,
      'fechaTexto': _formatDateTime(DateTime.now()),
      'fechaCreacionIso': DateTime.now().toIso8601String(),
      'imageUrl': imageData.downloadUrl,
      'imagenUrl': imageData.downloadUrl,
      'storagePath': imageData.storagePath,
      'imagenStoragePath': imageData.storagePath,
      'imagenNombre': imageData.fileName,
    };

    final cleanLocationText = locationText.trim();

    if (cleanLocationText.isNotEmpty) {
      data['ubicacionTexto'] = cleanLocationText;
      data['ubicacionTextual'] = cleanLocationText;
      data['locationText'] = cleanLocationText;
      data['ubicacion'] = cleanLocationText;
      data['location'] = cleanLocationText;
    } else {
      data['ubicacion'] = campus.trim();
      data['location'] = campus.trim();
    }

    if (gpsRegistered && gpsLatitude != null && gpsLongitude != null) {
      data['gpsRegistrado'] = true;
      data['gpsRegistrada'] = true;
      data['gpsRegistered'] = true;
      data['latitud'] = gpsLatitude;
      data['longitud'] = gpsLongitude;
      data['gpsLatitude'] = gpsLatitude;
      data['gpsLongitude'] = gpsLongitude;
      data['gpsLatitud'] = gpsLatitude;
      data['gpsLongitud'] = gpsLongitude;
      data['gps'] = GeoPoint(gpsLatitude, gpsLongitude);
    } else {
      data['gpsRegistrado'] = false;
      data['gpsRegistrada'] = false;
      data['gpsRegistered'] = false;
    }

    await _collection.add(data);
  }

  Future<_UploadedIncidentImage> _uploadIncidentImage({
    required String uid,
    required XFile imageFile,
  }) async {
    final bytes = await imageFile.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('La imagen está vacía o no se pudo leer.');
    }

    final extension = _getFileExtension(imageFile.path);
    final fileName = 'inc_${DateTime.now().millisecondsSinceEpoch}$extension';

    final ref = _storage.ref().child('incidentes').child(uid).child(fileName);

    final metadata = SettableMetadata(
      contentType: _getContentType(extension),
    );

    await ref.putData(bytes, metadata);

    return _UploadedIncidentImage(
      downloadUrl: await ref.getDownloadURL(),
      storagePath: ref.fullPath,
      fileName: fileName,
    );
  }

  String _getFileExtension(String path) {
    final cleanPath = path.toLowerCase().trim();

    if (cleanPath.endsWith('.png')) return '.png';
    if (cleanPath.endsWith('.webp')) return '.webp';
    if (cleanPath.endsWith('.jpeg')) return '.jpeg';
    if (cleanPath.endsWith('.jpg')) return '.jpg';

    return '.jpg';
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.jpeg':
      case '.jpg':
      default:
        return 'image/jpeg';
    }
  }

  String _formatDateTime(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} - ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  Future<void> updateIncidentStatus({
    required String incidentId,
    required String estado,
  }) async {
    await _collection.doc(incidentId).update({
      'estado': estado,
      'status': estado,
      'fechaActualizacion': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateIncident({
    required String incidentId,
    String? title,
    String? description,
    String? type,
    String? campus,
    String? locationText,
    bool? gpsRegistered,
    double? gpsLatitude,
    double? gpsLongitude,
    XFile? imageFile,
  }) async {
    final data = <String, dynamic>{};

    final docRef = _collection.doc(incidentId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw Exception('El incidente no existe o ya fue eliminado.');
    }

    final currentData = docSnapshot.data() ?? {};
    final uidAutor = _readUidOwner(currentData);

    String? oldStoragePath;

    if (title != null) {
      data['titulo'] = title.trim();
      data['title'] = title.trim();
    }

    if (description != null) {
      data['descripcion'] = description.trim();
      data['description'] = description.trim();
    }

    if (type != null) {
      data['tipo'] = type.trim();
      data['type'] = type.trim();
    }

    if (campus != null) {
      data['sede'] = campus.trim();
      data['campus'] = campus.trim();
    }

    if (locationText != null) {
      final cleanLocationText = locationText.trim();

      if (cleanLocationText.isNotEmpty) {
        data['ubicacionTexto'] = cleanLocationText;
        data['ubicacionTextual'] = cleanLocationText;
        data['locationText'] = cleanLocationText;
        data['ubicacion'] = cleanLocationText;
        data['location'] = cleanLocationText;
      } else if (campus != null) {
        data['ubicacion'] = campus.trim();
        data['location'] = campus.trim();
      }
    }

    if (gpsRegistered != null) {
      data['gpsRegistrado'] = gpsRegistered;
      data['gpsRegistrada'] = gpsRegistered;
      data['gpsRegistered'] = gpsRegistered;

      if (gpsRegistered && gpsLatitude != null && gpsLongitude != null) {
        data['latitud'] = gpsLatitude;
        data['longitud'] = gpsLongitude;
        data['gpsLatitude'] = gpsLatitude;
        data['gpsLongitude'] = gpsLongitude;
        data['gpsLatitud'] = gpsLatitude;
        data['gpsLongitud'] = gpsLongitude;
        data['gps'] = GeoPoint(gpsLatitude, gpsLongitude);
      }
    }

    if (imageFile != null) {
      if (uidAutor == null || uidAutor.trim().isEmpty) {
        throw Exception(
          'No se pudo actualizar la imagen porque el incidente no tiene uidAutor o uidUsuario.',
        );
      }

      oldStoragePath = _readCurrentImageStoragePath(currentData);

      final imageData = await _uploadIncidentImage(
        uid: uidAutor,
        imageFile: imageFile,
      );

      data['imageUrl'] = imageData.downloadUrl;
      data['imagenUrl'] = imageData.downloadUrl;
      data['storagePath'] = imageData.storagePath;
      data['imagenStoragePath'] = imageData.storagePath;
      data['imagenNombre'] = imageData.fileName;
    }

    if (data.isNotEmpty) {
      data['fechaActualizacion'] = FieldValue.serverTimestamp();

      await docRef.update(data);

      if (imageFile != null && oldStoragePath != null) {
        final newStoragePath = data['storagePath']?.toString();

        await _deletePreviousIncidentImage(
          oldPath: oldStoragePath,
          newPath: newStoragePath,
        );
      }
    }
  }

  String? _readUidOwner(Map<String, dynamic> data) {
    final value = data['uidAutor'] ??
        data['uidUsuario'] ??
        data['usuarioId'] ??
        data['userId'] ??
        data['uid'];

    final text = value?.toString().trim();

    if (text == null || text.isEmpty || text == 'null') {
      return null;
    }

    return text;
  }

  String? _readCurrentImageStoragePath(Map<String, dynamic> data) {
    final value = data['imagenStoragePath'] ??
        data['storagePath'] ??
        data['gsUrl'] ??
        data['storageUrl'] ??
        data['imageUrl'] ??
        data['imagenUrl'];

    final text = value?.toString().trim();

    if (text == null || text.isEmpty || text == 'null') {
      return null;
    }

    return text;
  }

  Future<void> _deletePreviousIncidentImage({
    required String oldPath,
    required String? newPath,
  }) async {
    final oldValue = oldPath.trim();
    final newValue = newPath?.trim();

    if (oldValue.isEmpty) return;

    if (newValue != null && newValue.isNotEmpty && oldValue == newValue) {
      return;
    }

    if (oldValue.startsWith('assets/') ||
        oldValue.startsWith('file://') ||
        oldValue.startsWith('/')) {
      return;
    }

    try {
      final Reference oldRef;

      if (oldValue.startsWith('gs://') ||
          oldValue.startsWith('http://') ||
          oldValue.startsWith('https://')) {
        oldRef = _storage.refFromURL(oldValue);
      } else {
        oldRef = _storage.ref(oldValue);
      }

      final oldFullPath = oldRef.fullPath.trim();

      if (newValue != null &&
          newValue.isNotEmpty &&
          oldFullPath == newValue) {
        return;
      }

      debugPrint('Eliminando imagen anterior de Storage: $oldFullPath');

      await oldRef.delete();

      debugPrint('Imagen anterior eliminada correctamente.');
    } on FirebaseException catch (error) {
      if (error.code == 'object-not-found') {
        debugPrint('La imagen anterior ya no existe en Storage.');
        return;
      }

      debugPrint(
        'La imagen nueva se guardó, pero no se pudo eliminar la imagen anterior: ${error.code} - ${error.message}',
      );
    } catch (error) {
      debugPrint(
        'La imagen nueva se guardó, pero ocurrió un error eliminando la anterior: $error',
      );
    }
  }
}

class _UploadedIncidentImage {
  _UploadedIncidentImage({
    required this.downloadUrl,
    required this.storagePath,
    required this.fileName,
  });

  final String downloadUrl;
  final String storagePath;
  final String fileName;
}