import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';

class CarSelectionPage extends StatefulWidget {
  const CarSelectionPage({super.key});

  @override
  _CarSelectionPageState createState() => _CarSelectionPageState();
}

class _CarSelectionPageState extends State<CarSelectionPage> {
  @override
  void initState() {
    super.initState();
    // Fetch makes when the page loads
    Provider.of<CarProvider>(context, listen: false).fetchCarData();
  }

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Car',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<int>(
              value: carProvider.selectedYear,
              hint: Text('Select Year'),
              items: carProvider.availableYears.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (int? newYear) async {
                if (newYear != null) {
                  carProvider.setYear(newYear);
                }
              },
            ),
            if (carProvider.selectedYear != null)
              DropdownButton<String>(
                value: carProvider.selectedMake,
                hint: Text('Select Make'),
                items: carProvider.availableMakes.map((make) {
                  return DropdownMenuItem(
                    value: make,
                    child: Text(make),
                  );
                }).toList(),
                onChanged: (String? newMake) {
                  if (newMake != null) {
                  carProvider.setMake(newMake);
                  }
                }
              ),
            if (carProvider.selectedMake != null)
              DropdownButton<String>(
                value: carProvider.selectedModel,
                hint: Text('Select Model'),
                items: carProvider.availableModels.map((model) {
                  return DropdownMenuItem(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
                onChanged: (String? newModel) {
                  if (newModel != null) {
                  carProvider.setModel(newModel);
                  }
                },
              ),
              SizedBox(height: 20),
            // Add other dropdowns for Trim, Engine as needed

            // Button to Fetch Recalls
            ElevatedButton(
              onPressed: (carProvider.selectedYear != null &&
                      carProvider.selectedMake != null &&
                      carProvider.selectedModel != null)
                  ? () async {
                      await carProvider.fetchRecalls();
                    }
                  : null, // Disable if Year, Make, or Model is not selected
              child: Text("Fetch Recalls"),
            ),

            // Display the Count and Recall Results
            SizedBox(height: 20),
            Text(
              "Recall Results: ${carProvider.recallCount}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Horizontal ScrollView for Recall Results
              Expanded(
                //height: 300, // Set a fixed height to avoid overflow
                child: carProvider.recallResults.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: carProvider.recallResults.map((recall) {
                            return Container(
                              width: 300, // Set a fixed width for each box
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recall Number: ${recall['NHTSACampaignNumber'] ?? "N/A"}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Manufacturer: ${recall['Manufacturer'] ?? "N/A"}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Component: ${recall['Component'] ?? "N/A"}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Summary: ${recall['Summary'] ?? "N/A"}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  //SizedBox(height: 4),
                                  //Text(
                                  //   'Consequence: ${recall['Consequence'] ?? "N/A"}',
                                  //   style: TextStyle(fontSize: 14),
                                  // ),
                                  // SizedBox(height: 4),
                                  // Text(
                                  //   'Remedy: ${recall['Remedy'] ?? "N/A"}',
                                  //   style: TextStyle(fontSize: 14),
                                  // ),
                                  SizedBox(height: 4),
                                  Text(
                                  'Report Date: ${recall['ReportReceivedDate'] ?? "N/A"}',
                                  style: TextStyle(fontSize: 14),
                                  ),
                                  // SizedBox(height: 4),
                                  // Text(
                                  //   'Notes: ${recall['Notes'] ?? "N/A"}',
                                  //   style: TextStyle(fontSize: 14),
                                  // ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Center(
                        child: Text(
                          "No recalls found.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
