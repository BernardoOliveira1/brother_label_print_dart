import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:brotherlabelprintdart/print.dart';
import 'package:brotherlabelprintdart/templateLabel.dart';
import 'package:brotherlabelprintdart/printerModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String ipOfPrinter = "192.168.15.6";
  final PrinterModel printerModel = PrinterModel.QL_810W;
  String _printStatus = 'Initializing...';

  void print(bool bulk) async {
    setState(() {
      _printStatus = "Running...";
    });

    List<TemplateLabel> labels = [];

    labels.add(
      TemplateLabel(
        5,
        [
          'nome',
        ],
      ),
    );

    String result;
    try {
      result = await BrotherLabelPrintDart.printLabelFromTemplate(
          ipOfPrinter, printerModel, labels);
    } catch (e) {
      result = "An error occured : $e";
    }

    setState(() {
      _printStatus = result;
    });
  }

  void printImage() async {
    FilePickerResult fileResult =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (fileResult != null) {
      File file = File(fileResult.files.single.path);

      String result;
      try {
        // width and height might be to be of image dimensions.
        result = await BrotherLabelPrintDart.printLabelFromImage(
            ipOfPrinter, printerModel, file, 100, 100);
      } catch (e) {
        result = "An error occured : $e";
      }

      setState(() {
        _printStatus = result;
      });
    }
  }

  void printPdf() async {
    FilePickerResult fileResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (fileResult != null) {
      File file = File(fileResult.files.single.path);

      String result;
      try {
        // numberOfPages should be passed according to file.
        result = await BrotherLabelPrintDart.printLabelFromPdf(
            ipOfPrinter, printerModel, file, 1);
      } catch (e) {
        result = "An error occured : $e";
      }

      setState(() {
        _printStatus = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Brother Label Print Dart'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Print status : $_printStatus\n'),
            MaterialButton(
              child: Text("Print 1 label"),
              onPressed: () {
                print(false);
              },
            ),
            MaterialButton(
              child: Text("Print 5 labels"),
              onPressed: () {
                print(true);
              },
            ),
            MaterialButton(
              child: Text("Print from image"),
              onPressed: () {
                printImage();
              },
            ),
            MaterialButton(
              child: Text("Print from PDF"),
              onPressed: () {
                printPdf();
              },
            )
          ],
        )),
      ),
    );
  }
}
