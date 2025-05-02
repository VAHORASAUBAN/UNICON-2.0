import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  const CompanyDetailsScreen({Key? key, required this.company}) : super(key: key);

  // Function to download the PDF to a specific location
  Future<void> _downloadPDF(BuildContext context) async {
    final pdfUrl = company['placement_job_description'];
    if (pdfUrl == null || pdfUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No job description PDF available.')),
      );
      return;
    }

    try {
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Get the app's documents directory to store the file
        final dir = await getExternalStorageDirectory(); // You can use `getApplicationDocumentsDirectory()` if external storage is not required
        final file = File('${dir!.path}/${pdfUrl.split('/').last}');

        // Save the PDF file
        await file.writeAsBytes(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to: ${file.path}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download failed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Utility method to create info tiles
  Widget infoTile(String label, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800], size: 20),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? "N/A"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company["placement_company_name"] ?? "Company Details",style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A3B87),
        iconTheme: const IconThemeData(color: Colors.white), // ← makes the back button white

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      company["placement_company_logo"] ?? "https://via.placeholder.com/150",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                infoTile("Role", company["job_role"], Icons.work_outline),
                infoTile("Location", company["placement_company_location"], Icons.location_on),
                infoTile("Package", company["placement_company_package"], Icons.monetization_on),
                infoTile("Interview", company["interview_date"], Icons.event),
                infoTile("Deadline", company["deadline_date"], Icons.hourglass_bottom),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadPDF(context),
                    icon: const Icon(Icons.download,color: Colors.white,),
                    label: const Text("Download Description",style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
