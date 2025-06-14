import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../widgets/bur_drawer_user.dart';
import '../dialogs/contact_dialog.dart';
import '../dialogs/work_packages_page.dart';
import '../dialogs/news.dart';
import '../dialogs/promos.dart';
import '../widgets/hero_banner.dart';
import '../widgets/horizontal_firestore_carousel.dart';
import '../widgets/records_history_dialog.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Достаём пользователя через Bloc
    String? userUid;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUser ||
            state is AuthWorkman ||
            state is AuthSmm) {
          // Можно хранить любые пользовательские поля (email, имя и др.)
          final user = (state as dynamic).user;
          userUid = user.uid;
        }

        void showHistoryDialog() {
          if (userUid == null) return;
          showDialog(
            context: context,
            builder: (_) => RecordsHistoryDialog(
              userUid: userUid!,
              title: "История начислений",
              headerColor: Colors.deepPurple,
              evenRowColor: Colors.grey[200],
              oddRowColor: Colors.white,
            ),
          );
        }

        return Scaffold(
          drawer: SizedBox(
            width: width * 0.75,
            child: BurDrawerUser(
              onContacts: () => showContactsDialog(context),
              onPackages: () => showWorkPackageDialog(context),
              onNews: () => showNewsDialog(context),
              onPromos: () => showPromosDialog(context),
              onHistory: showHistoryDialog,
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: const Color.fromARGB(255, 255, 215, 0),
                  size: 32,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
                splashRadius: 26,
              ),
            ),
            title: null,
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/carbon_back.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.12),
                  BlendMode.lighten,
                ),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.only(top: kToolbarHeight + 28, bottom: 24),
              children: [
                const HeroBanner(),
                const SizedBox(height: 18),
                _SectionHeader(
                  title: "Новости",
                  onShowAll: () => showNewsDialog(context),
                ),
                const HorizontalFirestoreCarousel(
                  collectionPath: 'workmans/newsyvttPHBhpwZZlEWNxuHD/news',
                  titleField: 'title',
                  descField: 'description',
                  metaField: 'date',
                  isDate: true,
                  emptyMessage: 'Нет новостей',
                ),
                _SectionHeader(
                  title: "Акции",
                  onShowAll: () => showPromosDialog(context),
                ),
                const HorizontalFirestoreCarousel(
                  collectionPath: 'workmans/promo8JNwDA8Es30xRo3mQSrA/promos',
                  titleField: 'title',
                  descField: 'description',
                  metaField: 'price',
                  emptyMessage: 'Нет акций',
                ),
                _SectionHeader(
                  title: "Пакеты",
                  onShowAll: () => showWorkPackageDialog(context),
                ),
                const HorizontalFirestoreCarousel(
                  collectionPath: 'workmans/packages4d7M6mM1CiB6iLIHcPKU/packages',
                  titleField: 'title',
                  descField: 'description',
                  metaField: 'price',
                  emptyMessage: 'Нет пакетов',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onShowAll;
  const _SectionHeader({required this.title, required this.onShowAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
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
          const Spacer(),
          TextButton(
            onPressed: onShowAll,
            child: const Text(
              'Показать все',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 215, 0),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
