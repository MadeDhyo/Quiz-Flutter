import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // We make the URL a constant to keep it clean
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/users';

  Future<List<dynamic>> fetchWorkoutBuddies() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // If the server returns an error, we throw it
        throw Exception('Failed to load data from server');
      }
    } catch (e) {
      // If there is no internet or a typo in the URL
      throw Exception('Network error: $e');
    }
  }
}