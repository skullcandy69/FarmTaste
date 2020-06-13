import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class Policy extends StatefulWidget {
  const Policy({Key key}) : super(key: key);

  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  String assetPDFPath = "";
  PdfController _pdfController ;

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openAsset('images/Policy.pdf'),
      
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),scrollDirection: Axis.vertical,
        controller: _pdfController ,
       
      ),
    );
  }
}
