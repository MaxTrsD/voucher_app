import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';

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

  String customerName = '';
  String paymentInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: 350,
                height: 242,
                color: ui.Color.fromARGB(192, 158, 158, 158),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Display the base voucher image
                    Image.asset('assets/images/voucher (5).png',
                        width: 300, height: 200),
                    // Display customer name and payment info
                    Positioned(top: 90, left: 40, child: Text(customerName)),
                    Positioned(
                      top: 90,
                      left: 300,
                      child: Text(
                        paymentInfo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // TextFields for customer name and payment info
            TextField(
              onChanged: (value) {
                setState(() {
                  customerName = value;
                });
              },
              decoration: InputDecoration(labelText: 'Nome do Cliente'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  paymentInfo = value;
                });
              },
              decoration:
                  InputDecoration(labelText: 'Informações de Pagamento'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveImage,
              child: Text('Salvar Imagem'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Convert to image from the `image` package
      img.Image imgData = img.decodeImage(pngBytes)!;

      // Customize your voucher with customer name and payment info
      // Use Image.asset for assets in Flutter
      ByteData assetByteData =
          await rootBundle.load('assets/images/voucher (5).png');
      List<int> assetBytes = assetByteData.buffer.asUint8List();
      img.Image voucherImage = img.decodeImage(Uint8List.fromList(assetBytes))!;

      // Merge the voucher image with customer name and payment info
      _mergeImages(imgData, voucherImage, 0, 200);

      // Get the document directory using path_provider
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Define o caminho completo para o arquivo
      String filePath = '${documentsDirectory.path}/voucher_image.jpg';

      // Salva a imagem no caminho especificado
      File(filePath).writeAsBytesSync(img.encodeJpg(voucherImage)!);

      // Save the final image to the gallery
      await ImageGallerySaver.saveFile(filePath);
    } else {
      print("Failed to convert image to ByteData");
    }
  }

  void _mergeImages(
      img.Image target, img.Image source, int offsetX, int offsetY) {
    for (int y = 0; y < source.height; y++) {
      for (int x = 0; x < source.width; x++) {
        img.Color sourcePixel = source.getPixel(x, y);

        // Define o novo Pixel na imagem de destino
        target.setPixel(x + offsetX, y + offsetY, sourcePixel);
      }
    }
  }
}
