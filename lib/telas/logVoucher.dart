import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LoggVoucher extends StatefulWidget {
  const LoggVoucher({Key? key}) : super(key: key);

  @override
  State<LoggVoucher> createState() => _LoggVoucherState();
}

class _LoggVoucherState extends State<LoggVoucher> {
  final TextEditingController _searchController = TextEditingController();
  List<File> _filteredFiles = [];

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
        backgroundColor: Color.fromARGB(255, 246, 177, 50),
        title: Text('Logs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search PNG files...',
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
