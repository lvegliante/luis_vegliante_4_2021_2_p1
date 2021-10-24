import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nautas_app/Models/psychonauts.dart';
import 'package:flutter_nautas_app/components/loader_component.dart';


class PsychonautScreen extends StatefulWidget {
  final Psychonaut psychonaut;

  PsychonautScreen({required this.psychonaut});

  @override
  _PsychonautScreenState createState() => _PsychonautScreenState();
}
class _PsychonautScreenState extends State<PsychonautScreen> {
  bool _showLoader = false;
  late Psychonaut _psychonaut;

 @override
  void initState() {
    super.initState();
    _psychonaut = widget.psychonaut;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text(_psychonaut.name),
          ),
          body: Center(
            child: _showLoader 
              ? LoaderComponent(text: 'Por favor espere...',) 
              : _getContent(),
          ),
    );
  }
    Widget _getContent() {
    return Column(
      children: <Widget>[
        _showPsypowers(),
        Expanded(
          child: _psychonaut.name == null ? _noContent() : _getListView(),
        ),
      ],
    );
  }

   Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _checkConectivity,
      child: ListView(
        children: _psychonaut.psiPowers.map((e) {
          return Card(
            child: InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        e.img,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  e.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      e.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ), 
    );
  }

    Future<Null> _checkConectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {

      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );
      return;
    }
  }

Widget _showPsypowers() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        _psychonaut.img,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
              ),
              Positioned(
                bottom: 0,
                left: 60,
                child: InkWell(
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.green[50],
                      height: 40,
                      width: 40,
                      child: Icon(
                        Icons.edit,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Nombre: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              _psychonaut.name, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Genero: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              (_psychonaut.gender == 'male') ? 'Hombre':'Mujer',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5,),
                         Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

   Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          (_psychonaut.name+' no tiene psyPower.'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}