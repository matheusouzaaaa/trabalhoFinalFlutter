import 'package:cloud_firestore/cloud_firestore.dart';

import 'vaccination.dart';

class Pet {
  String name;
  String notes;
  String type;
  List<Vaccination> vaccinations = List<Vaccination>();
  DocumentReference reference;

  Pet(this.name, {this.notes, this.type, this.reference, this.vaccinations});

  factory Pet.fromSnapshot(DocumentSnapshot snapshot) {
    Pet newPet = Pet.fromJson(snapshot.data);
    newPet.reference = snapshot.reference;
    return newPet;
  }

  factory Pet.fromJson(Map<String, dynamic> json) => _PetFromJson(json);

  Map<String, dynamic> toJson() => _PetToJson(this);

  @override
  String toString() => "Pet<$name>";
}

// ignore: non_constant_identifier_names
Pet _PetFromJson(Map<String, dynamic> json) {
  return Pet(
    json['name'] as String,
    notes: json['notes'] as String,
    type: json['type'] as String,
    vaccinations: _convertVaccinations(json['vaccinations'] as List)
  );
}

List<Vaccination> _convertVaccinations(List vaccinationMap) {
  if (vaccinationMap == null) {
    return null;
  }
  List<Vaccination> vaccinations =  List<Vaccination>();
  vaccinationMap.forEach((value) {
    vaccinations.add(Vaccination.fromJson(value));
  });
  return vaccinations;
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _PetToJson(Pet instance) => <String, dynamic> {
      'name': instance.name,
      'notes': instance.notes,
      'type': instance.type,
      'vaccinations': _VaccinationList(instance.vaccinations),
    };

// ignore: non_constant_identifier_names
List<Map<String, dynamic>> _VaccinationList(List<Vaccination> vaccinations) {
  if (vaccinations == null) {
    return null;
  }
  List<Map<String, dynamic>> vaccinationMap =List<Map<String, dynamic>>();
  vaccinations.forEach((vaccination) {
    vaccinationMap.add(vaccination.toJson());
  });
  return vaccinationMap;
}
