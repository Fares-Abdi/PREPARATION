import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanini_frontend/models/colors.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationsPage extends StatefulWidget {
  final String userId;

  const NotificationsPage({required this.userId, super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String? selectedUserId;

  Future<List<Map<String, dynamic>>> _getUsers() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs
        .where((doc) => doc.id != widget.userId) // Exclude current user
        .map((doc) => {
              'id': doc.id,
              'name': doc.data()['name'] ?? 'Unknown User',
            })
        .toList();
  }

  Future<String?> _getDeviceToken(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userDoc.data()?['deviceToken'] as String?;
    } catch (e) {
      print('Error fetching device token: $e');
      return null;
    }
  }

  Future<String> _getAccessToken() async {
    try {
      // Load the service account JSON
      final serviceAccountJson = await rootBundle.loadString('assets/credentials/test1.json');

      final credentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
      final client = await auth.clientViaServiceAccount(credentials, [
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
      ]);

      final accessToken = client.credentials.accessToken.data;
      client.close();
      return accessToken;
    } catch (e) {
      print('Error getting access token: $e');
      throw Exception('Failed to get access token');
    }
  }

  Future<void> _sendNotification(BuildContext context) async {
    if (selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a user first')),
      );
      return;
    }

    try {
      final deviceToken = await _getDeviceToken(selectedUserId!);
      if (deviceToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected user has no device token')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sending notification...')),
      );

      try {
        final serverKey = await _getAccessToken();
        final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/mobai-4aef6/messages:send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverKey',
          },
          body: jsonEncode({
            'message': {
              'token': deviceToken,
              'notification': {
                'title': 'New Message',
                'body': 'Hi! You received a greeting!',
              },
              'data': {
                'type': 'greeting',
                'senderId': widget.userId,
                'timestamp': DateTime.now().toIso8601String(),
              }
            }
          }),
        );

        if (response.statusCode == 200) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification sent successfully')),
            );
          }
        } else {
          throw Exception('Failed to send notification: ${response.body}');
        }
      } catch (e) {
        print('Error sending notification: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send notification')),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send notification')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Send Greeting',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _getUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No users found');
                }

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select User',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedUserId,
                  items: snapshot.data!.map((user) {
                    return DropdownMenuItem<String>(
                      value: user['id'],
                      child: Text(user['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUserId = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendNotification(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Send Greeting'),
            ),
          ],
        ),
      ),
    );
  }
}
