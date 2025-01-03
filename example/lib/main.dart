import 'package:flutter/material.dart';
import 'package:infobip_sms/infobip_sms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    InfoBipSms.init(
        baseUrl: '',
        apiKey: '',
        onError: (e) {
          //TODO
        });
  }

  sendOTP() async {
    //update UI
    try {
      await InfoBipSms.sendPinCode(recipientPhone: '+840987654321');
      //Check sms
    } catch (e) {
      //TODO
    }
  }

  verifyOTP() async {
    //update UI
    try {
      await InfoBipSms.verifyPin(pinCode: '1234');
      //Check sms
    } catch (e) {
      //TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(onPressed: sendOTP, child: const Text('Send OTP')),
            ElevatedButton(
                onPressed: verifyOTP, child: const Text('Verify OTP')),
          ],
        ),
      ),
    );
  }
}
