import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';

class IncidentQueryService {
  IncidentQueryService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<IncidentItem>> streamAllIncidents() {
    return _firestore.collection('incidentes').snapshots().map((snapshot) {
      final incidents = snapshot.docs.map(IncidentItem.fromFirestore).toList();

      incidents.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return incidents;
    });
  }

  Stream<List<IncidentItem>> streamUserIncidents(String uid) {
    return _firestore
        .collection('incidentes')
        .where('uidAutor', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final incidents = snapshot.docs.map(IncidentItem.fromFirestore).toList();

      incidents.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return incidents;
    });
  }
}
