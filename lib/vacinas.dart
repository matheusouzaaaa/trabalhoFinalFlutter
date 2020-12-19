import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:trabalho_final_flutter/repository/dataRepository.dart';
import 'package:trabalho_final_flutter/utils/constants.dart';

import 'models/vaccination.dart';
import 'models/pets.dart';

typedef DialogCallback = void Function();

class Vacinas extends StatelessWidget {
  final Pet pet;

  const Vacinas(this.pet);

  @override
  Widget build(BuildContext context) {
    var name = pet.name== null ?  ' ' : pet.name;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Vacinas: $name"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: VacinaForm(pet),
      ),
    );
  }
}

class VacinaForm extends StatefulWidget {
  final Pet pet;

  const VacinaForm(this.pet);

  @override
  _VacinaFormState createState() => _VacinaFormState();
}

class _VacinaFormState extends State<VacinaForm> {
  final DataRepository repository = DataRepository();
  final _formKey = GlobalKey<FormBuilderState>();
  final dateFormat = DateFormat('yyyy-MM-dd');
  String name;
  String type;
  String notes;

  @override
  void initState() {
    name = widget.pet.name;
    type = widget.pet.type;
    notes = widget.pet.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            FormBuilderCustomField(
              attribute: "vaccinations",
              formField: FormField(
                enabled: true,
                builder: (FormFieldState<dynamic> field) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 6.0),
                      Text(
                        "Vacinas",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(16.0),
                          itemCount: widget.pet.vaccinations == null ? 0 : widget.pet.vaccinations.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildRow(widget.pet.vaccinations[index]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                _addVaccination(widget.pet, () {
                  setState(() {});
                });

              },
              tooltip: 'Adicionar Vacinas',
              child: Icon(Icons.add),
            ),

          ],
        ),

      ),
    );
  }

  Widget buildRow(Vaccination vaccination) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(vaccination.vaccination),
        ),
        Text(vaccination.date == null ? "" : dateFormat.format(vaccination.date)),
        Checkbox(
          value: vaccination.done == null ? false : vaccination.done,
          onChanged: (newValue) {
            vaccination.done = newValue;
            repository.updatePet(widget.pet);
            setState(() {});
            _mostrarUpdateToast(context);
          },
        )
      ],
    );
  }

  void _addVaccination(Pet pet, DialogCallback callback) {
    String vaccination;
    DateTime vaccinationDate;
    bool done = false;
    final _formKey = GlobalKey<FormBuilderState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Adicionar Vacinas"),
              content: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: "vaccination",
                        validators: [
                          FormBuilderValidators.minLength(1),
                          FormBuilderValidators.required()
                        ],
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Escreva o nome da vacina',
                            labelText: "Vacina"),
                        onChanged: (text) {
                          setState(() {
                            vaccination = text;
                          });
                        },
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "date",
                        inputType: InputType.date,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Data da vacinação',
                            labelText: "Data"),
                        onChanged: (text) {
                          setState(() {
                            vaccinationDate = text;
                          });
                        },
                      ),
                      FormBuilderCheckbox(
                        attribute: "given",
                        label: Text("Aplicada"),
                        onChanged: (text) {
                          setState(() {
                            done = text;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancelar")),
                FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.of(context).pop();
                        Vaccination newVaccination = Vaccination(vaccination,date: vaccinationDate, done: done);
                        if (pet.vaccinations == null) {
                          pet.vaccinations = List<Vaccination>();
                        }
                        pet.vaccinations.add(newVaccination);
                        // chama o update?
                        repository.updatePet(widget.pet);
                        _mostrarInsertToast(context);
                      }
                      callback();
                    },
                    child: Text("Adicionar")),
              ]);
        });
  }

  void _mostrarUpdateToast(BuildContext context) {
      Toast.show('Vacina atualizada', context, duration: 5);
  }

  void _mostrarInsertToast(BuildContext context) {
    Toast.show('Vacina cadastrada', context, duration: 5);
  }
}
