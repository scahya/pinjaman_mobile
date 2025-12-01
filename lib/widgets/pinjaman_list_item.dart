import 'package:flutter/material.dart';
import 'package:pinjaman_mobile/models/pinjaman.dart';
import 'package:pinjaman_mobile/providers/pinjaman_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class PinjamanListItem extends StatelessWidget {
  final PinjamanModel data;

  const PinjamanListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<AuthProvider>(context, listen: false).userRole;

    return role == "Admin"
        ? _AdminPinjamanItem(data: data)
        : _NasabahPinjamanItem(data: data);
  }
}

/// =======================
/// NASABAH CARD
/// =======================
class _NasabahPinjamanItem extends StatelessWidget {
  final PinjamanModel data;

  const _NasabahPinjamanItem({required this.data});

  @override
  Widget build(BuildContext context) {
    print("catatan Admin : ${data}");
    return Card(
      margin: const EdgeInsets.all(8),
      color: data.status == "Approved"
          ? Color(0xFF91f58c)
          : data.status == "Rejected"
          ? Color(0xFFfaa69d)
          : Color(0xFFd9f2fa),
      child: ListTile(
        title: Text("Jumlah: Rp ${data.jumlahPinjaman}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status: ${data.status} • Catatan: ${data.catatanAdmin ?? '-'}",
            ),
            Text("Approved By: ${data.approvedByUser?.namaLengkap ?? '-'}"),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// ADMIN CARD
/// =======================
class _AdminPinjamanItem extends StatelessWidget {
  final PinjamanModel data;

  const _AdminPinjamanItem({required this.data});

  void _openApprovalModal(BuildContext parentContext, String action) {
    final TextEditingController catatanController = TextEditingController();
    final pinjamanProvider = Provider.of<PinjamanProvider>(
      parentContext,
      listen: false,
    );

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          action == "approve" ? "Approve Pinjaman" : "Reject Pinjaman",
        ),

        content: TextField(
          controller: catatanController,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Catatan Admin",
          ),
        ),

        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(dialogContext),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: action == "approve" ? Colors.green : Colors.red,
            ),
            child: Text(
              action == "approve" ? "Approve" : "Reject",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final catatanAdmin = catatanController.text.trim();
              print("Data id ${data.id}");
              print("Data noote ${catatanAdmin}");
              print("Data action ${action}");
              final success = await pinjamanProvider.putApproveRejectPinjaman(
                data.id,
                catatanAdmin,
                action == "approve" ? "Approved" : "Rejected",
              );

              Navigator.pop(dialogContext); // hanya tutup modal

              if (success) {
                final message = action == "approve"
                    ? "Pinjaman berhasil di-approve"
                    : "Pinjaman berhasil di-reject";

                final color = action == "approve" ? Colors.green : Colors.red;

                /// Gunakan parentContext yang masih valid
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: color,
                    duration: const Duration(seconds: 2),
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text("Berhasil memproses pinjaman"),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: data.status == "Approved"
          ? Color(0xFF91f58c)
          : data.status == "Rejected"
          ? Color(0xFFfaa69d)
          : Color(0xFFd9f2fa),
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text("Nasabah: ${data.namaLengkap}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nik: ${data.nik}"),
            Text("Jumlah: Rp ${data.jumlahPinjaman}"),
            Text("Status: ${data.status}"),
            Text("${data.createdAt}"),
          ],
        ),

        trailing: PopupMenuButton(
          onSelected: (value) {
            _openApprovalModal(context, value);
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: "approve", child: Text("Approve")),
            const PopupMenuItem(value: "reject", child: Text("Reject")),
          ],
        ),
      ),
    );
  }
}
