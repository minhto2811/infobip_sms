# Infobip SMS Plugin

**Infobip SMS Plugin** is a Flutter plugin that helps you integrate Infobip's SMS service for quick and efficient phone number verification.

## 🚀 Features
- **Phone Number Verification**: Send OTP codes directly via SMS.  
- **Message Sending**: Customize and send messages to any phone number.  
- **Status Tracking**: Check message status (delivered, failed, etc.).  
- **Easy Integration**: Quick installation and simple configuration.  

## 📦 Installation  
Add the plugin to your `pubspec.yaml` file:  

```yaml
infobip_sms: <latest-version>
```  

Then run:  

```bash
flutter pub get
```  

## ⚙️ Configuration  
Create an account and obtain an API key from the [Infobip Dashboard](https://www.infobip.com).  

## 🔧 Usage  

```xml
<manifest>
  <uses-permission android:name="android.permission.INTERNET" />
</manifest>
```  

```dart
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
    try {
      await InfoBipSms.sendPinCode(recipientPhone: '+840987654321');
    } catch (e) {
      //TODO
    }
  }

  verifyOTP() async {
    try {
      await InfoBipSms.verifyPin(pinCode: '1234');
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
```  

## 🛠️ Contribution  
We always welcome contributions from the community. Submit a pull request or create an issue if you encounter any bugs.  

## 📄 License  
MIT License - Feel free to use and modify as needed.  

---  

**Made with ❤️ by mxgk**
