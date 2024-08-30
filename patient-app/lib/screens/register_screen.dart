import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../config/theme.dart';
import '../helpers/check_internet.dart';
import '../widgets/buttons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isMobileValid = false;
  bool _isPasswordValid = false;
  bool _isLoading = false;

  final RegExp _mobileRegExp = RegExp(r'^0\d{9}$');
  final RegExp _passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

  final TextEditingController _fullNames = TextEditingController();
  final TextEditingController _idNumber = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_validateMobile);
    _passwordController.addListener(_validatePassword);
  }


  void _validateMobile() {
    final mobile = _mobileController.text;

    setState(() {
      _isMobileValid = _mobileRegExp.hasMatch(mobile);
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;

    setState(() {
      _isPasswordValid = _passwordRegExp.hasMatch(password);
    });
  }

  bool _isFormValid() {
    return
      _isMobileValid &&
          _isPasswordValid;
  }

  Future<void> _signup(context) async {
    final isConnected = await checkInternetConnectivity();

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'You are offline. The app will have limited functionality.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '${_mobileController.text.trim()}@hakela.co.za',
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(userCredential.user?.uid)
          .set({
        'names': _fullNames.text,
        'idNumber': _idNumber.text,
        'phone': _mobileController.text,
        'balance': 0,
      });

      // Show success dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'Congratulations! Your Hakela account has been created',
        btnOkText: 'Continue',
        btnOkOnPress: () {
          Navigator.pushReplacementNamed(context, 'homeScreen');
        },
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Error',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.mainColor,
        centerTitle: true,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white,fontSize: 16,),
        ),
      ),
      body: !_isLoading
          ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  // Nickname Field
                  TextFormField(
                    controller: _fullNames,
                    decoration: const InputDecoration(
                      labelText: 'Full Names',
                      prefixIcon: Icon(Icons.person),
                      border: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full names';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    controller: _idNumber,
                    decoration: const InputDecoration(
                      labelText: 'ID Number',
                      prefixIcon: Icon(Icons.shield),
                      border: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Mobile Field
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile',
                      prefixIcon: Icon(Icons.phone),
                      border: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Password must include at least one uppercase letter';
                      } else if (!RegExp(r'\d').hasMatch(value)) {
                        return 'Password must include at least one digit';
                      } else if (value.contains(' ')) {
                        return 'Password cannot contain spaces';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    onPressed: _isFormValid()
                        ? () {
                      _signup(context);
                    }
                        : null,
                    text: 'Sign Up',
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'By signing up you agree to our Terms and Conditions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(
                              color: AppTheme.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle Sign In action
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          : const Center(
        child: SpinKitCircle(
          color: AppTheme.mainColor,
          size: 50.0,
        ),
      ),
    );
  }
}
