import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../tickets/ticket_detail_page.dart';
import 'notification_card.dart';

class NotificationPage extends StatefulWidget {
  final String role;

  const NotificationPage({
    super.key,
    required this.role,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  List<dynamic> notifications = [];

  Color get primaryColor {
    switch (widget.role.toLowerCase()) {
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
    loadNotification();
  }

  // REVISI 1: Saat halaman dibuka, semua notifikasi otomatis ditandai terbaca
  Future<void> loadNotification() async {
    setState(() => isLoading = true);

    final data = await ApiService.getNotifications();

    // Loop untuk membaca semua notifikasi yang status is_read-nya masih 0
    for (var item in data) {
      if (item["is_read"] == 0) {
        await ApiService.readNotification(item["id"]);
      }
    }

    // Ambil data terbaru setelah semuanya diubah menjadi terbacaca di server
    final updated = await ApiService.getNotifications();

    if (!mounted) return;

    setState(() {
      notifications = updated;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // REVISI BONUS: Membungkus Scaffold dengan PopScope agar mengirim data 'true' ke Dashboard saat kembali
    return PopScope(
      canPop: false, // Menahan pop bawaan untuk meng-override kustom pop di bawah
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, true); // Mengirim balik nilai true
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Notifikasi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // Kustom tombol back di AppBar agar memicu PopScope dengan benar
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : notifications.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 70,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 15),
              Text(
                "Belum ada notifikasi",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: loadNotification,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NotificationCard(
                  notification: item,
                  // REVISI 2: Di sini tidak perlu panggil ApiService.readNotification lagi
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TicketDetailPage(
                          ticketId: item["ticket_id"],
                          role: widget.role,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}