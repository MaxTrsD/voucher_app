import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _globalKey = GlobalKey();

  String nomesDeClientes = '';
  String qtdInt = '0';
  String qtdMeia = '0';
  String qtdFree = '0';
  String nDeRecibo = '';
  String tipoDePasseio = '';
  String dataDePasseio = '';
  String dataDeEmissao = '';
  String valorPago = '';
  String valorAReceber = '';
  String valorTotal = '';
  Color azulFonte = Color.fromARGB(255, 95, 130, 164);

  @override
  Widget build(BuildContext context) {
    if (tipoDePasseio == '' || tipoDePasseio.isEmpty) {
      tipoDePasseio = '(Tipo de passeio)';
    } else {
      tipoDePasseio = tipoDePasseio;
    }

    if (dataDePasseio == '' || dataDePasseio.isEmpty) {
      dataDePasseio = '(Data)';
    } else {
      dataDePasseio = dataDePasseio;
    }
    if (nDeRecibo == '' || nDeRecibo.isEmpty) {
      nDeRecibo = 'Ano.Dia.Mês-ID';
    } else {
      nDeRecibo = nDeRecibo;
    }
    if (valorTotal == '' || valorTotal.isEmpty) {
      valorTotal = '0,00';
    } else {
      valorTotal = valorTotal;
    }
    if (valorPago == '' || valorPago.isEmpty) {
      valorPago = '0,00';
    } else {
      valorPago = valorPago;
    }
    if (valorAReceber == '' || valorAReceber.isEmpty) {
      valorAReceber = '0,00';
    } else {
      valorAReceber = valorAReceber;
    }
    if (qtdInt == '' || qtdInt.isEmpty) {
      qtdInt = '0';
    } else {
      qtdInt = qtdInt;
    }
    if (qtdMeia == '' || qtdMeia.isEmpty) {
      qtdMeia = '0';
    } else {
      qtdMeia = qtdMeia;
    }
    if (qtdFree == '' || qtdFree.isEmpty) {
      qtdFree = '0';
    } else {
      qtdFree = qtdFree;
    }

    String valorTt = ' R\$$valorTotal';
    String valorAR = ' R\$$valorAReceber';
    String valorPg = ' R\$$valorPago';
    String referentePasseio = tipoDePasseio;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: Text(
          'Voucher',
          style: TextStyle(color: Colors.white, fontFamily: 'NormalFont'),
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
                      Image.asset('assets/images/voucher vazio.png',
                          width: 300, height: 200),
                      // Display customer name and payment info
                      Positioned(
                        top: 90,
                        left: 40,
                        child: Text(
                          nomesDeClientes,
                          style: TextStyle(
                              color:
                                  const ui.Color.fromARGB(255, 95, 130, 164)),
                        ),
                      ),
                      Positioned(
                        top: 150,
                        left: 30,
                        child: Text(
                          dataDeEmissao,
                          style: TextStyle(
                              color: ui.Color.fromARGB(255, 255, 255, 255),
                              fontSize: 9,
                              fontFamily: 'NormalFont'),
                        ),
                      ),
                      Positioned(
                        top: 119,
                        left: 150,
                        child: Text(
                          'Paraty, $dataDeEmissao.',
                          style: TextStyle(
                              color: ui.Color.fromARGB(255, 0, 0, 0),
                              fontSize: 8,
                              fontFamily: 'NormalFont'),
                        ),
                      ),
                      Positioned(
                        top: 85,
                        left: 120,
                        child: Text(
                          'Referente ao ${tipoDePasseio.toLowerCase()} em $dataDePasseio.',
                          style: TextStyle(
                              color: azulFonte,
                              fontSize: 9,
                              fontFamily: 'BoldFont'),
                        ),
                      ),
                      Positioned(
                        top: 21.5,
                        left: 146,
                        child: Text(
                          nDeRecibo,
                          style: TextStyle(
                              color: azulFonte,
                              fontSize: 9,
                              fontFamily: 'BoldFont'),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 20,
                        child: Text(
                          valorTt,
                          style: TextStyle(
                              color: ui.Color.fromARGB(255, 255, 255, 255),
                              fontSize: 9,
                              fontFamily: 'NormalFont'),
                        ),
                      ),
                      Positioned(
                        top: 41.3,
                        left: 16,
                        child: Text(
                          qtdInt,
                          style: TextStyle(
                              color: ui.Color.fromARGB(255, 255, 255, 255),
                              fontSize: 9,
                              fontFamily: 'NormalFont'),
                        ),
                      ),
                      Positioned(
                        top: 51.2,
                        left: 16,
                        child: Text(
                          qtdMeia,
                          style: TextStyle(
                              color: ui.Color.fromARGB(255, 255, 255, 255),
                              fontSize: 9,
                              fontFamily: 'NormalFont'),
                        ),
                      ),
                      Positioned(
                        top: 61.5,
                        left: 16,
                        child: Text(
                          qtdFree,
                          style: TextStyle(
                              color: ui.Color.fromARGB(255, 255, 255, 255),
                              fontSize: 9,
                              fontFamily: 'NormalFont'),
                        ),
                      ),
                      Positioned(
                        top: 105,
                        left: 15,
                        child: Text(
                          tipoDePasseio,
                          style: TextStyle(
                              color: ui.Color.fromARGB(255, 255, 255, 255),
                              fontSize: 9,
                              fontFamily: 'NormalFont'),
                        ),
                      ),
                      Positioned(
                        top: 22,
                        left: 330,
                        child: Text(
                          valorAR,
                          style: TextStyle(
                              color: const ui.Color.fromARGB(255, 95, 130, 164),
                              fontSize: 9,
                              fontFamily: 'BoldFont'),
                        ),
                      ),
                      Positioned(
                        top: 9.5,
                        left: 330,
                        child: Text(
                          valorPg,
                          style: TextStyle(
                              color: const ui.Color.fromARGB(255, 95, 130, 164),
                              fontSize: 9,
                              fontFamily: 'BoldFont'),
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
                    nDeRecibo = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Recibo'),
              ),
              TextField(
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    dataDeEmissao = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Data de emissão'),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    nomesDeClientes = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Nome do Cliente'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    qtdInt = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Qt.Inteira'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    qtdMeia = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Qt.Meia'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    qtdFree = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Qt.Free'),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    tipoDePasseio = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo de passeio'),
              ),
              TextField(
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    dataDePasseio = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Data de passeio'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    valorPago = value;
                  });
                },
                decoration:
                    InputDecoration(labelText: 'Valor pago', prefixText: 'R\$'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    valorAReceber = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Valor a receber', prefixText: 'R\$'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    valorTotal = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Valor total', prefixText: 'R\$'),
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
              SizedBox(
                height: 100,
              )
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
