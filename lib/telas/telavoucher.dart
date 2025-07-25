import 'dart:async';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CustomNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();
    final String strippedValue = newValue.text.replaceAll(
        RegExp(r'\D'), ''); // Remove todos os caracteres não numéricos
    int count = 0;

    for (int i = 0; i < strippedValue.length; i++) {
      if (count == 4 || count == 7) {
        newText.write('.'); // Adiciona um ponto
        count++;
      }
      if (count == 10) {
        newText.write('-'); // Adiciona um traço
        count++;
      }
      newText.write(strippedValue[i]);
      count++;
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class CustomDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();
    final String strippedValue = newValue.text.replaceAll(
        RegExp(r'\D'), ''); // Remove todos os caracteres não numéricos
    int count = 0;

    for (int i = 0; i < strippedValue.length; i++) {
      if (count == 2 || count == 5) {
        newText.write('/'); // Adiciona uma barra
        count++;
      }
      newText.write(strippedValue[i]);
      count++;
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
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

  Future<bool> _saveImage2() async {
    // Lógica para salvar a imagem aqui
    // Retorne true se a imagem for salva com sucesso, caso contrário, retorne false
    return true; // Exemplo: retornando true para simular sucesso
  }

  String generateUuid() {
    final random = Random();
    final int1 = random.nextInt(4294967296); // 2^32
    final int2 = random.nextInt(4294967296);
    return '${int1.toRadixString(16).padLeft(8, '0')}-${int2.toRadixString(16).padLeft(8, '0')}';
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
            onPressed: () async {
              DatabaseReference hey =
                  FirebaseDatabase.instance.ref().child("Gen Vouchers/Voucher");
              _saveImage();
              DatabaseReference nehey = hey.push();

              await nehey.set(
                {
                  "Nº Voucher": "Nº$nDeRecibo",
                  "Nº ID": "Nº${generateUuid()}",
                  "Data Ems": "$dataDeEmissao",
                  "Data Passeio": "$dataDePasseio",
                  "Qtd Int": "${qtdInt ?? '0'}",
                  "Qtd M": "${qtdMeia ?? '0'}",
                  "Qtd F": "${qtdFree ?? '0'}",
                  "Tipo Passeio": "${tipoDePasseio.toLowerCase()}",
                  "Valor pago": "$valorPago",
                  "Valor a receber": "$valorAReceber",
                  "Valor total": "$valorTotal",
                  "Timestamp": "${DateTime.now()}",
                },
              ).then((_) {
                print('Novo item adicionado com sucesso.');
              }).catchError((error) {
                print('Erro ao adicionar novo item: $error');
              });
            },
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
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    nDeRecibo = value;
                  });
                },
                inputFormatters: [
                  CustomNumberInputFormatter(),
                  LengthLimitingTextInputFormatter(13)
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Recibo',
                    prefixText: 'Nº',
                    hintText: 'Ano.Dia.Mês-ID'),
              ),
              TextField(
                inputFormatters: [
                  CustomDateInputFormatter(),
                  LengthLimitingTextInputFormatter(10)
                ],
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    dataDeEmissao = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Data de emissão',
                  hintText: '31/12/2024',
                ),
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
                inputFormatters: [
                  CustomDateInputFormatter(),
                  LengthLimitingTextInputFormatter(10)
                ],
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
    _saveImage2();
  }

  void _saveImageInternal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtenha o último número progressivo salvo, padrão para 1 se não existir
    int lastProgressiveNumber = prefs.getInt('progressiveNumber') ?? 1;

    // Atualize o número progressivo para o próximo valor
    int nextProgressiveNumber = lastProgressiveNumber + 1;
    prefs.setInt('progressiveNumber', nextProgressiveNumber);

    // Defina o nome do arquivo usando as informações disponíveis e o número progressivo
    String fileName =
        '${dataDeEmissao}_${tipoDePasseio}_${nDeRecibo}_$nextProgressiveNumber.png';

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

      // Save the resized image to the gallery with the custom file name
      Uint8List resizedBytes =
          (await resizedImage.toByteData(format: ui.ImageByteFormat.png))!
              .buffer
              .asUint8List();
      await ImageGallerySaver.saveImage(resizedBytes, name: fileName);

      String directoryPath = '/data/user/0/com.example.voucher_app/app_flutter';
      Directory directory = Directory(directoryPath);
      if (!await directory.exists()) {
        directory.createSync(recursive: true);
      }
      // Salve a imagem no diretório específico
      String imagePath = '$directoryPath/$fileName';
      File(imagePath).writeAsBytesSync(pngBytes);

      // Exibir a SnackBar após salvar a imagem
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ui.Color.fromARGB(255, 27, 27, 57),
          content: Text('Imagem salva com sucesso como $fileName'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ui.Color.fromARGB(255, 255, 0, 0),
          content: Text('Erro ao salvar imagem!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
