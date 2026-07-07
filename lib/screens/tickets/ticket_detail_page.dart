import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';

class TicketDetailPage extends StatefulWidget {
  final int ticketId; // Ini berperan sebagai TICKET ID yang dikirim dari halaman sebelumnya
  final String role;
  const TicketDetailPage({super.key, required this.ticketId, required this.role});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
final TextEditingController _replyController = TextEditingController();

Map<String, dynamic>? tiket;
List comments = [];
List history = [];
bool isLoading = true;


List<dynamic> helpdeskList = [];

@override
void initState() {
  super.initState();
  loadData();
}

Future<void> loadData() async {
  setState(() => isLoading = true);

  final detail =
  await ApiService.getTicketDetail(widget.ticketId);

  if (detail != null) {
    tiket = detail;

    comments =
    await ApiService.getComments(widget.ticketId);

    history =
    await ApiService.getHistory(widget.ticketId);

    await loadHelpdesk();
  }

  setState(() => isLoading = false);
}
Future<void> loadHelpdesk() async {
  helpdeskList = await ApiService.getHelpdeskUsers();
}
Color _getRoleColor() {
switch (widget.role.toLowerCase()) {
case 'admin': return const Color(0xFF0E458E);
case 'helpdesk': return const Color(0xFFC97E00);
case 'user': return const Color(0xFF00796D);
default: return const Color(0xFF264C8D);
}
}

Future<void> _updateStatus(String newStatus) async {
if (tiket == null) return;

bool success = await ApiService.updateStatus(widget.ticketId, newStatus);
if (success) {
_showSnackBar("Status diperbarui ke $newStatus");
loadData(); // Refresh data dari API setelah update
} else {
_showSnackBar("Gagal memperbarui status");
}
}

void _showAssignSheet() {
  Color primaryColor = _getRoleColor();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius:
      BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              "Pilih Petugas Helpdesk",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 15),

            ...helpdeskList.map((user) {

              return ListTile(

                leading: CircleAvatar(
                  backgroundColor:
                  primaryColor.withOpacity(.1),
                  child: Icon(
                    Icons.person,
                    color: primaryColor,
                  ),
                ),

                title: Text(user["name"]),

                subtitle: Text(user["email"]),

                onTap: () async {

                  Navigator.pop(context);

                  bool success =
                  await ApiService.assignTicket(
                    widget.ticketId,
                    user["id"],
                  );

                  if (success) {

                    await NotificationService.showNotification(
                      ticketId: widget.ticketId,
                      title: "Ticket Diassign",
                      body:
                      "Ticket ditugaskan ke ${user["name"]}",
                    );

                    _showSnackBar("Berhasil diassign");

                    loadData();

                  } else {

                    _showSnackBar("Gagal assign");

                  }

                },
              );

            }).toList(),
          ],
        ),
      );
    },
  );
}

  Future<void> _sendReply() async {
    if (_replyController.text.trim().isEmpty) return;

    bool success = await ApiService.sendComment(
      widget.ticketId, ApiService.currentUserId!, // sementara hardcode user login
      _replyController.text.trim(),
    );

    if (success) {
      _replyController.clear();
      await loadData(); // reload detail tiket
    } else {
      _showSnackBar("Gagal mengirim komentar");
    }
  }


void _showSnackBar(String msg) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
}

  @override
  Widget build(BuildContext context) {
    Color primaryColor = _getRoleColor();

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: primaryColor, foregroundColor: Colors.white),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (tiket == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: primaryColor, foregroundColor: Colors.white),
        body: const Center(child: Text("Data tiket tidak ditemukan atau gagal memuat.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail #${tiket!['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tiket!['title'] ?? "-", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _statusBadge(tiket!['status'] ?? "Open"),
                  const SizedBox(height: 15),

                  // Bagian Penugasan
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(Icons.assignment_ind, color: primaryColor),
                        const SizedBox(width: 10),
                        const Text("Ditugaskan: ", style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          child: Text(
                            tiket!['assigned_user']? ['name']?? "Belum ditugaskan",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 40),
                  const Text("Deskripsi:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(tiket!['description'] ?? "-", style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
                  const SizedBox(height: 25),

                  // Tombol Aksi dinamis berdasarkan role & status dari API
                  if (widget.role == "admin" &&
                      (tiket!['assigned_to'] == null ||
                          tiket!['assigned_to'] == 0))
                    _actionButton("ASSIGN TIKET", Colors.orange[700]!, Icons.person_add, _showAssignSheet),
                  if (widget.role == "helpdesk" && tiket!["status"] == "In Progress")
                  _actionButton(
                  "SELESAIKAN",
                  Colors.green,
                  Icons.check_circle,
                  () => _updateStatus("Close"),
                  ),

                  const Divider(height: 40),
                  const Text("Lampiran Foto:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildImageSection(tiket!['image']),

                  const Divider(height: 40),
                  Text("History Tracking", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 10),

                  // Bagian History (Menggunakan List dari API)
                  history.isEmpty
                      ? const Text("Belum ada riwayat aktivitas.", style: TextStyle(fontSize: 13, color: Colors.grey))
                      : Column(
                    children: history.map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(top: 6), child: Icon(Icons.circle, size: 6, color: primaryColor)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(h['activity'] ?? '-', style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    )).toList(),
                  ),

                  const Divider(height: 40),
                  Text("Chat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 10),

                  // Bagian Komentar / Diskusi (Menggunakan List dari API)
                  comments.isEmpty
                      ? const Text("Belum ada pesan.", style: TextStyle(fontSize: 13, color: Colors.grey))
                      : Column(
                    children: comments.map((c) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(c["user"]?["name"] ?? "Unknown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryColor,),),
                        subtitle: Text(c['comment'] ?? ""),
                        trailing: Text(
                          c['created_at'] != null ? c['created_at'].toString().substring(11, 16) : "",
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Input Reply
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: "Balas...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendReply,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildImageSection(String? path) {
  if (path == null || path.isEmpty) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      ),
    );
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.network(
      "http://10.0.2.2:8000/storage/tickets/$path",
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          height: 200,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image),
        );
      },
    ),
  );
}

  Widget _actionButton(String label, Color color, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

Widget _statusBadge(String status) {

  Color color;

  switch (status) {

    case "Open":
      color = Colors.blue;
      break;

    case "Assign":
      color = Colors.deepOrange;
      break;

    case "In Progress":
      color = Colors.orange;
      break;

    case "Close":
      color = Colors.green;
      break;

    default:
      color = Colors.grey;
  }

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 5,
    ),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
}