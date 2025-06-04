import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'guest_home_page.dart';
import 'qr_scanner_page.dart';
import 'workman_user_details_page.dart';
import '../utils/workman_utils.dart'; // функция проверки сотрудника + getWorkmanKeyByEmail
import 'admin_home_page.dart';
import '../dialogs/admin_login_dialog.dart';

class WorkmansHomePage extends StatefulWidget {
  const WorkmansHomePage({super.key});

  @override
  State<WorkmansHomePage> createState() => _WorkmansHomePageState();
}

class _WorkmansHomePageState extends State<WorkmansHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool? isAllowed;
  String? workmanID; // Для заголовка

  @override
  void initState() {
    super.initState();
    _checkAccess();
    _loadWorkmanID();
  }

  void _checkAccess() async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      final allowed = await isWorkmanByEmail(user.email!);
      if (mounted) {
        setState(() {
          isAllowed = allowed;
        });
        if (!allowed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => GuestHomePage()),
              (route) => false,
            );
          });
        }
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => GuestHomePage()),
          (route) => false,
        );
      });
    }
  }

  Future<void> _loadWorkmanID() async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      final key = await getWorkmanKeyByEmail(user.email!);
      setState(() {
        workmanID = key; // Может быть null
      });
    }
  }

  void _signOut() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => GuestHomePage()),
      (route) => false,
    );
  }

  void _startQRScanner() async {
    setState(() => isLoading = true);

    final qrResult = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerPage()),
    );

    setState(() => isLoading = false);

    if (qrResult != null && qrResult.isNotEmpty) {
      _handleScannedUID(qrResult);
    }
  }

  Future<void> _handleScannedUID(String userUid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();

      if (userDoc.exists) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WorkmanUserDetailsPage(
              userData: userDoc.data()!,
              userUid: userDoc.id,
              onSignOut: _signOut,
            ),
          ),
        );
      } else {
        _showUserNotFoundDialog();
      }
    } catch (e) {
      _showUserNotFoundDialog();
    }
  }

  void _showUserNotFoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Пользователь не найден"),
        content: const Text("Попробуйте еще раз"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isAllowed == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isAllowed == false) {
      return const Scaffold(body: SizedBox.shrink());
    }

    // Используем workmanID или дефолтный текст, если еще не подгрузилось
    final appBarTitle = workmanID?.isNotEmpty == true
        ? workmanID!
        : 'Рабочее пространство';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Выйти",
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _startQRScanner,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(48),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 10,
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  size: 80,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.admin_panel_settings),
        label: const Text("Права администратора"),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AdminLoginDialog(
              onSuccess: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminHomePage()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
