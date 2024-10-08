import 'package:flutter/material.dart';
import 'package:patient_app/screens/alerts_screen.dart';
import 'package:patient_app/screens/chats_screen.dart';
import 'package:patient_app/screens/home_screen.dart';
import 'package:patient_app/screens/main_layout_screen.dart';
import 'package:patient_app/screens/profile_screen.dart';
import 'package:patient_app/screens/register_screen.dart';
import '../screens/ask_question_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/get_started_screen.dart';
import '../screens/login_screen.dart';
import '../screens/medical_journey_screen.dart';
import '../wrapper.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as dynamic;
    switch (settings.name) {

      case Wrapper.id:
        return _route(const Wrapper());

      case GetStartedScreen.id:
        return _route(const GetStartedScreen());

      case RegisterScreen.id:
        return _route(const RegisterScreen());

      case LoginScreen.id:
        return _route((const LoginScreen()));

      case MainLayout.id:
        return _route(const MainLayout());

      case HomeScreen.id:
        return _route(const HomeScreen());

      case ChatsScreen.id:
        return _route(const ChatsScreen());

      case AlertsScreen.id:
        return _route(const AlertsScreen());

      case ProfileScreen.id:
        return _route(const ProfileScreen());

      case EditProfileScreen.id:
        return _route(const EditProfileScreen());

      case MedicalJourneyScreen.id:
        return _route(MedicalJourneyScreen(data: args));

      case AskQuestionScreen.id:
        return _route(const AskQuestionScreen());

      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _route(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

  static Route<dynamic> _errorRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: Center(
          child: Text(
            'ROUTE \n\n$name\n\nNOT FOUND',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}