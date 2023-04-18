import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFApi {
  static Future<Uint8List> CreatePDFFile(
      {required String fullName,
      required List glucoseValues,
      required Locale locale}) async {
    final pdf = pw.Document();
    final BoldFont =
        await rootBundle.load("lib/assets/fonts/Rubik/Rubik-Bold.ttf");
    final RegularFont =
        await rootBundle.load("lib/assets/fonts/Rubik/Rubik-Regular.ttf");
    final Boldttf = pw.Font.ttf(BoldFont);
    final Regularttf = pw.Font.ttf(RegularFont);
    final ByteData image =
        await rootBundle.load('lib/assets/glucsafe-pdf-title.png');
    Uint8List imageData = (image).buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: locale == Locale('en')
                ? pw.TextDirection.ltr
                : pw.TextDirection.rtl,
            child: pw.Column(
              children: [
                pw.Center(
                  child: pw.Container(
                    height: 30,
                    margin: pw.EdgeInsets.only(bottom: 50),
                    child: pw.Image(
                      pw.MemoryImage(imageData),
                    ),
                  ),
                ),
                pw.Container(
                  height: 150,
                  child: pw.Text(
                    fullName,
                    style: pw.TextStyle(fontSize: 25, font: Boldttf),
                  ),
                ),
                pw.Table(
                  border: pw.TableBorder.all(width: 2, color: PdfColors.green),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Center(
                          child: pw.Text(
                            "pdf_date_time_title".tr(),
                            style: pw.TextStyle(
                              fontSize: 18,
                              font: Boldttf,
                            ),
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            "pdf_glucose_title".tr(),
                            style: pw.TextStyle(
                              fontSize: 18,
                              font: Boldttf,
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var index = 0; index < glucoseValues.length; index++)
                      pw.TableRow(
                        children: [
                          pw.Center(
                            child: pw.Text(
                              DateFormat('dd.MM.yyyy HH:mm')
                                  .format(glucoseValues[index][0]),
                              style: pw.TextStyle(
                                font: Regularttf,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              glucoseValues[index][1],
                              style: pw.TextStyle(
                                fontSize: 18,
                                font: Regularttf,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }
}
