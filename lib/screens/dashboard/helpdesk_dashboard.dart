import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/login_page.dart';
import '../profile/profile_screen.dart';
import '../tickets/ticket_detail_page.dart';
import '../notification/notification_page.dart';

class HelpdeskDashboard extends StatefulWidget {
  const HelpdeskDashboard({super.key});

  @override
  State<HelpdeskDashboard> createState() => _HelpdeskDashboardState();
}

class _HelpdeskDashboardState extends State<HelpdeskDashboard> {
  bool darkMode = false;
  bool isLoading = true;

  List<dynamic> notifications = [];
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    loadTickets();
    loadNotifications();
  }

  Future<void> loadTickets() async {
    // Memastikan loading state aktif saat refresh data
    setState(() => isLoading = true);
    final data = await ApiService.getMyTickets();

    setState(() {
      tickets = data;
      isLoading = false;
    });
  }

  Future<void> loadNotifications() async {
    final data = await ApiService.getNotifications();
    setState(() {
      notifications = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = darkMode ? const Color(0xff121212) : Colors.white;
    Color cardColor = darkMode ? const Color(0xff1E1E1E) : Colors.white;
    Color textColor = darkMode ? Colors.white : Colors.black87;

    int total = tickets.length;
    int open = tickets.where((e) => e["status"] == "Open").length;
    int progress = tickets.where((e) => e["status"] == "In Progress").length;
    int close = tickets.where((e) => e["status"] == "Close").length;

    // REVISI: Hitung notifikasi yang belum dibaca (is_read == 0)
    int unreadNotifications = notifications.where((e) => e["is_read"] == 0).length;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 15, bottom: 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffF57C00),
                  Color(0xffFFB300),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ApiService.currentUserName ?? "Helpdesk",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ApiService.currentUserEmail ?? "",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.8),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            darkMode ? Icons.light_mode : Icons.dark_mode,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              darkMode = !darkMode;
                            });
                          },
                        ),

                        /// NOTIFICATION
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                              ),
                              // REVISI: Menangkap nilai kembalian (result) dari NotificationPage
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationPage(
                                      role: "helpdesk",
                                    ),
                                  ),
                                );

                                // Jika kembali membawa nilai true, segarkan data badge secara real-time
                                if (result == true) {
                                  await loadNotifications();
                                }
                              },
                            ),
                            // REVISI: Menggunakan unreadNotifications untuk indikator angka badge merah
                            if (unreadNotifications > 0)
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    unreadNotifications.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                  role: ApiService.currentUserRole ?? "helpdesk",
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
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
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat("Total", total.toString()),
                    _stat("Open", open.toString()),
                    _stat("Progress", progress.toString()),
                    _stat("Close", close.toString()),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: loadTickets,
              child: ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: tickets.length,
                itemBuilder: (_, index) {
                  var t = tickets[index];
                  Color statusColor;

                  switch (t["status"]) {
                    case "Open":
                      statusColor = Colors.blue;
                      break;
                    case "In Progress":
                      statusColor = Colors.orange;
                      break;
                    default:
                      statusColor = Colors.green;
                  }

                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: statusColor.withOpacity(.15),
                        child: Icon(
                          Icons.build,
                          color: statusColor,
                        ),
                      ),
                      title: Text(
                        t["title"] ?? "-",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Status : ${t["status"]}",
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketDetailPage(
                              ticketId: t["id"],
                              role: "helpdesk",
                            ),
                          ),
                        );
                        // Refresh data setelah kembali dari detail tiket
                        loadTickets();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(.8),
          ),
        ),
      ],
    );
  }
}