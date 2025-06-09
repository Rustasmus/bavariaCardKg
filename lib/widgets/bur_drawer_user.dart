import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class BurDrawerUser extends StatefulWidget {
  final VoidCallback? onContacts;
  final VoidCallback? onPackages;
  final VoidCallback? onNews;
  final VoidCallback? onPromos;
  final VoidCallback? onHistory;
  final VoidCallback? onLogout;

  const BurDrawerUser({
    this.onContacts,
    this.onPackages,
    this.onNews,
    this.onPromos,
    this.onHistory,
    this.onLogout,
    super.key,
  });

  @override
  State<BurDrawerUser> createState() => _BurDrawerUserState();
}

class _BurDrawerUserState extends State<BurDrawerUser> {
  Map<String, dynamic>? userProfile;
  double? bonusAvailable;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      final data = await authService.fetchUserProfile(user.uid);
      final recordsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('records');
      final lastRecordSnapshot =
          await recordsRef.orderBy('date', descending: true).limit(1).get();

      setState(() {
        userProfile = data;
        isLoading = false;
        if (lastRecordSnapshot.docs.isNotEmpty) {
          final docData = lastRecordSnapshot.docs.first.data();
          bonusAvailable =
              (docData['bonus_available'] as num?)?.toDouble() ?? 0.0;
        } else {
          bonusAvailable = 0.0;
        }
      });
    }
  }

  void _showQRDialog(BuildContext context, String uid) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Ваш QR-код"),
      content: Center(
        child: SizedBox(
          width: 220,
          height: 220,
          child: QrImageView(
            data: uid,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Stack(
      children: [
        // Фон (carbon)
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/carbon_bra.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.white.withOpacity(0.16),
        ),
        Column(
          children: [
            // Верхняя карточка с ФИО, бонусами и QR
            Container(
              height: 158,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 28, left: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isLoading
                              ? const SizedBox(
                                  width: 60, height: 18, child: LinearProgressIndicator(),
                                )
                              : Text(
                                  '${userProfile?['firstName'] ?? ''} ${userProfile?['middleName'] ?? ''}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 5,
                                        offset: Offset(1, 2),
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Color.fromARGB(255, 255, 215, 0), size: 22),
                              const SizedBox(width: 6),
                              Text(
                                isLoading
                                    ? '...'
                                    : '${bonusAvailable?.toStringAsFixed(2) ?? "0.00"}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Бонусов',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (user != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 18, top: 18),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Сначала закрыть Drawer!
                          Future.delayed(const Duration(milliseconds: 180), () {
                            _showQRDialog(context, user.uid);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.20),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.qr_code_2,
                              color: Color.fromARGB(255, 255, 215, 0), size: 40),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Основные пункты меню
            _DrawerItem(
              icon: Icons.percent,
              text: 'Акции',
              color: const Color.fromARGB(255, 255, 215, 0),
              onTap: widget.onPromos ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.history,
              text: 'История',
              color: const Color.fromARGB(255, 255, 215, 0),
              onTap: widget.onHistory ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.newspaper,
              text: 'Новости',
              color: const Color.fromARGB(255, 255, 215, 0),
              onTap: widget.onNews ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.card_giftcard,
              text: 'Пакеты',
              color: const Color.fromARGB(255, 255, 215, 0),
              onTap: widget.onPackages ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.contacts,
              text: 'Контакты',
              color: const Color.fromARGB(255, 255, 215, 0),
              onTap: widget.onContacts ?? () => Navigator.pop(context),
            ),
            const Spacer(),
            // Кнопка "Выйти"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                label: const Text("Выйти", style: TextStyle(fontSize: 17)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade400,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 2,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: widget.onLogout,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Text(
                "Bavaria.kg © \n 2009-2025",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const _DrawerItem({
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: color),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      hoverColor: Colors.blueGrey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
    );
  }
}
