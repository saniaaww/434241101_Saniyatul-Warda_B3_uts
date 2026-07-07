import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/login_page.dart';
import '../auth/reset_password_page.dart';

class ProfileScreen extends StatefulWidget {
  final String role;

  const ProfileScreen({
    super.key,
    required this.role,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  int totalTicket = 0;
  int openTicket = 0;
  int processTicket = 0;
  int doneTicket = 0;

  Color get primaryColor {
    final role = (ApiService.currentUserRole ?? widget.role).toLowerCase();

    switch (role) {
      case "admin":
        return const Color(0xFF0E458E);

      case "helpdesk":
        return const Color(0xFFC97E00);

      case "user":
        return const Color(0xFF00796D);

      default:
        return Colors.blue;
    }
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    final userData = await ApiService.getUser(
      ApiService.currentUserId!,
    );

    List<dynamic> tickets = [];

    switch ((ApiService.currentUserRole ?? "").toLowerCase()) {

      case "admin":
        tickets = await ApiService.getTickets();
        break;

      case "helpdesk":
        tickets = await ApiService.getMyTickets();
        break;

      case "user":
        tickets = await ApiService.getMyUserTickets();
        break;
    }

    totalTicket = tickets.length;

    openTicket = tickets
        .where((e) => e["status"] == "Open")
        .length;

    processTicket = tickets
        .where((e) => e["status"] == "In Progress")
        .length;

    doneTicket = tickets
        .where((e) => e["status"] == "Close")
        .length;

    setState(() {
      user = userData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 35,
              bottom: 30,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: primaryColor,
                    size: 65,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  user?['name'] ?? "-",
                  style: const TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user?['email'] ?? "-",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    (user?['role'] ?? widget.role)
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  "Total",
                  totalTicket.toString(),
                  primaryColor,
                ),
                _buildStatItem(
                  "Open",
                  openTicket.toString(),
                  Colors.blue,
                ),
                _buildStatItem(
                  "Process",
                  processTicket.toString(),
                  Colors.orange,
                ),
                _buildStatItem(
                  "Done",
                  doneTicket.toString(),
                  Colors.green,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                _profileMenu(
                  Icons.history,
                  "Riwayat Aktivitas",
                  primaryColor,
                      () {},
                ),
                _profileMenu(
                  Icons.lock_reset,
                  "Ubah Password",
                  primaryColor,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResetPasswordPage(),
                      ),
                    );
                  },
                ),
                _profileMenu(
                  Icons.settings,
                  "Pengaturan",
                  primaryColor,
                      () {},
                ),
                _profileMenu(
                  Icons.help_outline,
                  "Pusat Bantuan",
                  primaryColor,
                      () {},
                ),
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                            (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Keluar",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileMenu(
      IconData icon,
      String title,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 17,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatItem(
      String title,
      String value,
      Color color,
      ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title),
      ],
    );
  }
}