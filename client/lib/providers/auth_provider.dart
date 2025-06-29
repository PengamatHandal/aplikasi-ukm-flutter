import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:client/models/user.dart';
import 'package:client/services/api_service.dart';
import 'package:client/utils/token_manager.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  String? _token;
  String? _errorMessage;

  bool _isInitializing = true;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isInitializing => _isInitializing;

  AuthProvider() {
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    final storedToken = await TokenManager.getToken();

    if (storedToken == null) {
      _isInitializing = false;
      notifyListeners();
      return;
    }

    _token = storedToken;

    try {
      final response = await ApiService.instance.getUserProfile();
      if (response.statusCode == 200) {
        _user = User.fromJson(response.data);
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
        await TokenManager.removeToken();
      }
    } on DioException catch (e) {
      print("Auto-login failed: ${e.message}");
      _isLoggedIn = false;
      await TokenManager.removeToken();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await ApiService.instance.login(email, password);
      if (response.statusCode == 200) {
        _token = response.data['access_token'];
        _user = User.fromJson(response.data['user']);
        _isLoggedIn = true;

        await TokenManager.saveToken(_token!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String nim,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _errorMessage = null; 
    try {
      await ApiService.instance.register({
        'name': name,
        'nim': nim,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data as Map<String, dynamic>;
        _errorMessage = errors.values.first[0];
      } else {
        _errorMessage = 'Terjadi error tidak dikenal.';
      }
      print(e.response?.data);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke server.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.instance.logout();
    } catch (e) {
      print("Logout error (token might be expired, but we log out locally anyway): $e");
    } finally {
      await TokenManager.removeToken();
      _isLoggedIn = false;
      _user = null;
      _token = null;
      notifyListeners();
    }
  }

  void updateUserData(Map<String, dynamic> userJson) {
    _user = User.fromJson(userJson);
    notifyListeners();
  }
}