// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart/models/http_execption.dart';

String apikey = 'AIzaSyBIzdOR2sMb0s0HFWGxjrfWOpaWyfcXyLw';

class Auth with ChangeNotifier {
  dynamic _token;
  dynamic _expiryDate;
  dynamic _userId;

  bool get isAuth {
    return token != "i";
  }

  get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return "i";
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apikey');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(json.decode(response.body));
      final responesData = json.decode(response.body);
      if (responesData['error'] != null) {
        print("httpException");
        throw HttpExeceptionM(responesData['error']['message']);
      }
      _token = responesData['idToken'];
      _userId = responesData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responesData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
