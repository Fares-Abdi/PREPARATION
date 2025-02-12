import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanini_frontend/localization/app_localization.dart';
import 'terms_and_conditions_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:firebase_messaging/firebase_messaging.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Function to generate and retrieve the device token for push notifications.
  Future<String?> generateDeviceToken() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission for notifications (only needed for iOS and macOS)
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Notification permissions denied');
        return null;
      }

      // Get the device token
      final String? token = await messaging.getToken();

      if (token != null) {
        debugPrint('Device token generated: $token');
        return token;
      } else {
        debugPrint('Failed to generate device token');
        return null;
      }
    } catch (e) {
      debugPrint('Error generating device token: $e');
      return null;
    }
  }

  Future<void> saveDeviceTokenToFirestore(String userId) async {
    try {
      final String? token = await generateDeviceToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'deviceToken': token,
        });
        debugPrint('Device token saved to Firestore: $token');
      } else {
        debugPrint('Device token generation failed');
      }
    } catch (e) {
      debugPrint('Error saving device token to Firestore: $e');
    }
  }

  Future<void> _signup() async {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return;
    setState(() {});

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String passwordCheck = _passwordCheckController.text.trim();

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        passwordCheck.isNotEmpty) {
      if (password == passwordCheck) {
        try {
          final UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (userCredential.user != null) {
            // Send email verification
            await userCredential.user!.sendEmailVerification();

            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
              'uid': userCredential.user!.uid,
              'name': name,
              'email': email,
              'createdAt': DateTime.now(),
              'lastSignIn': DateTime.now(),
              'isConnected': false, // Set to false until email is verified
              'isEmailVerified': false,
            });

            // Show verification instructions
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.verifyAccountBeforeLogin),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: localizations.resend,
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.verificationEmailResent),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              localizations.errorResendingVerificationEmail),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            );

            // Navigate to a verification pending screen or login screen
            Navigator.pushNamed(context, '/login');
          }
        } on FirebaseAuthException catch (e) {
          String errorMessage = localizations.signupError;
          if (e.code == 'email-already-in-use') {
            errorMessage = 'This email is already in use.';
          } else if (e.code == 'weak-password') {
            errorMessage =
                'Password is too weak. Please choose a stronger password.';
          } else if (e.code == 'invalid-email') {
            errorMessage = 'The email address is not valid.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${localizations.unexpectedErrorOccurred} $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.passwordsDoNotMatch),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.allFieldsRequired),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    setState(() {});
  }

  Widget _buildSignUpButton(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: ElevatedButton(
        onPressed: isLoading || !_isChecked ? null : _signup,
        style: ElevatedButton.styleFrom(
          backgroundColor: (isLoading || !_isChecked)
              ? Colors.grey
              : const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          elevation: 6,
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
              )
            : Text(
                localizations.signupButton,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xFF1A237E),
                ),
              ),
      ),
    );
  }

  bool _isChecked = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    super.dispose();
  }

  bool isLoading = false; // Add this state variable to track the loading state

  Widget _buildGoogleSignInButton() {
    final localizations = AppLocalizations.of(context)!;
    final buttonText = localizations.googleSignIn;

    return SlideTransition(
      position: _slideAnimation,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleGoogleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          elevation: 6,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    buttonText,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return;
    setState(() {
// Show loading indicator
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        try {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final User? user = userCredential.user;

          if (user != null) {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

            Map<String, dynamic> userData = {
              'uid': user.uid,
              'email': user.email ?? 'No Email',
              'lastSignIn': DateTime.now(),
              'isConnected': true,
            };

            if (!userDoc.exists || userDoc.data()?['name'] == null) {
              userData['name'] = user.displayName ?? 'No Name';
            }

            if (!userDoc.exists ||
                userDoc.data()?['photoURL'] == null ||
                (userDoc.data()?['photoURL']?.isEmpty ??
                    true &&
                        user.photoURL != null &&
                        user.photoURL!.isNotEmpty)) {
              userData['photoURL'] = user.photoURL ?? '';
            }

            if (!userDoc.exists) {
              userData['createdAt'] = DateTime.now();
            }

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set(userData, SetOptions(merge: true));

            saveDeviceTokenToFirestore(user.uid);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${localizations.welcome} ${user.displayName ?? user.email}'),
                backgroundColor: Colors.green,
              ),
            );

            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);

            // Check if this is the user's first time
            if (userDoc.exists && userDoc.data()?['isNotFirst'] == false) {
              Navigator.pushNamed(context, '/navbar');
            } else {
              // For first-time users, navigate to onboarding
              Navigator.pushNamed(context, '/info');
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.signInFailed),
                backgroundColor: Colors.red,
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account exists with different credentials.'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Authentication error: ${e.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign-In was canceled.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('${localizations.errorDuringSignIn} ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
// Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 106, 27, 154), // Rich Amethyst
              Color.fromARGB(255, 171, 71, 188), // Orchid
              Color.fromARGB(255, 145, 41, 140), // Wild Strawberry
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Image.asset(
                        'assets/images/onboarding3_b.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        localizations.signupTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(localizations.nameLabel, false,
                        _nameController, _slideAnimation),
                    const SizedBox(height: 10),
                    _buildEmailField(localizations.emailLabel),
                    const SizedBox(height: 10),
                    _buildPasswordField(localizations.passwordLabel),
                    const SizedBox(height: 10),
                    _buildPasswordCheckField(localizations.passwordCheckLabel),
                    // const SizedBox(height: 10),
                    // _buildPhoneField(phoneLabel),
                    const SizedBox(height: 20),
                    _buildTermsCheckbox(),
                    const SizedBox(height: 20),
                    _buildGoogleSignInButton(),
                    const SizedBox(height: 10),
                    _buildSignUpButton(context),
                    const SizedBox(height: 10),
                    _buildLoginButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, bool obscureText,
      TextEditingController controller, Animation<Offset> slideAnimation) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    return SlideTransition(
      position: slideAnimation,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.white),
          floatingLabelStyle: GoogleFonts.poppins(color: Colors.white),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
        style: GoogleFonts.poppins(color: Colors.white),
        onChanged: (value) {
          setState(() {}); // Trigger rebuild for real-time validation if needed
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)?.fieldRequiredError ??
                'Please enter your $label';
          } else if (label == localizations.passwordLabel &&
              (value.length < 8)) {
            return localizations.passwordMinLengthError;
          } else if (label == localizations.emailLabel) {
            final emailRegex =
                RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return AppLocalizations.of(context)?.emailInvalidError ??
                  'Please enter a valid email';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField(String label) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.white),
          floatingLabelStyle: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 255, 255, 255)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
        style: GoogleFonts.poppins(color: Colors.white),
        onChanged: (value) {
          setState(() {}); // Trigger rebuild for real-time validation if needed
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localizations.emailRequiredError;
          }
          final emailRegex =
              RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          if (!emailRegex.hasMatch(value)) {
            return localizations.emailInvalidError;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.white),
          floatingLabelStyle: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 255, 255, 255)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
        style: GoogleFonts.poppins(color: Colors.white),
        onChanged: (value) {
          setState(() {}); // Trigger rebuild for real-time validation if needed
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localizations.passwordRequiredError;
          } else if (value.length < 8) {
            return localizations.passwordMinLengthError;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordCheckField(String label) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: TextFormField(
        controller: _passwordCheckController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.white),
          floatingLabelStyle: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 255, 255, 255)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
        style: GoogleFonts.poppins(color: Colors.white),
        onChanged: (value) {
          setState(() {}); // Trigger rebuild for real-time validation if needed
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localizations.passwordRequiredError;
          } else if (value.length < 8) {
            return localizations.passwordMinLengthError;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return SlideTransition(
      position: _slideAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value ?? false;
              });
            },
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)?.termsAgreementPrefix,
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)?.termsAgreementLink,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 183, 173, 173)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionsPage()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        child: Text(
          AppLocalizations.of(context)?.loginButtonText ??
              localizations.alreadyHaveAnAccount,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
