import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hanini_frontend/localization/app_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:googleapis_auth/auth_io.dart';



// // Add this method to fetch device token
// Future<String?> _getDeviceToken(String userId) async {
//   try {
//     final userDoc =
//         await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     return userDoc.data()?['deviceToken'] as String?;
//   } catch (e) {
//     print('Error fetching device token: $e');
//     return null;
//   }
// }

// class PushNotificationService {
//   static Future<String> getAccessToken() async {
//     // Load the service account JSON
//     final serviceAccountJson =
//         await rootBundle.loadString('assets/credentials/test.json');

//     // Define the required scopes
//     List<String> scopes = [
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];

//     // Create a client using the service account credentials
//     final auth.ServiceAccountCredentials credentials =
//         auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

//     final auth.AuthClient client =
//         await auth.clientViaServiceAccount(credentials, scopes);

//     // Retrieve the access token
//     final String accessToken = client.credentials.accessToken.data;

//     // Close the client to avoid resource leaks
//     client.close();

//     return accessToken;
//   }

//   static Future<void> sendNotification(String deviceToken, String title,
//       String body, Map<String, dynamic> data) async {
//     final String serverKey = await getAccessToken();
//     String endpointFirebaseCloudMessaging =
//         'https://fcm.googleapis.com/v1/projects/hanini-2024/messages:send';

//     final Map<String, dynamic> message = {
//       'message': {
//         'token': deviceToken,
//         'notification': {
//           'title': title,
//           'body': body,
//         },
//         'data': data,
//       }
//     };

//     final http.Response response = await http.post(
//       Uri.parse(endpointFirebaseCloudMessaging),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $serverKey',
//       },
//       body: jsonEncode(message),
//     );

//     if (response.statusCode == 200) {
//       print('Notification sent successfully');
//     } else {
//       print('Failed to send notification');
//       print('Response: ${response.body}');
//     }
//   }
// }


class GoogleDriveService {
  static const String _folderID =
      "1CXyab655easZvKBvHNR67QAZOXqNraIH"; // Your folder ID

