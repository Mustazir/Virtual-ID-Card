import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IDCardForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IDCardForm extends StatefulWidget {
  const IDCardForm({super.key});

  @override
  _IDCardFormState createState() => _IDCardFormState();
}

class _IDCardFormState extends State<IDCardForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String idNumber = '';
  String semester = '';
  String email = '';
  Uint8List? _imageBytes;

  // Image upload for web
  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          _imageBytes = reader.result as Uint8List;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom ID Card'),
        backgroundColor: const Color.fromARGB(255, 252, 249, 249),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a name' : null,
                onChanged: (value) => setState(() => name = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ID Number'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter ID number' : null,
                onChanged: (value) => setState(() => idNumber = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Semester'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter semester' : null,
                onChanged: (value) => setState(() => semester = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter email' : null,
                onChanged: (value) => setState(() => email = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Picture'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    setState(() {});
                  }
                },
                child: const Text('Generate ID Card'),
              ),
              const SizedBox(height: 30),
              if (name.isNotEmpty &&
                  idNumber.isNotEmpty &&
                  semester.isNotEmpty &&
                  email.isNotEmpty)
                IDCard(
                  name: name,
                  idNumber: idNumber,
                  semester: semester,
                  email: email,
                  imageBytes: _imageBytes,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class IDCard extends StatelessWidget {
  final String name;
  final String idNumber;
  final String semester;
  final String email;
  final Uint8List? imageBytes;

  const IDCard({
    super.key,
    required this.name,
    required this.idNumber,
    required this.semester,
    required this.email,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ID Card',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[800],
                backgroundImage: imageBytes != null ? MemoryImage(imageBytes!) : null,
                child: imageBytes == null
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Name:',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              name,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'ID:',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              idNumber,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Current Semester:',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              semester,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
