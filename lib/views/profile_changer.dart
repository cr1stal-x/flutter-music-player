import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Auth.dart';
import '../testClient.dart';

class EditProfileCoverPage extends StatefulWidget {
  @override
  _EditProfileCoverPageState createState() => _EditProfileCoverPageState();
}

class _EditProfileCoverPageState extends State<EditProfileCoverPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    final client = Provider.of<CommandClient>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    final bytes = await _selectedImage!.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await client.sendCommand(
      'Update',
      extraData: {"profile_cover": base64Image},
    );

    if (response['status-code'] == 200) {
      auth.updateField("profileCover", base64Image);
    } else {
      print("Update failed: ${response['message']}");
  }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile Cover")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200)
                : Icon(Icons.image, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Select from Gallery"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (){
                _uploadImage();
                Navigator.pop(context);
              },
              child: Text("Upload to Server"),
            ),
          ],
        ),
      ),
    );
  }
}
