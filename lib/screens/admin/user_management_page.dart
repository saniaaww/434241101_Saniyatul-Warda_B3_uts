import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getUsers();
      setState(() {
        users = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar("Gagal memuat data pengguna");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0D47A1),
        foregroundColor: Colors.white,
        title: const Text(
          "Kelola Pengguna",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff0D47A1),
        onPressed: () => showAddDialog(),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: loadUsers,
        child: users.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            const Center(child: Text("Tidak ada data pengguna.")),
          ],
        )
            : ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: users.length,
          itemBuilder: (_, index) {
            final user = users[index];
            Color roleColor;

            switch (user["role"].toString().toLowerCase()) {
              case "admin":
                roleColor = Colors.blue;
                break;
              case "helpdesk":
                roleColor = Colors.orange;
                break;
              default:
                roleColor = Colors.green;
            }

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 15),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: roleColor.withOpacity(.15),
                  child: Icon(Icons.person, color: roleColor),
                ),
                title: Text(
                  user["name"] ?? "-",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user["email"] ?? "-"),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user["role"].toString().toUpperCase(),
                        style: TextStyle(color: roleColor, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    )
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "edit") showEditDialog(user);
                    if (value == "delete") deleteUser(user);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 10),
                          Text("Edit"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 10),
                          Text("Hapus", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ======================================================
  // TAMBAH USER
  // ======================================================
  void showAddDialog() {
    final name = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    String role = "user";
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Tambah User"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(labelText: "Nama"),
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Password"),
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: const InputDecoration(labelText: "Role"),
                      items: const [
                        DropdownMenuItem(value: "admin", child: Text("Admin")),
                        DropdownMenuItem(value: "helpdesk", child: Text("Helpdesk")),
                        DropdownMenuItem(value: "user", child: Text("User")),
                      ],
                      onChanged: isSubmitting
                          ? null
                          : (v) {
                        setDialogState(() => role = v!);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                    if (name.text.trim().isEmpty || email.text.trim().isEmpty || password.text.trim().isEmpty) {
                      _showSnackBar("Semua kolom wajib diisi!");
                      return;
                    }

                    setDialogState(() => isSubmitting = true);
                    bool success = await ApiService.createUser(
                      name: name.text.trim(),
                      email: email.text.trim(),
                      password: password.text,
                      role: role,
                    );
                    setDialogState(() => isSubmitting = false);

                    if (success) {
                      if (!mounted) return;
                      Navigator.pop(context);
                      _showSnackBar("User berhasil ditambahkan");
                      loadUsers();
                    } else {
                      _showSnackBar("Gagal menambahkan user");
                    }
                  },
                  child: isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text("Simpan"),
                )
              ],
            );
          },
        );
      },
    );
  }

  // ======================================================
  // EDIT USER
  // ======================================================
  void showEditDialog(dynamic user) {
    final name = TextEditingController(text: user["name"]);
    final email = TextEditingController(text: user["email"]);
    String role = ["admin", "helpdesk", "user"].contains(user["role"]) ? user["role"] : "user";
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit User"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(labelText: "Nama"),
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: const InputDecoration(labelText: "Role"),
                      items: const [
                        DropdownMenuItem(value: "admin", child: Text("Admin")),
                        DropdownMenuItem(value: "helpdesk", child: Text("Helpdesk")),
                        DropdownMenuItem(value: "user", child: Text("User")),
                      ],
                      onChanged: isSubmitting
                          ? null
                          : (v) {
                        setDialogState(() => role = v!);
                      },
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                    if (name.text.trim().isEmpty || email.text.trim().isEmpty) {
                      _showSnackBar("Nama dan Email tidak boleh kosong!");
                      return;
                    }

                    setDialogState(() => isSubmitting = true);
                    bool success = await ApiService.updateManagedUser(
                      id: user["id"],
                      name: name.text.trim(),
                      email: email.text.trim(),
                      role: role,
                    );
                    setDialogState(() => isSubmitting = false);

                    if (success) {
                      if (!mounted) return;
                      Navigator.pop(context);
                      _showSnackBar("User berhasil diperbarui");
                      loadUsers();
                    } else {
                      _showSnackBar("Gagal memperbarui user");
                    }
                  },
                  child: isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text("Update"),
                )
              ],
            );
          },
        );
      },
    );
  }

  // ======================================================
  // HAPUS USER
  // ======================================================
  void deleteUser(dynamic user) {
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Hapus User"),
              content: Text("Yakin ingin menghapus ${user["name"]} ?"),
              actions: [
                TextButton(
                  onPressed: isDeleting ? null : () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: isDeleting
                      ? null
                      : () async {
                    setDialogState(() => isDeleting = true);
                    bool success = await ApiService.deleteUser(user["id"]);
                    setDialogState(() => isDeleting = false);

                    if (success) {
                      if (!mounted) return;
                      Navigator.pop(context);
                      _showSnackBar("User berhasil dihapus");
                      loadUsers();
                    } else {
                      _showSnackBar("Gagal menghapus user");
                    }
                  },
                  child: isDeleting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text("Hapus", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}