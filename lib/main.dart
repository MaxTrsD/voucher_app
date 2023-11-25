import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _globalKey = GlobalKey();

  String nomesDeClientes = '';
  String tipoDePasseio = '';
  String dataDePasseio = '';
  String dataDeEmissao = '';
  String referentePasseio = '';
  String valorPago = '';
  String valorAReceber = '';
  String valorTotal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Center(
          child: Text(
            'Voucher',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Divider(),
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  width: 400,
                  height: 179,
                  color: ui.Color.fromARGB(0, 0, 0, 0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      // Display the base voucher image
                      Image.asset('assets/images/voucher (5).png',
                          width: 300, height: 200),
                      // Display customer name and payment info
                      Positioned(
                        top: 90,
                        left: 40,
                        child: Text(
                          nomesDeClientes,
                          style: TextStyle(
                              color: const ui.Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      Positioned(
                        top: 90,
                        left: 300,
                        child: Text(
                          valorPago,
                          style: TextStyle(
                              color: const ui.Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 20),
              // TextFields for customer name and payment info
              TextField(
                onChanged: (value) {
                  setState(() {
                    nomesDeClientes = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Nome do Cliente'),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    valorPago = value;
                  });
                },
                decoration:
                    InputDecoration(labelText: 'Informações de Pagamento'),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 27, 27, 57),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: _saveImage,
                    child: Text(
                      'Salvar Imagem',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveImage() async {
    // Verificar se a permissão já foi concedida
    Permission.storage.request();
    var status = await Permission.storage.status;

    if (status.isGranted) {
      // Se a permissão já foi concedida, salvar a imagem
      _saveImageInternal();
    } else {
      // Se a permissão ainda não foi concedida, solicitar permissão
      if (await Permission.storage.request().isGranted) {
        // Se o usuário concedeu permissão, salvar a imagem
        _saveImageInternal();
      } else {
        // Se o usuário negou a permissão, exibir uma mensagem ou tratar conforme necessário
        print('Permissão de armazenamento negada pelo usuário. $status');
      }
    }
  }

  void _saveImageInternal() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 10.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();
      ui.Codec codec = await ui.instantiateImageCodec(pngBytes,
          targetHeight: 900, targetWidth: 2000);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      ui.Image resizedImage = frameInfo.image;

      // Save the resized image to the gallery
      Uint8List resizedBytes =
          (await resizedImage.toByteData(format: ui.ImageByteFormat.png))!
              .buffer
              .asUint8List();
      await ImageGallerySaver.saveImage(resizedBytes);

      // Exibir a SnackBar após salvar a imagem
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ui.Color.fromARGB(255, 27, 27, 57),
          content: Text('Imagem salva com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      print("Failed to convert image to ByteData");
    }
  }
}
