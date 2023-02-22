import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  File? image;
  // 画像をギャラリーから選ぶ関数
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // 画像がnullの場合戻る
      if (image == null) return;

      final imageTemp = File(image.path);
      await extractExif(imageTemp);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // カメラを使う関数
  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      // 画像がnullの場合戻る
      if (image == null) return;
      
      final imageTemp = File(image.path);
      await extractExif(imageTemp);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future extractExif(image) async {
    final tags = await readExifFromBytes(await image.readAsBytes());


    if (tags.isEmpty) {
      print("No EXIF information found");
      return;
    }

    for (final entry in tags.entries) {
      print("${entry.key}: ${entry.value}");
    }
    String dateTime = tags["Image DateTime"].toString();
    print(dateTime);
    if (tags.containsKey('EXIF ApertureValue')) {
      print(tags["EXIF ApertureValue"].toString());
    }
    print(tags["EXIF ShutterSpeedValue"].toString());
    print(tags["EXIF FNumber"].toString());
    print(tags["EXIF ISOSpeedRatings: 100"].toString());
    print(tags["EXIF FocalLength: 33/10"].toString());
    print(tags["EXIF ExposureTime"].toString());
    print(tags[""].toString());
    print(tags[""].toString());
    print(tags[""].toString());
    print(tags[""].toString());
    print(tags[""].toString());
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        body: Center(
            child: Column(
          children: [
            MaterialButton(
              color: Colors.blue,
              child: const Text(
                "Pick a photo from gallery",
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                pickImage();
              },
            ),
            MaterialButton(
              color: Colors.blue,
              child: const Text(
                "Take a photo",
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                pickImageC();
              },
            ),
            SizedBox(height: 20),
            // 画像がないと文字が表示される
            image != null ? Image.file(image!) : Text("No image selected")
          ],
        )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}