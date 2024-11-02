import 'package:flutter/material.dart';
import '../services/car_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarProvider with ChangeNotifier {
  final CarService carService = CarService();
  List<dynamic> cars = [];

  int? selectedYear;
  String? selectedMake;
  String? selectedModel;
  List<int> availableYears = [];
  List<String> availableMakes = [];
  List<String> availableModels = [];

  CarProvider() {
    fetchCarData(); // Fetch car data on initialization
  }

  // Fetch car data from the API using carService and populate years
  Future<void> fetchCarData() async {
    cars = await carService.fetchCarData();
    
    // Filter and extract unique "Years" values with explicit type conversion
    availableYears = cars
        .where((car) => car is Map<String, dynamic> && car.containsKey('Year'))
        .map<int>((car) => car['Year'] as int)
        .toSet()
        .toList();
        notifyListeners();
  }

  // Set the selected year and update available makes based on year
  void setYear(int? year) {
    if (year == null) return;
    selectedYear = year;
    selectedMake = null; // Reset selected make
    selectedModel = null; // Reset selected model
    availableMakes = [];  // Clear available makes to update
    
    // Fetch makes asynchronously based on the selected year
    fetchMakesForYear(year);
  }

  // Fetch available makes based on the selected year
  Future<void> fetchMakesForYear(int year) async {
    availableMakes = cars
        .where((car) =>
            car is Map<String, dynamic> &&
            car['Year'] == year &&
            car.containsKey('Make'))
        .map<String>((car) => car['Make'] as String)
        .toSet()
        .toList();
    availableModels = []; // Clear models since make is not selected yet
    notifyListeners();
  }

  // Set the selected make and update available models based on year and make
  void setMake(String? make) {
    if (make == null) return;
    selectedMake = make;
    selectedModel = null; // Reset selected model
    availableModels = []; // Clear available models to update
    // Fetch models asynchronously based on the selected year and make
    fetchModelsForMakeAndYear(selectedYear!, make);
  }

  // Fetch available models based on selected year and make
  Future<void> fetchModelsForMakeAndYear(int year, String make) async {
    availableModels = cars
        .where((car) =>
            car is Map<String, dynamic> &&
            car['Year'] == year &&
            car['Make'] == make &&
            car.containsKey('Model'))
        .map<String>((car) => car['Model'] as String)
        .toSet()
        .toList();
    notifyListeners();
  }

  // Set the selected model
  void setModel(String model) {
    selectedModel = model;
    notifyListeners();
  }
  // New variable to store recall results
  int recallCount = 0;
  List<dynamic> recallResults = [];

  // Function to fetch recalls based on selected year, make, and model
  Future<void> fetchRecalls() async {
    if (selectedYear != null && selectedMake != null && selectedModel != null) {
      final apiUrl =
          'https://api.nhtsa.gov/recalls/recallsByVehicle?make=${selectedMake}&model=${selectedModel}&modelYear=${selectedYear}';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
         final data = json.decode(response.body);

        // Extract the count and results
        recallCount = data['Count'];
        recallResults = data['results'];
        notifyListeners();
        } else {
          throw Exception('Failed to load recall data');
        }
      } catch (e) {
        print('Error fetching recall data: $e');
        recallResults = []; // Clear results on error
      }

      notifyListeners(); // Notify listeners to update the UI with recall results
    } else {
      print('Make sure to select Year, Make, and Model before fetching recalls');
    }
  }
  
}