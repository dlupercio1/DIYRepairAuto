import 'dart:convert';
import 'package:http/http.dart' as http;

class CarService {
  static const String baseUrl = "http://10.0.2.2:5000/api/cars";


  // Fetch car data
  Future<List<dynamic>> fetchCarData() async {
    final response = await http.get(Uri.parse(baseUrl));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load car data');
    }
  }
}