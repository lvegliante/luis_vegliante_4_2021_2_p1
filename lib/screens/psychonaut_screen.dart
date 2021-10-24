import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nautas_app/Models/psychonauts.dart';
import 'package:flutter_nautas_app/components/loader_component.dart';
import 'package:flutter_nautas_app/helpers/constans.dart';


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
            title: Text(Constans.camelToSentence(_psychonaut.name)),
            backgroundColor: Colors.orange,
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
                decoration: new BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
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
                                  Constans.camelToSentence(e.name),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Row(
                                  
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(maxWidth: 200),
                                        child: Text((e.description == null) ? " ": e.description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87,
                                              fontSize: 17.0
                                    ),
                                    )
                                    
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
      decoration: new BoxDecoration(
    color: Colors.green.shade200,
    borderRadius: BorderRadius.circular(10),
  ),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.network(
                        _psychonaut.img,
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
              ),
              
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
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )
                            ),
                            Text(
                              Constans.camelToSentence(_psychonaut.name), 
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Genero: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              )
                            ),
                            Text(
                              (_psychonaut.gender == 'male') ? 'Hombre':'Mujer',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18,),
                        Row(
                          children: <Widget>[
                            Text(
                              'PsyPowers... ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              )
                            ),
                          ],
                        ),
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