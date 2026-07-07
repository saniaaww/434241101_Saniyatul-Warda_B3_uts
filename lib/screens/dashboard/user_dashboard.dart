import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../tickets/ticket_detail_page.dart';
import '../auth/login_page.dart';
import '../tickets/create_ticket_page.dart';
import '../profile/profile_screen.dart';
import '../notification/notification_page.dart'; // REVISI: Import NotificationPage

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  bool _isLocalDarkMode = false;

  List<dynamic> tickets = [];
  List<dynamic> notifications = []; // REVISI: Tambahkan tampungan data notifikasi
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTickets();
    loadNotifications(); // REVISI: Load data notifikasi saat init
  }

  Future<void> loadTickets() async {
    setState(() => isLoading = true);
    final data = await ApiService.getMyUserTickets();

    setState(() {
      tickets = data;
      isLoading = false;
    });
  }

  // REVISI: Mengambil data notifikasi asli dari server
  Future<void> loadNotifications() async {
    final data = await ApiService.getNotifications();
    setState(() {
      notifications = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definisi warna berdasarkan state _isLocalDarkMode
    Color bgColor = _isLocalDarkMode ? const Color(0xFF121212) : Colors.white;
    Color headerColor = _isLocalDarkMode ? const Color(0xFF1F1F1F) : Colors.teal;
    Color cardColor = _isLocalDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = _isLocalDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = _isLocalDarkMode ? Colors.white70 : Colors.black54;

    int total = tickets.length;
    int open = tickets.where((e) => e["status"] == "Open").length;
    int progress = tickets.where((e) => e["status"] == "In Progress").length;
    int close = tickets.where((e) => e["status"] == "Close").length;

    // REVISI: Hitung jumlah notifikasi yang belum dibaca (is_read == 0)
    int unreadNotifications = notifications.where((e) => e["is_read"] == 0).length;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: headerColor,
        title: const Text("Tiket Saya", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          // TOMBOL TOGGLE DARK MODE LOKAL
          IconButton(
            icon: Icon(_isLocalDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: () {
              setState(() {
                _isLocalDarkMode = !_isLocalDarkMode;
              });
            },
          ),

          /// NOTIFICATION BADGE
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                // REVISI: Buka NotificationPage asli dan tangkap result kembaliannya
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationPage(role: "user"),
                    ),
                  );

                  // Jika kembali membawa nilai true, hapus / update jumlah badge secara real-time
                  if (result == true) {
                    await loadNotifications();
                  }
                },
              ),
              // REVISI: Menggunakan unreadNotifications untuk menampilkan angka di badge merah
              if (unreadNotifications > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen(role: "Mahasiswa"))),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false),
          )
        ],
      ),
      body: Column(
        children: [
          // Statistik Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _userStat("Total", total.toString()),
                _userStat("Open", open.toString()),
                _userStat("Progress", progress.toString()),
                _userStat("Close", close.toString()),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () async {
                await loadTickets();
                await loadNotifications();
              },
              child: tickets.isEmpty
                  ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Center(child: Text("Anda belum membuat tiket laporan.", style: TextStyle(color: subTextColor))),
                ],
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  var t = tickets[index];
                  return Card(
                    color: cardColor,
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(t['title'] ?? "-", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      subtitle: Text("Status: ${t['status']}", style: TextStyle(color: subTextColor)),
                      trailing: const Icon(Icons.track_changes, color: Colors.teal),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketDetailPage(ticketId: t['id'], role: 'user'),
                          ),
                        );
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () async {
          // REVISI: Menerima hasil navigator kembalian dari CreateTicketPage
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTicketPage()),
          );

          // Jika sukses membuat tiket (mengembalikan nilai true), jalankan refresh data otomatis
          if (result == true) {
            loadTickets();
          }
        },
        label: const Text("Buat Tiket", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _userStat(String label, String val) {
    return Column(children: [
      Text(val, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: Colors.white70)),
    ]);
  }
}