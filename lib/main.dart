import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IDCardForm(),
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
  String course = '';
  String idNumber = '';
  String phoneNumber = '';
  String issueDate = '';
  String expireDate = '';
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Virtual ID Card')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a name'
                    : null,
                onChanged: (value) => setState(() => name = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a course'
                    : null,
                onChanged: (value) => setState(() => course = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ID Number'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an ID number'
                    : null,
                onChanged: (value) => setState(() => idNumber = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a phone number'
                    : null,
                onChanged: (value) => setState(() => phoneNumber = value),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Issue Date (DD-MM-YYYY)'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an issue date'
                    : null,
                onChanged: (value) => setState(() => issueDate = value),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Expire Date (DD-MM-YYYY)'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an expire date'
                    : null,
                onChanged: (value) => setState(() => expireDate = value),
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
              if (name.isNotEmpty && course.isNotEmpty && idNumber.isNotEmpty)
                IDCard(
                  name: name,
                  course: course,
                  idNumber: idNumber,
                  phoneNumber: phoneNumber,
                  issueDate: issueDate,
                  expireDate: expireDate,
                  image: _image,
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
  final String course;
  final String idNumber;
  final String phoneNumber;
  final String issueDate;
  final String expireDate;
  final File? image;

  const IDCard({
    super.key,
    required this.name,
    required this.course,
    required this.idNumber,
    required this.phoneNumber,
    required this.issueDate,
    required this.expireDate,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(image!),
                ),
              ),
            const SizedBox(height: 16),
            Text('Name: $name',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Course: $course', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('ID: $idNumber', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Phone: $phoneNumber', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Issue Date: $issueDate',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Expire Date: $expireDate',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
