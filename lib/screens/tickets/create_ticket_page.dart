import 'dart:io'; // Untuk menangani file gambar
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  File? _selectedImage; // Variabel penampung foto
  final ImagePicker _picker = ImagePicker();

  bool isSubmitting = false;

  // REVISI 1: Menambahkan Fungsi Dispose (WAJIB)
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Fungsi mengambil gambar dari Kamera atau Galeri
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _showSnackBar("Foto berhasil dipilih!");
    }
  }

  Future<void> _submitTicket() async {
    if (isSubmitting) return;

    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      _showSnackBar(
        "Harap isi judul dan deskripsi!",
        Colors.red,
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    bool success = await ApiService.createTicket(
      title: _titleController.text,
      description: _descController.text,
      userId: ApiService.currentUserId!,
      image: _selectedImage,
    );

    // REVISI 2: Cek 'mounted' terlebih dahulu sebelum memanggil setState
    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });

    if (success) {
      _showSnackBar(
        "Tiket berhasil dikirim!",
        Colors.green,
      );

      Navigator.pop(context, true);
    } else {
      _showSnackBar(
        "Gagal mengirim tiket",
        Colors.red,
      );
    }
  }

  void _showSnackBar(String msg, [Color color = Colors.blue]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Laporan Tiket")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Informasi Kendala", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: _inputDecoration("Judul Laporan", Icons.title),
              enabled: !isSubmitting,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: _inputDecoration("Deskripsi Masalah", Icons.description),
              enabled: !isSubmitting,
            ),
            const SizedBox(height: 25),

            const Text("Lampiran Foto", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Preview Gambar
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: _selectedImage == null
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 50, color: Colors.grey),
                  Text("Belum ada foto dipilih", style: TextStyle(color: Colors.grey)),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 15),

            // Tombol Pilih Foto
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isSubmitting ? null : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Kamera"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isSubmitting ? null : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Galeri"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Tombol Submit
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: isSubmitting ? null : _submitTicket,
                child: isSubmitting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "KIRIM LAPORAN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}