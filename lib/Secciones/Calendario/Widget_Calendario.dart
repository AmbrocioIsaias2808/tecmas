import 'package:flutter/material.dart';

import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:tecmas/BarraDeNavegacion/Drawer.dart';
import 'package:tecmas/Temas/BaseTheme.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class Widget_Calendario extends StatefulWidget {
  String URL;
  String fromAsset;


  Widget_Calendario({@required this.URL=''});

  @override
  _Widget_CalendarioState createState() => _Widget_CalendarioState(fromURL: URL);

}

class _Widget_CalendarioState extends State<Widget_Calendario> {


  bool _isLoading=true;
  PDFDocument Document;

  String fromURL;
  String fromAsset;


  _Widget_CalendarioState({this.fromURL='', this.fromAsset=''});

  void loadDocument() async{





    if(fromURL!=''){
      try{
        Document= await PDFDocument.fromURL(fromURL);
      }catch(e){

      }

    }else{
      Document= await PDFDocument.fromAsset(fromAsset);
    }

    setState(() {
      _isLoading=false;
    });





  }

  @override
  void initState() {

    super.initState();
    loadDocument();
  }

  bool networkerror=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BarraDeNavegacion(),
      appBar: AppBar(
        title: Text("Calendario Escolar"),
        backgroundColor:BaseThemeAppBarColor,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
              child: FlatButton(
                  color: BaseThemeColor_DarkBlue,
                  shape: CircleBorder(),
                  child: Icon(Icons.refresh, color: Colors.white,),
                  onPressed: (){
                    DefaultCacheManager().removeFile(fromURL);
                    Future.delayed(Duration(milliseconds: 100),(){
                      setState(() {
                        _isLoading=true;
                      });
                      loadDocument();
                    }
                    );
                  }
              )
          )
        ],
      ),
      body: Center(
          child:
            _isLoading ? Center(child: CircularProgressIndicator())
                : PDFViewer(document: Document, showPicker: true, showIndicator: true, showNavigation: true,indicatorBackground: BaseThemeColor_DarkBlue,),
      ),
    );
  }
}


