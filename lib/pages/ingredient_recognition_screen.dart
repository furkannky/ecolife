import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class IngredientRecognitionScreen extends StatefulWidget {
  @override
  _IngredientRecognitionScreenState createState() => _IngredientRecognitionScreenState();
}

class _IngredientRecognitionScreenState extends State<IngredientRecognitionScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _message = "";

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _message = "Image selected!";
      });

      _recognizeIngredients();
    }
  }

  Future<void> _recognizeIngredients() async {
    // Form data oluşturuluyor
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api-endpoint.com/recognize-ingredients'),
    );

    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var data = jsonDecode(responseData);

      setState(() {
        _message = "Ingredients: ${data['ingredients'].toString()}";
      });
    } else {
      setState(() {
        _message = "Error: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ingredient Recognition')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Take a Picture'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
