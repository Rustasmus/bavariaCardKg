import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_edit_package_dialog.dart'; // (создадим ниже)

class PackagesDialog extends StatelessWidget {
  const PackagesDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final collection = FirebaseFirestore.instance
        .collection('workmans')
        .doc('packages4d7M6mM1CiB6iLIHcPKU')
        .collection('packages');

    return Dialog(
      child: SizedBox(
        width: 400,
        height: 600,
        child: Column(
          children: [
            AppBar(
              title: const Text('Пакеты'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: "Добавить пакет",
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => AddEditPackageDialog(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: "Закрыть",
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: collection.orderBy('date', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(child: Text("Нет пакетов"));
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['title'] ?? ''),
                        subtitle: Text(data['description'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("${data['price'] ?? ''} сом"),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: "Редактировать",
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) => AddEditPackageDialog(
                                    packageId: doc.id,
                                    initialData: data,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
