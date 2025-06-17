import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui/guest/guest_ui_bloc.dart';
import '../bloc/ui/guest/guest_ui_event.dart';
import '../bloc/ui/guest/guest_ui_state.dart';

import '../widgets/bur_drawer.dart';
import '../dialogs/login_dialog.dart';
import '../dialogs/contact_dialog.dart';
import '../dialogs/packages.dart';
import '../dialogs/news.dart';
import '../dialogs/promos.dart';
import '../widgets/hero_banner.dart';
import '../widgets/horizontal_firestore_carousel.dart';
import '../widgets/animated_logo_f.dart';

class GuestHomePage extends StatelessWidget {
  const GuestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => GuestUiBloc(),
      child: BlocListener<GuestUiBloc, GuestUiState>(
        listener: (context, state) {
          if (state is GuestUiShowDialog) {
            final event = state.dialogEvent;
            if (event is ShowLoginDialog) {
              showDialog(context: context, builder: (_) => const LoginDialog());
            } else if (event is ShowContactsDialog) {
              showContactsDialog(context);
            } else if (event is ShowPackagesDialog) {
              showPackagesDialog(context, initialIndex: 0);
            } else if (event is ShowNewsDialog) {
              showNewsDialog(context, initialIndex: 0);
            } else if (event is ShowPromosDialog) {
              showPromosDialog(context, initialIndex: 0);
            }
          }
        },
        child: Scaffold(
          drawer: Builder(
            builder: (drawerContext) => SizedBox(
              width: width * 0.75,
              child: BurDrawer(
                onLogin: () => drawerContext.read<GuestUiBloc>().add(ShowLoginDialog()),
                onContacts: () => drawerContext.read<GuestUiBloc>().add(ShowContactsDialog()),
                onPackages: () => drawerContext.read<GuestUiBloc>().add(ShowPackagesDialog()),
                onNews: () => drawerContext.read<GuestUiBloc>().add(ShowNewsDialog()),
                onPromos: () => drawerContext.read<GuestUiBloc>().add(ShowPromosDialog()),
              ),
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: const Color.fromARGB(255, 22, 88, 142),
                  size: 32,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
                splashRadius: 26,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: LogoShine(
                  size: 250, assetPath: 'assets/images/logoF.png'),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main_fon_grad.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.only(top: kToolbarHeight + 28, bottom: 24),
              children: [
                const HeroBanner(),
                const SizedBox(height: 18),
                _SectionHeader(
                  icon: Icons.article,
                  title: "Новости",
                  onShowAll: () => context.read<GuestUiBloc>().add(ShowNewsDialog()),
                ),
                HorizontalFirestoreCarousel(
                  collectionPath: 'workmans/newsyvttPHBhpwZZlEWNxuHD/news',
                  titleField: 'title',
                  descField: 'description',
                  metaField: 'date',
                  isDate: true,
                  emptyMessage: 'Нет новостей',
                  onCardTap: (data, idx) {
                    showNewsDialog(context, initialIndex: idx);
                  },
                ),
                _SectionHeader(
                  icon: Icons.local_offer,
                  title: "Акции",
                  onShowAll: () => context.read<GuestUiBloc>().add(ShowPromosDialog()),
                ),
                HorizontalFirestoreCarousel(
                  collectionPath: 'workmans/promo8JNwDA8Es30xRo3mQSrA/promos',
                  titleField: 'title',
                  descField: 'description',
                  metaField: 'price',
                  emptyMessage: 'Нет акций',
                  onCardTap: (data, idx) {
                    showPromosDialog(context, initialIndex: idx);
                  },
                ),
                _SectionHeader(
                  icon: Icons.folder,
                  title: "Пакеты",
                  onShowAll: () => context.read<GuestUiBloc>().add(ShowPackagesDialog()),
                ),
                HorizontalFirestoreCarousel(
                  collectionPath: 'workmans/packages4d7M6mM1CiB6iLIHcPKU/packages',
                  titleField: 'title',
                  descField: 'description',
                  metaField: 'price',
                  emptyMessage: 'Нет пакетов',
                  onCardTap: (data, idx) {
                    showPackagesDialog(context, initialIndex: idx);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Вынесенный SectionHeader без изменений:
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onShowAll;
  const _SectionHeader({required this.icon, required this.title, required this.onShowAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0, 1.8),
                blurRadius: 2,
                color: Colors.black45,
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 7,
                  offset: Offset(1, 1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