  Future<drive.DriveApi> getDriveApi() async {
    try {
      // Load credentials from assets
      final String credentials = await rootBundle
          .loadString('assets/credentials/test.json');

      final accountCredentials =
          ServiceAccountCredentials.fromJson(credentials);
      final client = await clientViaServiceAccount(
        accountCredentials,
        [drive.DriveApi.driveScope],
      );

      return drive.DriveApi(client);
    } catch (e) {
      throw Exception('Failed to initialize Drive API: $e');
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      final driveApi = await getDriveApi();
      final fileName = path.basename(file.path);

      // Prepare drive file metadata
      var driveFile = drive.File()
        ..name = fileName
        ..parents = [_folderID];

      // Upload file
      final response = await driveApi.files.create(
        driveFile,
        uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
      );

      final fileId = response.id;
      if (fileId == null) {
        throw Exception('Failed to get file ID after upload');
      }

      // Set file permissions to public
      final permission = drive.Permission()
        ..role = "reader"
        ..type = "anyone";
      await driveApi.permissions.create(permission, fileId);

      // Return the public URL
      return "https://drive.google.com/uc?id=$fileId";
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final driveApi = await getDriveApi();

      // Extract file ID from URL
      final uri = Uri.parse(fileUrl);
      final fileId = uri.queryParameters['id'];

      if (fileId == null) {
        throw Exception('Invalid file URL');
      }

      // Delete the file
      await driveApi.files.delete(fileId);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
}

class SimpleUserProfile extends StatefulWidget {
  const SimpleUserProfile({Key? key}) : super(key: key);

  @override
  State<SimpleUserProfile> createState() => _SimpleUserProfileState();
}

class _SimpleUserProfileState extends State<SimpleUserProfile> {
  final _driveService = GoogleDriveService();
  final double profileHeight = 150;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = '';
  String userEmail = '';
  String userPhotoUrl = '';
  String aboutMe = '';
  bool isEditMode = false;
  bool isLoading = true;
  bool hasError = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Move the data fetching to after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserData();
    });
  }

  Future<void> fetchUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (mounted) {
          setState(() {
            if (userDoc.exists) {
              final data = userDoc.data() as Map<String, dynamic>;
              userName = data['name'] ?? 'Anonymous';
              userEmail = data['email'] ?? 'No email';
              userPhotoUrl = data['photoURL'] ?? '';
              aboutMe = data['aboutMe'] ?? 'Tell us about yourself';
              nameController.text = userName;
              aboutController.text = aboutMe;
            } else {
              // Handle case where user document doesn't exist
              userName = user.displayName ?? 'Anonymous';
              userEmail = user.email ?? 'No email';
              userPhotoUrl = user.photoURL ?? '';
              aboutMe = 'Tell us about yourself';
              // Create a new user document
              _firestore.collection('users').doc(user.uid).set({
                'name': userName,
                'email': userEmail,
                'photoURL': userPhotoUrl,
                'aboutMe': aboutMe,
              });
            }
            isLoading = false;
          });
        }
      } else {
        // Handle case where no user is logged in
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    }
  }

  Future<void> saveUserData() async {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return;

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Update Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'name': userName,
          'aboutMe': aboutMe,
        });

        // Update FirebaseAuth user profile
        await user.updateDisplayName(userName);
        await user.reload(); // Refresh the current user
        debugPrint(localizations.userDataUpdatedSuccessfully);
      }
    } catch (e) {
      debugPrint(localizations.errorSavingUserData + '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? localization = AppLocalizations.of(context);

    if (localization == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(localization.error),
              ElevatedButton(
                onPressed: () => fetchUserData(),
                child: Text(localization.retry),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 50),
                    buildTop(localization),
                    const SizedBox(height: 30),
                    buildProfileInfo(localization),
                    const SizedBox(height: 60),
                  ],
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: GestureDetector(
                    onTap: toggleEditMode,
                    child: Container(
                      height: 56, // Match default FAB size
                      width: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade700,
                            Colors.purple.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        isEditMode ? Icons.check : Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void toggleEditMode() {
    setState(() {
      if (isEditMode) {
        // Save changes
        userName = nameController.text;
        aboutMe = aboutController.text;
        saveUserData();
      }
      isEditMode = !isEditMode;
    });
  }

  Future<void> pickNewProfilePicture() async {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );
      }

      // Upload new image to Drive
      final file = File(pickedFile.path);
      final fileUrl = await _driveService.uploadFile(file);

      // Get current user
      final User? user = _auth.currentUser;
      if (user == null) throw Exception(localizations.noUserLoggedIn);

      // Delete old photo from Drive if it exists
      if (userPhotoUrl.startsWith('https://drive.google.com')) {
        try {
          await _driveService.deleteFile(userPhotoUrl);
        } catch (e) {
          debugPrint('${localizations.errorDeletingOldProfilePicture}$e');
        }
      }

      // Update Firestore and local state
      await _firestore.collection('users').doc(user.uid).update({
        'photoURL': fileUrl,
      });

      setState(() {
        userPhotoUrl = fileUrl;
      });

      // Close loading indicator
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('${localizations.errorUpdatingProfilePicture}$e');
      if (mounted) {
        Navigator.of(context).pop(); // Close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${localizations.errorUpdatingProfilePicture}$e')),
        );
      }
    }
  }

  Widget buildTop(AppLocalizations localization) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: profileHeight / 2,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: userPhotoUrl.isNotEmpty
                  ? NetworkImage(userPhotoUrl) as ImageProvider
                  : const AssetImage('assets/images/default_profile.png'),
            ),
            if (isEditMode)
              GestureDetector(
                onTap: () {
                  pickNewProfilePicture();
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        isEditMode
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: localization.name, // Use localization
                  ),
                ),
              )
            : Text(
                userName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
        const SizedBox(height: 6),
        Text(
          userEmail,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget buildProfileInfo(AppLocalizations localization) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.aboutMe, // Use localization
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              isEditMode
                  ? TextField(
                      controller: aboutController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: localization.aboutMe, // Use localization
                      ),
                    )
                  : Text(
                      aboutMe,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700),
                      textAlign: TextAlign.justify,
                    ),
            ],
          ),
        ),
      ),
    );
  }


}
