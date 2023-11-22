import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class TelaVoucher extends StatefulWidget {
  const TelaVoucher({super.key});

  @override
  State<TelaVoucher> createState() => _TelaVoucherState();
}

class _TelaVoucherState extends State<TelaVoucher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 213, 4),
        title: Center(
          child: const Text(
            'Voucher',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
