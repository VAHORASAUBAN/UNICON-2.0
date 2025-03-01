import 'package:flutter/material.dart';
import '../dashboard/DashboardScreen.dart';
import '../sidemenu.dart';
import '../../../../shared/widgets/navbar.dart';
import 'CompanyDetailsScreen.dart';

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  _PlacementScreenState createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen> {
  int _currentIndex = 1;

  final List<Map<String, String>> companies = [
    {
      "name": "Google",
      "role": "Software Engineer",
      "logo": "https://logo.clearbit.com/google.com",
      "location": "Mountain View, CA",
      "package": "₹35 LPA",
      "deadline": "March 25, 2025",
    },
    {
      "name": "Microsoft",
      "role": "Cloud Developer",
      "logo": "https://logo.clearbit.com/microsoft.com",
      "location": "Redmond, WA",
      "package": "₹30 LPA",
      "deadline": "April 15, 2025",
    },
    {
      "name": "Amazon",
      "role": "AI/ML Engineer",
      "logo": "https://logo.clearbit.com/amazon.com",
      "location": "Seattle, WA",
      "package": "₹40 LPA",
      "deadline": "May 10, 2025",
    },
  ];

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

      // **AppBar with SideMenu**
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
        userName: "John Doe",
        userEmail: "johndoe@example.com",
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: List.generate(
              companies.length,
                  (index) => _buildCompanyCard(context, companies[index]),
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

  // **Company Card UI (Now More Mobile-Friendly)**
  Widget _buildCompanyCard(BuildContext context, Map<String, String> company) {
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
                  // **Company Logo**
                  Hero(
                    tag: company["name"]!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        company["logo"]!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // **Company Details**
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company["name"]!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          company["role"]!,
                          style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade600),
                        ),
                        const SizedBox(height: 6),

                        // **Location, Package, Deadline**
                        _buildIconText(Icons.location_on, company["location"]!, Colors.blueGrey),
                        _buildIconText(Icons.currency_rupee_rounded, company["package"]!, Colors.green.shade700),
                        _buildIconText(Icons.calendar_today, "Deadline: ${company["deadline"]}", Colors.red.shade600),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // **Apply Button**
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
                  child: const Text("Apply Now", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // **Helper Function for Icon & Text**
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
