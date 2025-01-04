// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUserDetails() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        return [];
      }

      String currentUid = currentUser.uid;

      DocumentSnapshot currentUserDoc =
          await _firestore.collection('usuarios').doc(currentUid).get();

      if (!currentUserDoc.exists) {
        return [];
      }

      String organizacao = currentUserDoc['organizacao'];

      QuerySnapshot snapshot = await _firestore
          .collection('usuarios')
          .where('organizacao', isEqualTo: organizacao)
          .get();

      List<Map<String, dynamic>> userDetails = [];

      for (var doc in snapshot.docs) {
        String uid = doc['uid'];

        if (uid != currentUid) {
          userDetails.add({
            'uid': uid,
            'nome': doc['nome'],
            'cargaHorariaDiaria': doc['cargaHorariaDiaria'],
          });
        }
      }

      return userDetails;
    } catch (e) {
      print('Erro ao buscar dados: $e');
      return [];
    }
  }
}
