import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:trabalho_final_flutter/PetDetails.dart';
import 'package:trabalho_final_flutter/repository/dataRepository.dart';
import 'package:trabalho_final_flutter/utils/pets_icons.dart';

import 'models/pets.dart';

void main() => runApp(MyApp());

const BoldStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pets',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeList());
  }
}

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return _buildHome(context);
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pets"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            return _buildList(context, snapshot.data.documents);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPet();
        },
        tooltip: 'Adicionar Pet',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addPet() {
    AlertDialogWidget dialogWidget = AlertDialogWidget();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Preencha as informações"),
              content: dialogWidget,
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancelar")),
                FlatButton(
                    onPressed: () {
                      Pet newPet = Pet(dialogWidget.petName, type: dialogWidget.character);
                      repository.addPet(newPet);
                      Navigator.of(context).pop();
                      _mostrarToast(context);
                    },
                    child: Text("Adicionar")),
              ]);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final pet = Pet.fromSnapshot(snapshot);
    if (pet == null) {
      return Container();
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              Expanded(child: Text(pet.name == null ? "" : pet.name, style: BoldStyle)),
              _getPetIcon(pet.type)
            ],
          ),
          onTap: () {
            _navigate(BuildContext context)  {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetDetails(pet),
                  ));
            }

            _navigate(context);
          },
          highlightColor: Colors.green,
          splashColor: Colors.blue,
        ));
  }

  Widget _getPetIcon(String type ) {
    Widget petIcon;
    if (type == "cat") {
      petIcon = IconButton(
        icon: Icon(Pets.cat),
        onPressed: () {},
      );
    } else if (type == "dog") {
      petIcon = IconButton(
        icon: Icon(Pets.dog_seating),
        onPressed: () {},
      );

    } else {
      petIcon = IconButton(
        icon: Icon(Icons.pets),
        onPressed: () {},
      );
    }
    return petIcon;
  }

  void _mostrarToast(BuildContext context) {
    Toast.show('Animal inserido', context, duration: 5);
  }

}

// ignore: must_be_immutable
class AlertDialogWidget extends StatefulWidget {
  String petName;
  String character = '';

  @override
  _AlertDialogWidgetState createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Insira o nome do pet"),
            onChanged: (text) => widget.petName = text,
          ),
          RadioListTile(
            title: Text("Gato"),
            value: "cat",
            groupValue: widget.character,
            onChanged: (String value) {
              setState(() { widget.character = value; });
            },
          ),
          RadioListTile(
            title: Text("Cachorro"),
            value: "dog",
            groupValue: widget.character,
            onChanged: (String value) {
              setState(() { widget.character = value; });
            },
          ),
          RadioListTile(
            title: Text("Outro"),
            value: "other",
            groupValue: widget.character,
            onChanged: (String value) {
              setState(() { widget.character = value; });
            },
          )
        ],
      ),
    );
  }
}

