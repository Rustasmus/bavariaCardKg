import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewsDialog extends StatelessWidget {
  const NewsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final collection = FirebaseFirestore.instance
        .collection('workmans')
        .doc('newsyvttPHBhpwZZlEWNxuHD')
        .collection('news');

    return Dialog(
      child: SizedBox(
        width: 400,
        height: 600,
        child: Column(
          children: [
            AppBar(
              title: const Text('Новости'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: "Добавить новость",
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => const AddEditNewsDialog(),
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
                    return const Center(child: Text("Нет новостей"));
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      // Получаем дату и форматируем
                      String dateStr = '';
                      final timestamp = data['date'];
                      if (timestamp != null && timestamp is Timestamp) {
                        final date = timestamp.toDate();
                        dateStr = DateFormat('dd/MM/yy').format(date);
                      }

                      return ListTile(
                        title: Text(data['title'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['description'] ?? ''),
                            if (dateStr.isNotEmpty)
                              Text(
                                dateStr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: "Редактировать",
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (_) => AddEditNewsDialog(
                                newsId: doc.id,
                                initialData: data,
                              ),
                            );
                          },
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

class AddEditNewsDialog extends StatefulWidget {
  final String? newsId;
  final Map<String, dynamic>? initialData;

  const AddEditNewsDialog({super.key, this.newsId, this.initialData});

  @override
  State<AddEditNewsDialog> createState() => _AddEditNewsDialogState();
}

class _AddEditNewsDialogState extends State<AddEditNewsDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.initialData?['description'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final collection = FirebaseFirestore.instance
        .collection('workmans')
        .doc('newsyvttPHBhpwZZlEWNxuHD')
        .collection('news');
    final data = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
    };

    if (widget.newsId == null) {
      // Добавление новости
      await collection.add({
        ...data,
        'date': FieldValue.serverTimestamp(),
      });
    } else {
      // Редактирование
      await collection.doc(widget.newsId).update(data);
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
                widget.newsId == null ? "Добавить новость" : "Редактировать новость",
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
                      onPressed: _saveNews,
                      child: Text(widget.newsId == null ? 'Добавить' : 'Сохранить'),
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
