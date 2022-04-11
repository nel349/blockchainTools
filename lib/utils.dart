import 'dart:convert';
import 'dart:io';

class Utils {
  static Future<bool> writeFile(String filePath, dynamic object) async {
    try {
      File myFile = File(filePath);
      await myFile.writeAsString(jsonEncode(object));
      return true;
    } catch (e) {
      return false;
    }
  }
}