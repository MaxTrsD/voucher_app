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
import 'package:voucher_app/telas/telavoucher.dart';

class LoggVoucher extends StatefulWidget {
  const LoggVoucher({Key? key}) : super(key: key);

  @override
  State<LoggVoucher> createState() => _LoggVoucherState();
}

class _LoggVoucherState extends State<LoggVoucher> {
  final TextEditingController _searchController = TextEditingController();
  List<File> _filteredFiles = [];

  clearN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(
        'progressiveNumber', 0); // Definir lastProgressiveNumber como 0

    setState(() {
      // Limpar os campos de string
      _searchController.clear();
      _filteredFiles.clear();
      searchImages();
    });
  }

  clearB() async {
    setState(() {
      // Limpar os campos de string
      _clearPicturesFolder();
      searchImages();
    });
  }

  @override
  void initState() {
    super.initState();
    searchImages();
  }

  Future<void> searchImages() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    if (appDocDir != null) {
      Directory picturesFolder =
          Directory('/data/user/0/com.example.voucher_app/app_flutter');
      if (await picturesFolder.exists()) {
        print(appDocDir);
        List<FileSystemEntity> files = picturesFolder.listSync();
        List<File> pngFiles = files
            .where((file) =>
                file is File && file.path.toLowerCase().endsWith('.png'))
            .map((file) => File(file.path))
            .toList();
        print(files);
        setState(() {
          _filteredFiles = pngFiles;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 246, 177, 50),
        title: Text(
          'Logs',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  color: ui.Color.fromARGB(255, 246, 177, 50),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: clearN,
                    style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(Size(200, 50))),
                    child: Text(
                      'Limpar Nº',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  color: ui.Color.fromARGB(255, 246, 177, 50),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color:
                                          ui.Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Ao confirmar você apagará todo histórico de vouchers do App!!',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.black,
                                                fontFamily: 'NormalFont',
                                                wordSpacing: 10,
                                                decoration:
                                                    TextDecoration.none),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          height: 100,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: Colors.red,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    fixedSize:
                                                        MaterialStatePropertyAll(
                                                      Size(200, 100),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    clearB();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Confirmar!',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(Size(200, 50))),
                    child: Text(
                      'Limpar Log',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar Vouchers...',
              ),
              onChanged: (value) {
                String query = value.toLowerCase();
                setState(() {
                  _filteredFiles = _filteredFiles
                      .where((file) => file.path.toLowerCase().contains(query))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredFiles[index].path.split('/').last),
                  onTap: () {
                    // Implemente a lógica para abrir a imagem quando o ListTile for pressionado
                    _showImageDialog(_filteredFiles[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.file(imageFile),
      ),
    );
  }
}

void _clearPicturesFolder() async {
  Directory picturesFolder =
      Directory('/data/user/0/com.example.voucher_app/app_flutter');
  if (await picturesFolder.exists()) {
    List<FileSystemEntity> files = picturesFolder.listSync();
    for (var file in files) {
      if (file is File) {
        file.deleteSync(); // Deletar o arquivo
      }
    }
  }
}
