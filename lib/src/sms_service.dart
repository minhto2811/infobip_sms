import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class InfoBipSms {
  static void init({
    required String baseUrl,
    required String apiKey,
    required void Function(String) onError,
    String pinType = "NUMERIC",
    String messageText = "Your pin is {{pin}}",
    int pinLength = 4,
    String senderId = "ServiceSMS",
  }) async {
    _baseUrl = baseUrl;
    _apiKey = apiKey;
    try {
      await _createApplication(
        pinType: pinType,
        messageText: messageText,
        pinLength: pinLength,
        senderId: senderId,
      );
      debugPrint('InfoBipSms: Initialized');
    } catch (e) {
      debugPrint('InfoBipSms: Failed to initialize');
      onError.call(e.toString());
    }
  }

  static late String _baseUrl;
  static late String _apiKey;

  static String _applicationId = '';
  static String _messageId = '';
  static String _pinId = '';

  static Map<String, String> get _headers => {
        'Authorization': 'App $_apiKey',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future<bool> verifyPin({
    required String pinCode,
  }) async {
    var url = Uri.https(_baseUrl, '/2fa/2/pin/$_pinId/verify');
    var body = jsonEncode({
      "pin": pinCode,
    });
    var response = await http.post(url, headers: _headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Verification successful: ${response.body}');
      return jsonDecode(response.body)['verified'];
    } else {
      throw Exception('Verification failed with status: $response');
    }
  }

  static Future<void> sendPinCode({
    required String recipientPhone,
    String from = "ServiceSMS",
  }) async {
    var url = Uri.https(_baseUrl, '/2fa/2/pin');
    var body = jsonEncode({
      "applicationId": _applicationId,
      "messageId": _messageId,
      "from": from,
      "to": recipientPhone,
    });
    var response = await http.post(url, headers: _headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['smsStatus'] != "MESSAGE_SENT") {
        throw Exception(response.body);
      }
      _pinId = data['pinId'];
      debugPrint('SendPinCode successful: ${response.body}');
    } else {
      throw Exception('SendPinCode failed: $response');
    }
  }

  static Future<void> _createApplication({
    String pinType = "NUMERIC",
    String messageText = "Your pin is {{pin}}",
    int pinLength = 4,
    String senderId = "ServiceSMS",
  }) async {
    if (_applicationId == '') {
      _applicationId = await _createApplicationId();
    }
    if (_messageId == '') {
      _messageId = await _send2FAMessage(
        pinType: pinType,
        messageText: messageText,
        pinLength: pinLength,
        senderId: senderId,
      );
    }
  }

  static Future<String> _send2FAMessage({
    String pinType = "NUMERIC",
    String messageText = "Your pin is {{pin}}",
    int pinLength = 4,
    String senderId = "ServiceSMS",
  }) async {
    var url =
        Uri.https(_baseUrl, '/2fa/2/applications/$_applicationId/messages');
    var body = jsonEncode({
      "pinType": pinType,
      "messageText": messageText,
      "pinLength": pinLength,
      "senderId": senderId
    });
    var response = await http.post(url, headers: _headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)['messageId'];
    } else {
      throw Exception('Send2FAMessage failed: $response');
    }
  }

  static Future<String> _createApplicationId() async {
    var url = Uri.https(_baseUrl, '/2fa/2/applications');

    var body = jsonEncode({
      "name": "2fa test application",
      "enabled": true,
      "configuration": {
        "pinAttempts": 10,
        "allowMultiplePinVerifications": true,
        "pinTimeToLive": "15m",
        "verifyPinLimit": "1/3s",
        "sendPinPerApplicationLimit": "100/1d",
        "sendPinPerPhoneNumberLimit": "10/1d",
      }
    });
    var response = await http.post(url, headers: _headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final applicationId = jsonDecode(response.body)['applicationId'];
      return applicationId;
    } else {
      throw Exception('Failed while creating Application: $response');
    }
  }
}
