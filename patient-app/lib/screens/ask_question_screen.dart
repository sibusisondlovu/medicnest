
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_app/config/theme.dart';
import 'package:patient_app/widgets/busy_dialog.dart';
import 'package:patient_app/widgets/buttons.dart';

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});
  static const String id = "askQuestionScreen";

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  int activeStep = 0;
  String? _uploadedFileUrl;
  bool _isUploading = false;
  bool _isMediaUploaded = false;
  bool _isSaving = false;
  bool _isLoading = true;
  DocumentSnapshot? questionDoc;
  final TextEditingController symptomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuestionData();
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  void _cancelRequest(context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('questions')
            .doc(user.uid)
            .delete();

        setState(() {
          activeStep = 0;
          symptomController.clear();
          _uploadedFileUrl = null;
          _isMediaUploaded = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request cancelled successfully!')),
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error cancelling request: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error cancelling request. Please try again.')),
        );
      }
    }
  }

  Future<void> _loadQuestionData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('questions')
            .doc(user.uid)
            .get();

        setState(() {
          questionDoc = docSnapshot;
          if (docSnapshot.exists) {
            final data = docSnapshot.data() as Map<String, dynamic>;
            final stage = data['stage'] as String?;
            switch (stage) {
              case 'describe':
                activeStep = 0;
                break;
              case 'get-reply':
                activeStep = 1;
                break;
              case 'doctor-reply':
                activeStep = 2;
                break;
              default:
                activeStep = 0;
            }
            symptomController.text = data['symptom'] as String? ?? '';
            _uploadedFileUrl = data['media'] as String?;
            _isMediaUploaded = _uploadedFileUrl != null;
          }
          _isLoading = false;
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error loading question data: $e');
        }
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: LoadingScreen()),
      );
    }
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.mainColor,
              AppTheme.ascentColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      'ASK QUESTION',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              _buildEasyStepper(),
              activeStep == 0? _buildAskQuestionTile():
              activeStep == 1? _buildWaitForReplyTile():
              _buildDoctorReplyTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEasyStepper() {
    return EasyStepper(
      activeStep: activeStep,
      lineStyle: const LineStyle(
        lineLength: 50,
        lineType: LineType.normal,
        lineThickness: 3,
        lineSpace: 1,
        lineWidth: 10,
        unreachedLineType: LineType.dashed,
      ),
      stepShape: StepShape.circle,
      activeStepBackgroundColor: AppTheme.ascentColor,
      stepBorderRadius: 15,
      borderThickness: 2,
      internalPadding: 10,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      stepRadius: 28,
      finishedStepBorderColor: AppTheme.ascentColor,
      finishedStepTextColor: AppTheme.ascentColor,
      finishedStepBackgroundColor: AppTheme.ascentColor,
      activeStepIconColor: AppTheme.ascentColor,
      showLoadingAnimation: false,
      steps: [
        EasyStep(
          customStep: Text('1', style: TextStyle(
            fontSize: activeStep >= 0 ? 22 : 15,
            fontWeight: activeStep >= 0 ? FontWeight.bold : FontWeight.normal,
            color: activeStep >= 0 ? Colors.white : Colors.grey,
          ),),
          customTitle: const Text(
            style: TextStyle(
              color: Colors.white,
              fontSize: 13
            ),
            'Describe',
            textAlign: TextAlign.center,
          ),
        ),
        EasyStep(
          customStep: Text('2', style: TextStyle(
            fontSize: activeStep >= 1 ? 22 : 15,
            fontWeight: activeStep >= 1 ? FontWeight.bold : FontWeight.normal,
            color: activeStep >= 1 ? Colors.white : Colors.grey,
          ),),
          customTitle: const Text(
            style: TextStyle(
                color: Colors.white,
                fontSize: 13
            ),
            'Get Reply',
            textAlign: TextAlign.center,
          ),
        ),
        EasyStep(
          customStep: Text('3', style: TextStyle(
            fontSize: activeStep >= 2 ? 22 : 15,
            fontWeight: activeStep >= 2 ? FontWeight.bold : FontWeight.normal,
            color: activeStep >= 2 ? AppTheme.ascentColor : Colors.grey,
          ),),
          customTitle: const Text(
            style: TextStyle(
                color: Colors.white,
                fontSize: 13
            ),
            'Doctor Reply',
            textAlign: TextAlign.center,
          ),
        ),
      ],
      onStepReached: (index) => setState(() => activeStep = index),
    );
  }

  void _submitQuestion(context) async {

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final symptomText = symptomController.text;
      if (symptomText.isNotEmpty) {

        setState(() {
          _isSaving = true;
        });

        await FirebaseFirestore.instance
            .collection('questions')
            .doc(user.uid)
            .set({
          'stage': 'get-reply',
          'symptom': symptomText,
          'media': _uploadedFileUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Optionally clear the form or show a success message
        symptomController.clear();
        _uploadedFileUrl = null;
        setState(() {
          _isSaving = false;
          activeStep  = 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question submitted successfully!')),
        );
      } else {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please describe your symptoms.',
          )),
        );
      }
    }
  }

  Future<void> _pickAndUploadMedia(context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final file = File(pickedFile.path);
        final storageRef = FirebaseStorage.instance.ref().child('media/${FirebaseAuth.instance.currentUser!.uid}');
        final uploadTask = storageRef.putFile(file);

        await uploadTask.whenComplete(() async {
          _uploadedFileUrl = await storageRef.getDownloadURL();
        });

        setState(() {
          _isUploading = false;
          _isMediaUploaded =true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Media uploaded successfully!')),
        );
      } catch (e) {
        if (kDebugMode) {
          if (kDebugMode) {
            print(e);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error uploading media.')),
        );
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Widget _buildAskQuestionTile() {
    return Column(
      children: [
        const Text('Describe your symptoms and how you feel',style: TextStyle(
            color: Colors.white,
            fontSize: 14
        ),),
        const SizedBox(height: 10,),
        TextFormField(
          controller: symptomController,
          minLines: 5, // Minimum number of lines
          maxLines: null, // Allow unlimited lines (optional)
          decoration: const InputDecoration(
            fillColor: Colors.white70,
            filled: true,
            hintText: 'Eg. I am having a fever', // Placeholder text
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0), // Thick border
            ),
          ),
        ),
        _isUploading? const SpinKitFadingFour(
          color: AppTheme.mainColor,
          size: 50.0,
        ):

        _isMediaUploaded?
        const ListTile(
          leading: Icon(Icons.file_copy),
          title: Text("Medical Record.pd", style: TextStyle(fontSize: 14),),
          trailing: Icon(Icons.delete),
        ):
        GestureDetector(
          onTap: (){
            _pickAndUploadMedia(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 90,
            margin: const EdgeInsets.only(top: 10, bottom: 30,),
            decoration: BoxDecoration(

                color: Colors.white, // Background color of the container
                border: Border.all(
                    color: AppTheme.mainColor, // Color of the border
                    width: 1.0 // Width of the border
                ),
                borderRadius: BorderRadius.circular(5.0) // Radius of the rounded corners
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image),
                Text('Upload or take any photo or document')
              ],
            ),
          ),
        ),
        _isSaving? const Column(
          children: [
            SpinKitFadingFour(
              color: AppTheme.mainColor,
              size: 50.0,
            ),
            SizedBox(height: 20,),
            Text('Submitting. Please wait...')
          ],
        ): CustomElevatedButton(text: 'Submit', onPressed: (){
          _submitQuestion(context);
        }),
      ],
    );
  }

  Widget _buildWaitForReplyTile() {
    final data = questionDoc?.data() as Map<String, dynamic>?;
    final symptom = data?['symptom'] as String? ?? '';
    final timestamp = data?['timestamp'] as Timestamp?;
    final formattedDate = timestamp != null
        ? '${timestamp.toDate().day} ${_getMonthName(timestamp.toDate().month)} ${timestamp.toDate().year} at ${timestamp.toDate().hour}h${timestamp.toDate().minute.toString().padLeft(2, '0')}'
        : '';

    return Column(
      children: [
        const Text(
          textAlign: TextAlign.center,
          'Thank you for describing your \nsymptoms, a doctor will \nsend a reply to you',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
        const SizedBox(height: 10,),
        const Text('*Note that this can take up to a day',
        style: TextStyle(
          fontWeight: FontWeight.w100,
          fontStyle: FontStyle.italic,
          color: Colors.white,
          fontSize: 13
        ),),
        const SizedBox(height: 30,),
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(textAlign: TextAlign.center, 'Your Symptoms/Feelings', style: TextStyle(
                    fontWeight: FontWeight.w700,

                    fontSize: 13
                ),),
                const SizedBox(height: 10,),
                Text(symptom,
                    style: const TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 13
                    )),
                const SizedBox(height: 10,),
                Text(formattedDate,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 12
                    ))
              ],
            ),
          ),
        ),
        const Text(textAlign: TextAlign.center, 'You will receive a notification when a \ndoctor replies to your request',
            style: TextStyle(
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              color: Colors.white
            )),
        const SizedBox(height: 30,),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Feeling better already? Click to ',
                style: TextStyle(
                    color: Colors.white, fontSize: 14),
              ),
              TextSpan(
                text: 'CANCEL REQUEST',
                style: const TextStyle(
                    color: Colors.white,
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
    );
  }

  Widget _buildDoctorReplyTile() {
    return const Placeholder();
  }
}
