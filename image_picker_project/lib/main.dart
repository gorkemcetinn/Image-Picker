import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker imagePicker = ImagePicker();
  List<File> dosyalar = []; // Seçilen fotoğrafları saklayan liste

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text("Image Picker Kullanımı"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          pickSingleImage(ImageSource.gallery); // Galeriden tek fotoğraf seçme
                          Navigator.pop(context);
                        },
                        title: const Text("Galeriden Seç"),
                      ),
                      ListTile(
                        onTap: () async {
                          var photos = await imagePicker.pickMultiImage(
                            maxWidth: 200,
                            maxHeight: 200,
                            imageQuality: 80,
                          );
                          if (photos != null) {
                            setState(() {
                              dosyalar = photos.map((photo) => File(photo.path)).toList(); // Çoklu fotoğraf seçimi
                            });
                          }
                          Navigator.pop(context);
                        },
                        title: const Text("Fotoğraflar Seç"),
                      ),
                      ListTile(
                        onTap: () {
                          pickSingleImage(ImageSource.camera); // Kameradan tek fotoğraf çekme
                          Navigator.pop(context);
                        },
                        title: const Text("Kameradan Seç"),
                      )
                    ],
                  ),
                );
              },
              child: Text("Pick Image"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  dosyalar.clear(); // Fotoğraf listesini boşaltma
                });
              },
              child: Text("Listeyi Boşalt"),
            ),
            dosyalar.isEmpty
                ? Container()
                : Expanded(
              child: ListView.builder(
                itemCount: dosyalar.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      dosyalar[index], // Fotoğrafları listede görüntüleme
                      width: 200,
                      height: 200,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickSingleImage(ImageSource source) async {
    var photo = await imagePicker.pickImage(source: source);
    if (photo != null) {
      setState(() {
        dosyalar.add(File(photo.path)); // Tek fotoğraf seçimini listeye ekleme
      });
    }
  }
}
