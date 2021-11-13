import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apikey = 'AIzaSyBIzdOR2sMb0s0HFWGxjrfWOpaWyfcXyLw';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;
  Future<void> signup(String email, String password) async {
    final urlSignUp = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:createAuthUri?key=$apikey');
    final response = await http.post(
      urlSignUp,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(json.decode(response.body));
  }
}
