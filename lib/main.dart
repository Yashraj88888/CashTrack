import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:another_telephony/telephony.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



import 'models/sms_model.dart';
import 'services/sms_parser.dart';
import 'screens/signin_screen.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';

final _notifPlugin = FlutterLocalNotificationsPlugin();

Future<Box<SmsModel>> openUserBox(String email) async {
  final name = 'transactions_${email.replaceAll('@', '_').replaceAll('.', '_')}';
  if (!Hive.isBoxOpen(name)) {
    return await Hive.openBox<SmsModel>(name);
  }
  return Hive.box<SmsModel>(name);
}

@pragma('vm:entry-point')
Future<void> _backgroundSmsHandler(SmsMessage msg) async {
  await Hive.initFlutter();
  Hive.registerAdapter(SmsModelAdapter());

  final smsBox = await Hive.openBox<SmsModel>('smsBox');
  final parsed = SmsModel(
    sender: msg.address ?? 'Unknown',
    body: msg.body ?? '',
    receivedAt: DateTime.now(),
    amount: parseSms(msg.body ?? '')['amount'],
    type: parseSms(msg.body ?? '')['type'],
  );
  await smsBox.add(parsed);

  const androidDetails = AndroidNotificationDetails(
    'sms_channel', 'SMS Notifications',
    channelDescription: 'Background SMS',
    importance: Importance.max,
    priority: Priority.high,
  );
  await _notifPlugin.show(
    msg.hashCode,
    'New SMS from ${parsed.sender}',
    parsed.body,
    NotificationDetails(android: androidDetails),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Hive init
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(SmsModelAdapter());
  await Hive.openBox<SmsModel>('smsBox');

  // Notifications init
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _notifPlugin.initialize(InitializationSettings(android: androidInit));

  // SMS listener
  final telephony = Telephony.instance;
  bool? granted = await telephony.requestPhoneAndSmsPermissions;
  if (granted == true) {
    telephony.listenIncomingSms(
      onNewMessage: (msg) async {
        final smsBox = Hive.box<SmsModel>('smsBox');
        final parsed = SmsModel(
          sender: msg.address ?? 'Unknown',
          body: msg.body ?? '',
          receivedAt: DateTime.now(),
          amount: null,
          type: 'sms',
        );
        smsBox.add(parsed);

        const androidDetails = AndroidNotificationDetails(
          'sms_channel', 'SMS Notifications',
          channelDescription: 'Foreground SMS',
          importance: Importance.max,
          priority: Priority.high,
        );
        await _notifPlugin.show(
          msg.hashCode,
          'New SMS from ${parsed.sender}',
          parsed.body,
          NotificationDetails(android: androidDetails),
        );
      },
      onBackgroundMessage: _backgroundSmsHandler,
    );
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // Delay 4 seconds and then navigate
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 200),
              Text(
                'CashTrack',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 40),
                child: Image.asset(
                  'assets/chippy.png',
                  height: 250,
                ),
              ),
              const SizedBox(height: 90),
              const SpinKitFadingCircle(
                color: Color(0xFF00CCE7),
                size: 80.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.active) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snap.data == null
            ? const SignInScreen()
            : const HomeScreen();
      },
    );
  }
}
