import 'package:flutter/material.dart';
import 'package:gluc_safe/services/pdf_api.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final String name;
  final List glucoseValues;
  final Locale locale;
  const PdfPreviewPage(
      {Key? key,
      required this.name,
      required this.glucoseValues,
      required this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => PDFApi.CreatePDFFile(
            fullName: name, glucoseValues: glucoseValues, locale: locale),
      ),
    );
  }
}
