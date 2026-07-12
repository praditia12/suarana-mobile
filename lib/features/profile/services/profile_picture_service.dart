import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureService {
  static const _key = 'profile_picture_path';

  // Simpan path foto lokal ke SharedPreferences
  Future<void> savePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, path);
  }

  // Baca path foto dari SharedPreferences
  Future<String?> loadPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  // Hapus foto (reset ke placeholder)
  Future<void> clearPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}