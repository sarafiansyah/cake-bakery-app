import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCakeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Cake'),
      ),
      body: AddCakeForm(),
    );
  }
}

class AddCakeForm extends StatefulWidget {
  @override
  _AddCakeFormState createState() => _AddCakeFormState();
}

class _AddCakeFormState extends State<AddCakeForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String imageLink = '';

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addCake() async {
    final apiUrl = 'https://611a268fcbf1b30017eb5527.mockapi.io/cakes';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'title': title,
        'description': description,
        'image': imageLink,
      },
    );

    if (response.statusCode == 201) {
      // Cake added successfully
      _showSnackBar(context, 'Cake Submitted');
      Navigator.pop(context);
    } else {
      // Failed to add the cake
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add the cake.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the title';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Image Link',
              ),
              onChanged: (value) {
                setState(() {
                  imageLink = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the description';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  addCake();
                }
              },
              child: Text('Add Cake'),
            ),
          ],
        ),
      ),
    );
  }
}
