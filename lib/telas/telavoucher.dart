import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget blueBtn(VoidCallback onPressed) {
      return Container(
        height: 50,
        width: 180,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 246, 177, 50),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: TextButton(
            onPressed: _saveImage,
            style:
                ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(200, 50))),
            child: Text(
              'Salvar Imagem',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    Widget greyBtn(VoidCallback onPressed) {
      return Container(
        height: 50,
        width: 180,
        decoration: BoxDecoration(
          color: ui.Color.fromARGB(99, 27, 27, 57),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: TextButton(
            onPressed: () {},
            style:
                ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(200, 50))),
            child: Text(
              'Salvar Imagem',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    clearFields() {
      setState(
        () {
          // Limpar os campos de string
          nomesDeClientes = '';
          qtdInt = '0';
          qtdMeia = '0';
          qtdFree = '0';
          nDeRecibo = '';
          tipoDePasseio = '';
          dataDePasseio = '';
          dataDeEmissao = '';
          valorPago = '';
          valorAReceber = '';
          valorTotal = '';
        },
      );
    }

    Widget clearBtn(VoidCallback onPressed) {
      return Container(
        height: 50,
        width: 180,
        decoration: BoxDecoration(
          color: ui.Color.fromARGB(255, 110, 110, 110),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: TextButton(
            onPressed: clearFields,
            style:
                ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(200, 50))),
            child: Text(
              'Limpar Voucher',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    String getMonthName(String dateString) {
      List<String> parts = dateString.split('/');

      if (parts.length != 3) {
        return '(Mês)';
      }

      int month = int.tryParse(parts[1]) ?? 0;
      switch (month) {
        case 01:
          return 'Janeiro';
        case 02:
          return 'Fevereiro';
        case 03:
          return 'Março';
        case 04:
          return 'Abril';
        case 05:
          return 'Maio';
        case 06:
          return 'Junho';
        case 07:
          return 'Julho';
        case 08:
          return 'Agosto';
        case 09:
          return 'Setembro';
        case 10:
          return 'Outubro';
        case 11:
          return 'Novembro';
        case 12:
          return 'Dezembro';
        default:
          return '(Mês)';
      }
    }

    String getDay(String dateString) {
      // Separar a string em partes (dia, mês, ano)
      List<String> parts = dateString.split('/');

      if (parts.length != 3) {
        return '(Dia)';
      }

      return parts[0];
    }

    String getYear(String dateString) {
      // Separar a string em partes (dia, mês, ano)
      List<String> parts = dateString.split('/');

      if (parts.length != 3) {
        return '(Ano)';
      }

      return parts[2];
    }

    String valorTt = ' R\$$valorTotal';
    String valorAR = ' R\$$valorAReceber';
    String valorPg = ' R\$$valorPago';
    String referentePasseio = tipoDePasseio;

    Widget getButtonBasedOnEmptyFields() {
      // Verificar se algum dos campos está vazio
      if (nDeRecibo.isEmpty ||
          tipoDePasseio.isEmpty ||
          dataDePasseio.isEmpty ||
          dataDeEmissao.isEmpty ||
          valorPago.isEmpty ||
          valorAReceber.isEmpty ||
          valorTotal.isEmpty) {
        // Se algum campo estiver vazio, retornar o botão cinza

        return greyBtn(() {});
      } else {
        // Caso contrário, retornar o botão azul
        return blueBtn(_saveImage);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 246, 177, 50),
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
                  height: 176.6,
                  color: ui.Color.fromARGB(0, 0, 0, 0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      // Display the base voucher image
                      Image.asset('assets/images/voucher vazio.png',
                          width: 300, height: 200),
                      // Display customer name and payment info
                      Positioned(
                        top: 35,
                        left: 140,
                        child: Text(
                          nomesDeClientes,
                          style: TextStyle(
                              color: const ui.Color.fromARGB(255, 95, 130, 164),
                              fontFamily: 'BoldFont',
                              fontSize: 6),
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
                        top: 118,
                        left: 148,
                        child: Text(
                          'Paraty, ${getDay(dataDeEmissao)} de ${getMonthName(dataDeEmissao)} de ${getYear(dataDeEmissao)}.',
                          style: TextStyle(
                              color: ui.Color.fromARGB(255, 59, 59, 59),
                              fontSize: 8,
                              fontFamily: 'NormalFont'),
                        ),
                      ),
                      Positioned(
                        top: 83,
                        left: 116,
                        child: Text(
                          'Referente ao ${tipoDePasseio.toLowerCase()} em ${getDay(dataDePasseio)} de ${getMonthName(dataDePasseio)} de ${getYear(dataDePasseio)}.',
                          style: TextStyle(
                              color: azulFonte,
                              fontSize: 8,
                              fontFamily: 'BoldFont'),
                        ),
                      ),
                      Positioned(
                        top: 20.9,
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
                        top: 14,
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
                        top: 41.0,
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
                        top: 50.9,
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
                        top: 61.2,
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
                        top: 21,
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
                        top: 8.4,
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
                decoration: InputDecoration(
                    labelText: 'Recibo',
                    prefixText: 'Nº',
                    hintText: '2024.31.12-0'),
              ),
              TextField(
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    dataDeEmissao = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Data de emissão', hintText: '31/12/2024'),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    nomesDeClientes = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Nomes de Clientes'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(2)],
                onChanged: (value) {
                  setState(() {
                    qtdInt = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Qt.Inteira'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(2)],
                onChanged: (value) {
                  setState(() {
                    qtdMeia = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Qt.Meia'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(2)],
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
                decoration: InputDecoration(
                    labelText: 'Data de passeio', hintText: '31/12/2024'),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    valorPago = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Valor pago',
                    prefixText: 'R\$',
                    hintText: '0,00'),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    valorAReceber = value;
                  });
                },
                decoration: const InputDecoration(
                    labelText: 'Valor a receber',
                    prefixText: 'R\$',
                    hintText: '0,00'),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    valorTotal = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Valor total',
                    prefixText: 'R\$',
                    hintText: '0,00'),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    clearBtn(() {}),
                    SizedBox(width: 5),
                    getButtonBasedOnEmptyFields(),
                  ],
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
          targetHeight: 950, targetWidth: 2000);
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
