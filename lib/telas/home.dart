import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voucher_app/telas/logVoucher.dart';
import 'package:voucher_app/telas/telavoucher.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    Color azulFonte = Color.fromARGB(255, 95, 130, 164);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 246, 177, 50),
              ),
              child: Text(
                'Paraty Trips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'NormalFont',
                ),
              ),
            ),

            ListTile(
              title: Text('Local V Log',
                  style: TextStyle(fontFamily: 'NormalFont')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoggVoucher(),
                  ),
                );
                // Implemente aqui o que deseja fazer quando clicar no item 1
              },
            ),
            Divider(height: 0),
            // Adicione mais ListTile conforme necessário
            ListTile(
              title: Text('Voucher DB Log',
                  style: TextStyle(fontFamily: 'NormalFont')),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 246, 177, 50),
        title: Row(
          children: [
            SizedBox(
              width: 66,
            ),
            Text(
              'Paraty Trips',
              style: TextStyle(color: Colors.white, fontFamily: 'NormalFont'),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            color: Color.fromARGB(0, 0, 0, 0),
            shadowColor: Color.fromARGB(0, 0, 0, 0),
            margin: EdgeInsets.all(10.0),
            surfaceTintColor: Color.fromARGB(0, 0, 0, 0),
            child: Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(57),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Cor da sombra
                    spreadRadius: 2, // Raio de expansão da sombra
                    blurRadius: 5, // Desfoque da sombra
                    offset: Offset(0, 3), // Deslocamento da sombra (x, y)
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Container(
                        width: 373,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(57),
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/images/voucher vazio.png',
                              ),
                              alignment: Alignment.topCenter),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                alignment: Alignment.topLeft,
                                height: 90,
                                width: 373,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(1.0, -0.8),
                                    end: Alignment(1.0, -0.0),
                                    colors: [
                                      Color.fromARGB(0, 255, 255, 255),
                                      Color.fromARGB(255, 255, 255, 255),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(57),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 18,
                                        ),
                                        Text(
                                          'Voucher',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'BoldFont'),
                                          textScaler: TextScaler.linear(1.4),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Gera um voucher com dados inseridos.',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'NormalFont'),
                                          textScaler: TextScaler.linear(1.2),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
