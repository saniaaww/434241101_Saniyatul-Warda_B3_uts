import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/login_page.dart';
import '../notification/notification_page.dart';
import '../profile/profile_screen.dart';
import '../tickets/ticket_detail_page.dart';
import '../admin/user_management_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isLocalDarkMode = false;

  List<dynamic> tickets = [];
  List<dynamic> helpdeskList = [];
  int? selectedHelpdesk;

  // REVISI LOGIKA NOTIFIKASI BARU
  bool hasUnread = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTickets();
    loadHelpdesk();
    loadNotifications(); // Memicu pengecekan notifikasi saat dashboard dibuka
  }

  Future<void> loadTickets() async {
    setState(() => isLoading = true);
    final data = await ApiService.getTickets();

    if (!mounted) return;
    setState(() {
      tickets = data;
      isLoading = false;
    });
  }

  Future<void> loadHelpdesk() async {
    final data = await ApiService.getHelpdeskUsers();
    if (!mounted) return;
    setState(() {
      helpdeskList = data;
    });
  }

  // REVISI: Menggunakan fungsi loadNotifications() baru sesuai instruksi kamu
  Future<void> loadNotifications() async {
    final data = await ApiService.getNotifications();

    if (!mounted) return;
    setState(() {
      hasUnread = data.any((e) => e["is_read"] == 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = _isLocalDarkMode ? const Color(0xFF121212) : Colors.grey.shade100;
    Color cardColor = _isLocalDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = _isLocalDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = _isLocalDarkMode ? Colors.white70 : Colors.black54;

    int total = tickets.length;
    int open = tickets.where((e) => e['status'] == "Open").length;
    int progress = tickets.where((e) => e['status'] == "In Progress").length;
    int close = tickets.where((e) => e['status'] == "Close").length;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 10, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isLocalDarkMode
                    ? const [Color(0xFF1A1A1A), Color(0xFF2C2C2C)]
                    : const [Color(0xFF0D47A1), Color(0xFF1976D2)],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Admin",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        /// DARK MODE
                        IconButton(
                          icon: Icon(_isLocalDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isLocalDarkMode = !_isLocalDarkMode;
                            });
                          },
                        ),

                        /// REVISI: ICON NOTIFIKASI DENGAN BADGE TITIK MERAH (hasUnread)
                        IconButton(
                          icon: Stack(
                            children: [
                              const Icon(Icons.notifications, color: Colors.white),
                              if (hasUnread)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationPage(role: "admin"),
                              ),
                            );

                            // WAJIB melakukan refresh data notifikasi setelah kembali dari NotificationPage
                            if (result == true) {
                              await loadNotifications();
                            }
                          },
                        ),

                        /// KELOLA USER
                        IconButton(
                          icon: const Icon(Icons.group, color: Colors.white),
                          tooltip: "Kelola User",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const UserManagementPage()),
                            );
                          },
                        ),

                        /// PROFILE
                        IconButton(
                          icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ProfileScreen(role: "Administrator")),
                            );
                          },
                        ),

                        /// LOGOUT
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
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
                    _statItem("Total", total.toString()),
                    _statItem("Open", open.toString()),
                    _statItem("Progress", progress.toString()),
                    _statItem("Close", close.toString()),
                  ],
                ),
              ],
            ),
          ),

          /// DROPDOWN FILTER HELPDESK
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: DropdownButtonFormField<int>(
              value: selectedHelpdesk,
              dropdownColor: cardColor,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Filter Helpdesk",
                labelStyle: TextStyle(color: subTextColor),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text("Semua Helpdesk"),
                ),
                ...helpdeskList.map((e) {
                  return DropdownMenuItem<int>(
                    value: e["id"],
                    child: Text(e["name"] ?? "-"),
                  );
                })
              ],
              onChanged: (value) async {
                setState(() {
                  selectedHelpdesk = value;
                  isLoading = true;
                });

                if (value == null) {
                  await loadTickets();
                } else {
                  final filteredTickets = await ApiService.getTicketByHelpdesk(value);
                  if (!mounted) return;
                  setState(() {
                    tickets = filteredTickets;
                    isLoading = false;
                  });
                }
              },
            ),
          ),

          /// LIST TICKET
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () async {
                await loadNotifications(); // Sekalian pull-to-refresh status notifikasi
                if (selectedHelpdesk == null) {
                  await loadTickets();
                } else {
                  final filteredTickets = await ApiService.getTicketByHelpdesk(selectedHelpdesk!);
                  if (!mounted) return;
                  setState(() => tickets = filteredTickets);
                }
              },
              child: tickets.isEmpty
                  ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Center(child: Text("Tidak ada tiket untuk helpdesk ini.", style: TextStyle(color: subTextColor))),
                ],
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  var t = tickets[index];

                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        t['title'] ?? "-",
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Status : ${t['status']}",
                        style: TextStyle(color: subTextColor),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketDetailPage(ticketId: t['id'], role: "admin"),
                          ),
                        );

                        if (!mounted) return;
                        await loadNotifications(); // Refresh notifikasi setelah kembali dari detail tiket
                        if (selectedHelpdesk == null) {
                          await loadTickets();
                        } else {
                          final filteredTickets = await ApiService.getTicketByHelpdesk(selectedHelpdesk!);
                          setState(() => tickets = filteredTickets);
                        }
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

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}