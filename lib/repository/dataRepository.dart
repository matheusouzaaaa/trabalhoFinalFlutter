import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho_final_flutter/models/pets.dart';


class DataRepository {
  final CollectionReference collection = Firestore.instance.collection('pets');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  
  Future<DocumentReference> addPet(Pet pet) {
    return collection.add(pet.toJson());
  }

  Future<DocumentReference> deletePet(Pet pet) {
    return collection.document(pet.reference.documentID).delete();
  }

  updatePet(Pet pet) async {
      await collection.document(pet.reference.documentID).updateData(pet.toJson());
  }
}