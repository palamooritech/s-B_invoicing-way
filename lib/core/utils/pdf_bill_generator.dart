import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generatePdf(BuildContext context, Bill bill) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.spaceGroteskRegular();
  final signatureImage = pw.MemoryImage(
    (await rootBundle.load('assets/images/signature_image.png')).buffer.asUint8List(),
  );
  final headerImage = pw.MemoryImage(
    (await rootBundle.load('assets/images/header_image.png')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 10, left: 10, right: 10),
              child: pw.Image(headerImage, height: 100),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'BILL OF EXPENSES',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Bill No: ', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text(bill.billId, style: pw.TextStyle(fontSize: 18)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10),
              child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Description:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text('${bill.invoice.description}', style: pw.TextStyle(fontSize: 18))
                  ]
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Date(s) of Event: ', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      '${DateFormat('yyyy-MM-dd').format(bill.invoice.startData)} To: ${DateFormat('yyyy-MM-dd').format(bill.invoice.endDate)}',
                      style: pw.TextStyle(fontSize: 18),
                    ),
                  ],
                )
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                'Expenses Breakdown',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Container(
                width: PdfPageFormat.a4.width * 2 / 3,
                child: pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text('S.No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white), textAlign: pw.TextAlign.center),
                        pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white), textAlign: pw.TextAlign.center),
                        pw.Text('Expenses (INR)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white), textAlign: pw.TextAlign.center),
                      ],
                      decoration: pw.BoxDecoration(color: PdfColors.grey800),
                    ),
                    ...List<pw.TableRow>.generate(
                      bill.invoice.entries.length,
                          (index) => pw.TableRow(
                        children: [
                          pw.Text((index + 1).toString(), textAlign: pw.TextAlign.center),
                          pw.Text(bill.invoice.entries[index].description, textAlign: pw.TextAlign.center),
                          pw.Text(bill.invoice.entries[index].rate.toString(), textAlign: pw.TextAlign.center),
                        ],
                      ),
                    ),
                    pw.TableRow(
                      children: [
                        pw.Text(''),
                        pw.Text('Amount Already Paid', textAlign: pw.TextAlign.center),
                        pw.Text(bill.paidAmount.toString(), textAlign: pw.TextAlign.center),
                      ],
                      decoration: pw.BoxDecoration(color: PdfColors.deepOrange600),
                    ),
                    pw.TableRow(
                      children: [
                        pw.Text(''),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text('Total Expenses', textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text(bill.pendingAmount.toString(), textAlign: pw.TextAlign.center, style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold
                          )),
                        )
                      ],
                      decoration: pw.BoxDecoration(
                          color: PdfColors.green600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10),
              child:pw.Container(
                  width: double.infinity,
                  child:pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Expenses to be Paid: ', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Rupees ${NumberToWordsEnglish.convert(bill.pendingAmount.ceil())} (Rs. ${bill.pendingAmount.ceil()}) only',
                        style: pw.TextStyle(fontSize: 18),
                      ),
                    ],
                  )
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                    children: [
                      pw.Text('Please pay the expenses on the UPI ID - ', style: pw.TextStyle(fontSize: 18)),
                      pw.Text('9705653355@ybl', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
                    ]
                )
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              width: double.infinity,
              child:pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Image(signatureImage, height: 50),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Text("Kanthi Kiran Bhargav", style: pw.TextStyle(fontSize: 18)),
                  ),
                ]
              )
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
