import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sender = notification["sender"]?["name"] ?? "-";
    final title = notification["title"] ?? "";
    final message = notification["message"] ?? "";

    final createdAt = DateTime.tryParse(
      notification["created_at"] ?? "",
    );

    final isRead = notification["is_read"] == 1;

    // REVISI 2: Membedakan warna latar belakang dan elevasi seluruh Card
    return Card(
      color: isRead ? Colors.white : Colors.blue.shade50,
      elevation: isRead ? 2 : 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // REVISI 1: Menggunakan .withValues() menggantikan .withOpacity() yang deprecated
                  color: isRead
                      ? Colors.grey.shade200
                      : Colors.blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                // REVISI 5: Membedakan bentuk Icon berdasarkan status baca
                child: Icon(
                  isRead ? Icons.notifications_none : Icons.notifications_active,
                  color: isRead ? Colors.grey : Colors.blue,
                  size: 28,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isRead ? Colors.black54 : Colors.black,
                      ),
                    ),

                    // REVISI 4: Menambahkan label teks status di bawah judul
                    const SizedBox(height: 3),
                    Text(
                      isRead ? "Sudah dibaca" : "Belum dibaca",
                      style: TextStyle(
                        color: isRead ? Colors.grey : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),
                    Text(
                      "Dari : $sender",
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 5),
                    // REVISI 6: Membuat teks isi pesan menjadi tebal jika belum dibaca
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          createdAt == null
                              ? "-"
                              : "${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // REVISI 3: Mengubah titik merah kecil menjadi Badge teks "NEW" ala Gmail
              if (!isRead)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "NEW",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}