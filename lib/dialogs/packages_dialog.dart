import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PackagesAdminDialog extends StatelessWidget {
  const PackagesAdminDialog({super.key});

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
                      builder: (_) => const AddEditPackageDialog(),
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['description'] ?? ''),
                            Text('${data['price']} сом',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: "Удалить пакет",
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Удалить пакет?"),
                                    content: const Text("Вы уверены, что хотите удалить этот пакет?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(false),
                                        child: const Text("Отмена"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () => Navigator.of(ctx).pop(true),
                                        child: const Text("Удалить"),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  await doc.reference.delete();
                                }
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

class AddEditPackageDialog extends StatefulWidget {
  final String? packageId;
  final Map<String, dynamic>? initialData;

  const AddEditPackageDialog({super.key, this.packageId, this.initialData});

  @override
  State<AddEditPackageDialog> createState() => _AddEditPackageDialogState();
}

class _AddEditPackageDialogState extends State<AddEditPackageDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.initialData?['description'] ?? '');
    _priceController = TextEditingController(text: widget.initialData?['price']?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _savePackage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final collection = FirebaseFirestore.instance
        .collection('workmans')
        .doc('packages4d7M6mM1CiB6iLIHcPKU')
        .collection('packages');
    final data = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': int.tryParse(_priceController.text.trim()) ?? 0,
    };

    if (widget.packageId == null) {
      // Добавление пакета
      await collection.add({
        ...data,
        'date': FieldValue.serverTimestamp(),
      });
    } else {
      // Редактирование
      await collection.doc(widget.packageId).update(data);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 360,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.packageId == null ? "Добавить пакет" : "Редактировать пакет",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: "Название"),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Введите название' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: "Описание"),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Введите описание' : null,
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Цена"),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Введите цену' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(),
              if (!isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    ElevatedButton(
                      onPressed: _savePackage,
                      child: Text(widget.packageId == null ? 'Добавить' : 'Сохранить'),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
