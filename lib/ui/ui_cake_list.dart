import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CakeListScreen extends StatefulWidget {
  @override
  _CakeListScreenState createState() => _CakeListScreenState();
}

class _CakeListScreenState extends State<CakeListScreen> {
  Future<List<dynamic>> fetchCakes() async {
    final response = await http.get(Uri.parse('https://611a268fcbf1b30017eb5527.mockapi.io/cakes'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['items'];
    } else {
      throw Exception('Failed to fetch cakes');
    }
  }

  Future<void> _refreshCakes() async {
    setState(() {
      // Reset the cakes list
    });
    await fetchCakes();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cake list refreshed'),
      ),
    );
  }

  void _navigateToCakeDetail(BuildContext context, dynamic cake) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CakeDetailScreen(cake: cake)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ralali Bakery'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCakes,
        child: FutureBuilder<List<dynamic>>(
          future: fetchCakes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching cakes: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final cakes = snapshot.data!;
              return ListView.builder(
                itemCount: cakes.length,
                itemBuilder: (context, index) {
                  final cake = cakes[index];
                  return ListTile(
                    leading: Image.network(
                      cake['image'],
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cake['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cake['description']),
                        SizedBox(height: 8),
                        Text('Rating: ${cake['rating']}'),
                        Text('Created At: ${cake['created_at']}'),
                        Text('Updated At: ${cake['updated_at']}'),
                        Text('ID: ${cake['id']}'),
                      ],
                    ),
                    onTap: () {
                      _navigateToCakeDetail(context, cake);
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('No cakes available'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCakeScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

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
      // You can display a success message or navigate back to the cake list screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cake Submitted'),
        ),
      );
      Navigator.pop(context);
    } else {
      // Failed to add the cake
      // You can display an error message or handle the failure scenario accordingly
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

class CakeDetailScreen extends StatelessWidget {
  final dynamic cake;

  CakeDetailScreen({required this.cake});

  @override
  Widget build(BuildContext context) {
    void _deleteCake() async {
      String cakeId = cake['id'];

      // Call the API endpoint to delete the cake
      var url = Uri.parse('https://611a268fcbf1b30017eb5527.mockapi.io/cakes/$cakeId');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        // Deletion successful
        // You can display a success message or perform any additional tasks
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cake Deleted'),
          ),
        );

        // Navigate back to the CakeListScreen
        Navigator.pop(context);
      } else {
        // Error occurred during deletion
        // You can display an error message or perform any error handling
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cake Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cake['title'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Image.network(
              cake['image'],
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              cake['description'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Rating: ${cake['rating']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Created At: ${cake['created_at']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Updated At: ${cake['updated_at']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'ID: ${cake['id']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _deleteCake,
              child: Text('Delete Cake'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ralali Bakery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CakeListScreen(),
    );
  }
}
