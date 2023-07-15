import 'package:flutter/material.dart';
import 'package:ralali_bakery/ui/ui_cake_delete.dart';

class CakeDetailScreen extends StatelessWidget {
  final dynamic cake;

  CakeDetailScreen({required this.cake});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _deleteCake(BuildContext context) async {
    String cakeId = cake['id'];

    bool isSuccess = await CakeService.deleteCake(cakeId);

    if (isSuccess) {
      // Deletion successful
      _showSnackBar(context, 'Cake deleted');
      Navigator.pop(context);
    } else {
      // Error occurred during deletion
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete the cake.'),
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
              onPressed: () => _deleteCake(context),
              child: Text('Delete Cake'),
            ),
          ],
        ),
      ),
    );
  }
}
