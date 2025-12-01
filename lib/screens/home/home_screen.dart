import 'package:flutter/material.dart';
import 'package:pinjaman_mobile/providers/auth_provider.dart';
import 'package:pinjaman_mobile/providers/pinjaman_provider.dart';
import 'package:pinjaman_mobile/screens/auth/login_screen.dart';
import 'package:pinjaman_mobile/screens/nasabah/pengajuan_form.dart';
import 'package:pinjaman_mobile/widgets/pinjaman_list_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<PinjamanProvider>(
      context,
      listen: false,
    ).fetchPinjamanList();
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  void _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinjamanProvider = Provider.of<PinjamanProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard ${authProvider.userRole}")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PengajuanForm()),
                    );
                  },
                  child: const Text(
                    "Ajukan Pinjaman",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),

          // LIST SECTION
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _buildList(pinjamanProvider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(PinjamanProvider provider) {
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return ListView(
        children: [
          const SizedBox(height: 200),
          Center(
            child: Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      );
    }

    if (provider.pinjamanList.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 200),
          Center(
            child: Text(
              "Belum ada pengajuan pinjaman",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: provider.pinjamanList.length,
      itemBuilder: (context, index) {
        final item = provider.pinjamanList[index];
        return PinjamanListItem(data: item);
      },
    );
  }
}
