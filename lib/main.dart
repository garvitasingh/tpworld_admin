
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tpworld_admin/firebase_options.dart';
import 'package:tpworld_admin/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initNoti();
  runApp(MyApp());
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

initNoti() async {
  await _firebaseMessaging.requestPermission();
  String? token = await _firebaseMessaging.getToken();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Handling a foreground message: ${message.messageId}");
    // Handle the foreground message here
  });

  assert(token != null);
  debugPrint('FCM Token: $token');
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin App',
      theme: ThemeData(
          // Add your theme configurations here
          ),
      initialRoute: Routes.splash, // Replace with your initial route
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
