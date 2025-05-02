import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../services/Config.dart';
import '../dashboard/DashboardScreen.dart';
import '../sidemenu.dart';
import '../../../../widgets/navbar.dart';
import 'CompanyDetailsScreen.dart';

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  _PlacementScreenState createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen> {
  int _currentIndex = 1;
  List<Map<String, dynamic>> companies = [];
  bool isLoading = true;
  String userName = "";
  String userEmail = "";
  @override
  void initState() {
    super.initState();
    loadPlacements();
  }

  Future<void> loadPlacements() async {
    try {
      final response = await http.get(Uri.parse(Config.allPlacements)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);  // Decode as Map
        final List<dynamic> placements = jsonData['placements'];  // Access the list of placements

        if (mounted) {
          setState(() {
            companies = List<Map<String, dynamic>>.from(placements);
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load placements, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching placements: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onTabSelected(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onScannerTap() {
    print('Scanner tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Placement Opportunities"),
        backgroundColor: const Color(0xFF0A3B87),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: SideMenu(
        onMenuTap: (route) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        userName: userName,
        userEmail: userEmail,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : companies.isEmpty
          ? const Center(child: Text("No placements found."))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: List.generate(
              companies.length,
                  (index) => _buildCompanyCard(context, companies[index], index),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        onScannerTap: _onScannerTap,
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, Map<String, dynamic> company, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompanyDetailsScreen(company: company)),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      company["placement_company_logo"] ?? "",
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company["placement_company_name"] ?? "",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          company["job_role"] ?? "",
                          style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade600),
                        ),
                        const SizedBox(height: 6),
                        _buildIconText(Icons.location_on, company["placement_company_location"] ?? "", Colors.blueGrey),
                        _buildIconText(Icons.currency_rupee_rounded, company["placement_company_package"] ?? "", Colors.green.shade700),
                        _buildIconText(Icons.calendar_today, "Deadline: ${company["deadline_date"]}", Colors.red.shade600),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompanyDetailsScreen(company: company)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Details", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
