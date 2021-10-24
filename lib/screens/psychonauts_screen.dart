import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nautas_app/Models/psychonauts.dart';
import 'package:flutter_nautas_app/components/loader_component.dart';
import 'package:flutter_nautas_app/helpers/api_helper.dart';
import 'package:flutter_nautas_app/helpers/constans.dart';
import 'package:flutter_nautas_app/models/response.dart';
import 'package:flutter_nautas_app/screens/psychonaut_screen.dart';

class PsychonautsScreen extends StatefulWidget {

  PsychonautsScreen();

  @override
  _PsychonautsScreenState createState() => _PsychonautsScreenState();
}
class _PsychonautsScreenState extends State<PsychonautsScreen> {
  List<Psychonaut> _psychonauts = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _getPsychonauts();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Psychonauts'),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          _isFiltered
          ? IconButton(
              onPressed: _removeFilter, 
              icon: Icon(Icons.filter_7_sharp)
            )
          : IconButton(
              onPressed: _showFilter, 
              icon: Icon(Icons.filter_rounded)
            )
        ],
      ),
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Por favor espere...') : _getContent(),
      ),
    );
  }

  Future<Null> _getPsychonauts() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
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

    Response response = await ApiHelper.getPsychonaute();

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    setState(() {
      _psychonauts = response.result;
    });
  }

  Widget _getContent() {
    return _psychonauts.length == 0 
      ? _noContent()
      : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'No hay psychonauts con ese criterio de búsqueda.'
          : 'No hay psychonauts registrados.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

   Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getPsychonauts,
      child: ListView(
        children: _psychonauts.map((e) {
          return Card(
            child: InkWell(
              onTap: () => _goPsyPower(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                 decoration: new BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
                child: Row(
                  children: [
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
                          children: [
                            Column(
                              children: [
                                Text(
                                  Constans.camelToSentence(e.name), 
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.settings_power),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Filtrar Psychonauts'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Escriba las primeras letras del nombre del Psychonauts'),
              SizedBox(height: 10,),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search)
                ),
                onChanged: (value) {
                  _search = value;
                },
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: () => _filter(), 
              child: Text('Filtrar')
            ),
          ],
        );
      });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getPsychonauts();
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<Psychonaut> filteredList = [];
    for (var procedure in _psychonauts) {
      if (procedure.name.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(procedure);
      }
    }

    setState(() {
      _psychonauts = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();

    
  }
 
  void _goPsyPower(Psychonaut psychonaut) async {
      String? result = await Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => PsychonautScreen(
            psychonaut: psychonaut,
          )
        )
      );
      if (result == 'yes') {
        _getPsychonauts();
      }
    }
  }