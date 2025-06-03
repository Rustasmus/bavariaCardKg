import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'guest_home_page.dart';
import 'qr_scanner_page.dart';
import 'workman_user_details_page.dart';
import '../utils/workman_utils.dart'; // не забудь добавить!

class WorkmansHomePage extends StatefulWidget {
  const WorkmansHomePage({super.key});

  @override
  State<WorkmansHomePage> createState() => _WorkmansHomePageState();
}

class _WorkmansHomePageState extends State<WorkmansHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool? isAllowed; // null - еще не проверили, false - нет доступа, true - есть доступ

  @override
  void initState() {
    super.initState();
    _checkAccess();
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
          // Если не сотрудник — выкидываем на гостевой экран
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => GuestHomePage()),
              (route) => false,
            );
          });
        }
      }
    } else {
      // Нет пользователя — тоже на guest
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => GuestHomePage()),
          (route) => false,
        );
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
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userUid).get();

      if (userDoc.exists) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WorkmanUserDetailsPage(
              userData: userDoc.data()!,
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
      // Пока не знаем, разрешено или нет — просто показываем лоадер
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isAllowed == false) {
      // Не разрешено — будет редирект, но можно просто пустой экран
      return const Scaffold(body: SizedBox.shrink());
    }

    // Всё ок, сотрудник в системе!
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рабочее пространство'),
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
    );
  }
}
