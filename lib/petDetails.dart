import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:trabalho_final_flutter/repository/dataRepository.dart';
import 'package:trabalho_final_flutter/utils/constants.dart';
import 'package:trabalho_final_flutter/vacinas.dart';
import 'models/vaccination.dart';
import 'models/pets.dart';

typedef DialogCallback = void Function();

class PetDetails extends StatelessWidget {
  final Pet pet;

  const PetDetails(this.pet);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(pet.name== null ? "" : pet.name),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: PetDetailForm(pet),
      ),
    );
  }
}

class PetDetailForm extends StatefulWidget {
  final Pet pet;

  const PetDetailForm(this.pet);

  @override
  _PetDetailFormState createState() => _PetDetailFormState();
}

class _PetDetailFormState extends State<PetDetailForm> {
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
            FormBuilderTextField(
              attribute: "name",
              initialValue: widget.pet.name,
              decoration: textInputDecoration.copyWith(
                  hintText: 'Nome', labelText: "Nome do pet"),
              validators: [
                FormBuilderValidators.minLength(1),
                FormBuilderValidators.required()
              ],
              onChanged: (val) {
                setState(() => name = val);
              },
            ),
            FormBuilderRadioGroup(
              decoration: InputDecoration(labelText: 'Espécie'),
              attribute: "cat",
              initialValue: type,
              options: [
                FormBuilderFieldOption(
                    value: "cat",
                    child: Text(
                      "Gato",
                      style: TextStyle(fontSize: 16.0),
                    )),
                FormBuilderFieldOption(
                    value: "dog",
                    child: Text(
                      "Cachorro",
                      style: TextStyle(fontSize: 16.0),
                    )),
                FormBuilderFieldOption(
                    value: "other",
                    child: Text(
                      "Outros",
                      style: TextStyle(fontSize: 16.0),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  type = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            FormBuilderTextField(
              attribute: "notes",
              initialValue: widget.pet.notes,
              decoration: textInputDecoration.copyWith(
                  hintText: 'Anotações:', labelText: "Anotações"),
              onChanged: (val) {
                setState(() => notes = val);
              },
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                    color: Colors.blue.shade600,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (_formKey.currentState.validate()) {

                          widget.pet.name = name;
                          widget.pet.type = type;
                          widget.pet.notes = notes;

                          repository.updatePet(widget.pet);
                          Navigator.of(context).pop();
                          _mostrarUpdateToast(context);
                        }
                      }
                    },
                    child: Text(
                      "Atualizar",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                )),

                MaterialButton(
                    color: Colors.blue.shade600,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _mostrarDeleteToast(context);
                      repository.deletePet(widget.pet);
                    },
                    child: Text(
                      "Excluir",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    )),
                MaterialButton(
                    color: Colors.blue.shade600,
                    onPressed: () {
                      _navigate(BuildContext context)  {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Vacinas(widget.pet),
                            ));
                      }

                      _navigate(context);
                    },
                    child: Text(
                      "Vacinas",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    )),
                MaterialButton(
                    color: Colors.blue.shade600,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarUpdateToast(BuildContext context) {
      Toast.show('Animal atualizado', context, duration: 5);
  }

  void _mostrarDeleteToast(BuildContext context) {
    Toast.show('Animal excluído', context, duration: 5);
  }

}
