import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service to manage user authentication and account data
class UserService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  /// Save user data after registration
  Future<bool> registerUser({
    required String name,
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // In a real app, this would be an API call
      // For now, save to local storage
      final userData = {
        'name': name,
        'emailOrPhone': emailOrPhone,
        'password': password, // In production, NEVER store plain password!
        'createdAt': DateTime.now().toIso8601String(),
      };

      await prefs.setString(_userKey, json.encode(userData));
      await prefs.setBool(_isLoggedInKey, true);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validate login credentials
  Future<bool> loginUser({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);
      
      if (userDataString == null) {
        return false;
      }

      final userData = json.decode(userDataString);
      
      // Simple validation (in production, use proper authentication)
      if (userData['emailOrPhone'] == emailOrPhone && 
          userData['password'] == password) {
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);
      
      if (userDataString == null) {
        return null;
      }

      return json.decode(userDataString);
    } catch (e) {
      return null;
    }
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  /// Clear all user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_isLoggedInKey);
  }
}
