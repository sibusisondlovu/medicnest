
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
  final TextEditingController symptomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask A Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [_buildEasyStepper(),
            activeStep == 0? _buildAskQuestionTile():
            activeStep == 1? _buildWaitForReplyTile():
            _buildDoctorReplyTile(),
          ],
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
      activeStepBackgroundColor: AppTheme.mainColor,
      stepBorderRadius: 15,
      borderThickness: 2,
      internalPadding: 10,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      stepRadius: 28,
      finishedStepBorderColor: AppTheme.mainColor,
      finishedStepTextColor: AppTheme.mainColor,
      finishedStepBackgroundColor: AppTheme.mainColor,
      activeStepIconColor: AppTheme.mainColor,
      showLoadingAnimation: false,
      steps: [
        EasyStep(
          customStep: Text('1', style: TextStyle(
            fontSize: activeStep >= 0 ? 22 : 15,
            fontWeight: activeStep >= 0 ? FontWeight.bold : FontWeight.normal,
            color: activeStep >= 0 ? Colors.white : Colors.grey,
          ),),
          customTitle: const Text(
            'Describe',
            textAlign: TextAlign.center,
          ),
        ),
        EasyStep(
          customStep: Text('2', style: TextStyle(
            fontSize: activeStep >= 1 ? 22 : 15,
            fontWeight: activeStep >= 1 ? FontWeight.bold : FontWeight.normal,
            color: activeStep >= 1 ? AppTheme.ascentColor : Colors.grey,
          ),),
          customTitle: const Text(
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
          const SnackBar(content: Text('Please describe your symptoms.')),
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
        const Text('Describe your symptoms and how you feel'),
        TextFormField(
          controller: symptomController,
          minLines: 5, // Minimum number of lines
          maxLines: null, // Allow unlimited lines (optional)
          decoration: const InputDecoration(
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
    return Column(
      children: [
        const Text(
          textAlign: TextAlign.center,
          'Thank you for describing your symptoms, a doctor will send a reply to you',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
        const SizedBox(height: 10,),
        const Text('*Note that this can take up to a day',
        style: TextStyle(
          fontWeight: FontWeight.w100,
          fontStyle: FontStyle.italic,
          fontSize: 13
        ),),
        const SizedBox(height: 10,),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(textAlign: TextAlign.center, 'Your Symptoms/Feelings', style: TextStyle(
                    fontWeight: FontWeight.w700,

                    fontSize: 13
                ),),
                SizedBox(height: 10,),
                Text('fsdffsfsfsdfsdffdfdfdsfffsdf',
                    style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 13
                    )),
                SizedBox(height: 10,),
                Text('30 August 2024 at 23h43',
                    style: TextStyle(
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
                fontSize: 12
            )),
        const SizedBox(height: 30,),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Feeling better already? Click to ',
                style: TextStyle(
                    color: Colors.black, fontSize: 14),
              ),
              TextSpan(
                text: 'CANCEL REQUEST',
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
    );
  }

  Widget _buildDoctorReplyTile() {
    return const Placeholder();
  }
}
