import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/ui/user/user_ui_bloc.dart';
import '../bloc/ui/user/user_ui_event.dart';
import '../widgets/stroke_text.dart';
import '../widgets/bur_buttons.dart';

class BurDrawerUser extends StatefulWidget {
  const BurDrawerUser({super.key});

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
    final authState = context.read<AuthBloc>().state;
    String? uid;
    if (authState is AuthUser) {
      uid = authState.user.uid;
    } else if (authState is AuthWorkman || authState is AuthSmm) {
      uid = (authState as dynamic).user.uid;
    }
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final recordsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('records');
      final lastRecordSnapshot =
          await recordsRef.orderBy('date', descending: true).limit(1).get();

      setState(() {
        userProfile = userDoc.data();
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
    String? uid;
    String fio = "";
    final authState = context.watch<AuthBloc>().state;
    if (authState is AuthUser) {
      uid = authState.user.uid;
    } else if (authState is AuthWorkman || authState is AuthSmm) {
      uid = (authState as dynamic).user.uid;
    }

    fio = [
      userProfile?['firstName'] ?? '',
      userProfile?['middleName'] ?? ''
    ].where((e) => e.toString().isNotEmpty).join(' ');

    // Получаем BLoC для отправки событий
    final userUiBloc = context.read<UserUiBloc>();
    final authBloc = context.read<AuthBloc>();

    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/main_fon_grad.png'),
          fit: BoxFit.cover,
        ),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black87,
            Colors.transparent,
          ],
          stops: [0, 0.7],
        ),
        color: const Color.fromARGB(255, 22, 88, 142).withOpacity(0.16),
      ),
      child: Column(
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
                const SizedBox(width: 18),
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
                                fio,
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
                            const Icon(Icons.star_border_sharp,
                                color: Color.fromARGB(255, 22, 88, 142), size: 22),
                            const SizedBox(width: 6),
                            Text(
                              isLoading
                                  ? '...'
                                  : bonusAvailable?.toStringAsFixed(2) ?? "0.00",
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
                if (uid != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 18, top: 18),
                    child: GestureDetector(
                      onTap: () => _showQRDialog(context, uid!),
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
                            color: Color.fromARGB(255, 22, 88, 142), size: 40),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          GradientActionButton(
            icon: Icons.local_offer,
            label: 'Акции',
            onTap: () {
              Navigator.of(context).pop();
              userUiBloc.add(ShowPromosDialog());
            },
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.history,
            label: 'История',
            onTap: () {
              Navigator.of(context).pop();
              userUiBloc.add(ShowHistoryDialog());
            },
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.newspaper,
            label: 'Новости',
            onTap: () {
              Navigator.of(context).pop();
              userUiBloc.add(ShowNewsDialog());
            },
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.folder,
            label: 'Пакеты',
            onTap: () {
              Navigator.of(context).pop();
              userUiBloc.add(ShowPackagesDialog());
            },
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.contacts,
            label: 'Контакты',
            onTap: () {
              Navigator.of(context).pop();
              userUiBloc.add(ShowContactsDialog());
            },
          ),

          const Spacer(),

          // --- Кнопка ВЫЙТИ ---
          const SizedBox(height: 12),
          SizedBox(
            height: 40, // ниже
            width: 170, // уже
            child: GradientActionButton(
              icon: Icons.exit_to_app,
              label: 'Выйти',
              onTap: () {
                Navigator.of(context).pop();
                authBloc.add(AuthLogoutRequested());
              },
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade400,
                  Colors.red.shade800,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // --- конец кнопки выйти ---

          // const Spacer(),

          // Затемняющий градиент под copyright
          Container(
            width: double.infinity,
            height: 70,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black87,
                ],
                stops: [0.1, 1],
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: StrokeText(
                text: "Bavaria.kg © \n 2009-2025",
                fontSize: 15,
                strokeColor: Colors.black,
                textColor: Colors.grey,
                strokeWidth: 1.1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
