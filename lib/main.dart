import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MessagingTutorial());
}

class MessagingTutorial extends StatelessWidget {
  const MessagingTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Messaging',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? notificationText;

  @override
  void initState() {
    super.initState();

    // Set up Firebase Messaging
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic('messaging');

    // Get device FCM token and print to console
    messaging.getToken().then((value) {
      print('Device FCM token:');
      print(value);
    });

    // Handle an incoming notification
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // Print raw notification data to console
      print('Message recieved:');
      print(event.notification!.title);
      print(event.notification!.body);
      print(event.data.toString());
      print(event.data.values.toList().toString());
      print(event.data['type']);
      print(event.data['category']);

      var title = event.notification!.title;
      var body = event.notification!.body;
      var type = event.data['type'];
      var category = event.data['category'];

      if (type == 'important') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(Icons.warning),
              backgroundColor: Colors.red,
              title: Text(title!),
              content: Text(body!),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (category == 'motivation') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(Icons.lightbulb),
              backgroundColor: Colors.blue,
              title: Text(title!),
              content: Text(body!),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (type == 'wisdom') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(Icons.lightbulb),
              backgroundColor: Colors.deepPurple,
              title: Text(title!),
              content: Text(body!),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(Icons.info),
              backgroundColor: Colors.grey,
              title: Text(title!),
              content: Text(body!),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Messaging')),
      body: Center(child: const Text('Messaging Tutorial')),
    );
  }
}
