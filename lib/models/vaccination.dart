import 'package:cloud_firestore/cloud_firestore.dart';

class Vaccination {
  String vaccination;
  DateTime date;
  bool done;
  DocumentReference reference;

  Vaccination(this.vaccination, {this.date, this.done, this.reference});

  factory Vaccination.fromJson(Map<dynamic, dynamic> json) => _VaccinationFromJson(json);

  Map<String, dynamic> toJson() => _VaccinationToJson(this);

  @override
  String toString() => "Vaccination<$vaccination>";

}

// ignore: non_constant_identifier_names
Vaccination _VaccinationFromJson(Map<dynamic, dynamic> json) {
  return Vaccination(
    json['vaccination'] as String,
    date: json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
    done: json['done'] as bool,
  );
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _VaccinationToJson(Vaccination instance) =>
    <String, dynamic> {
      'vaccination': instance.vaccination,
      'date': instance.date,
      'done': instance.done,
    };
