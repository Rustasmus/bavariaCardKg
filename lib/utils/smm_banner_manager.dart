import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SmmBannerManager extends StatefulWidget {
  const SmmBannerManager({super.key});

  @override
  State<SmmBannerManager> createState() => _SmmBannerManagerState();
}

class _SmmBannerManagerState extends State<SmmBannerManager> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> _addOrEditBanner({DocumentSnapshot? doc}) async {
    final titleController = TextEditingController(text: doc?['title'] ?? '');
    final descController = TextEditingController(text: doc?['desc'] ?? '');
    final actionController = TextEditingController(text: doc?['action'] ?? '');
    int order = doc?['order'] ?? 0;
    String? imageUrl = doc?['image'];
    File? imageFile;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(doc == null ? "Добавить баннер" : "Редактировать баннер"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 82);
                    if (picked != null) {
                      setState(() {
                        imageFile = File(picked.path);
                      });
                      // Не загружаем сразу, только при подтверждении!
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageFile != null
                        ? Image.file(imageFile!, height: 110, width: 230, fit: BoxFit.cover)
                        : imageUrl != null
                            ? Image.network(imageUrl, height: 110, width: 230, fit: BoxFit.cover)
                            : Container(
                                height: 110, width: 230,
                                color: Colors.grey[300],
                                alignment: Alignment.center,
                                child: const Icon(Icons.add_a_photo, size: 32),
                              ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Заголовок"),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Описание"),
                ),
                TextField(
                  controller: actionController,
                  decoration: const InputDecoration(labelText: "Действие (action)"),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Text("Порядок:"),
                    Expanded(
                      child: Slider(
                        value: order.toDouble(),
                        min: 0,
                        max: 50,
                        divisions: 50,
                        label: order.toString(),
                        onChanged: (v) => setState(() => order = v.toInt()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
            ElevatedButton(
              onPressed: () async {
                String? uploadUrl = imageUrl;
                if (imageFile != null) {
                  final fileName = 'banners/${DateTime.now().millisecondsSinceEpoch}_${imageFile!.path.split('/').last}';
                  final ref = _storage.ref().child(fileName);
                  uploadUrl = await ref.getDownloadURL();
                }
                final bannerData = {
                  'title': titleController.text,
                  'desc': descController.text,
                  'image': uploadUrl ?? "",
                  'order': order,
                  'action': actionController.text,
                };
                if (doc == null) {
                  await _firestore.collection('banners').doc('main').collection('slides').add(bannerData);
                } else {
                  await doc.reference.update(bannerData);
                }
                Navigator.pop(context);
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
    setState(() {});
  }

  Future<void> _deleteBanner(DocumentSnapshot doc) async {
    await doc.reference.delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Управление баннерами"),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditBanner(),
        label: const Text("Добавить"),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('banners')
            .doc('main')
            .collection('slides')
            .orderBy('order')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final banners = snapshot.data!.docs;
          if (banners.isEmpty) {
            return const Center(child: Text("Нет баннеров"));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: banners.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final data = banners[i].data() as Map<String, dynamic>;
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: data['image'] != null && (data['image'] as String).isNotEmpty
                        ? Image.network(data['image'], width: 90, height: 58, fit: BoxFit.cover)
                        : Container(width: 90, height: 58, color: Colors.grey[300], child: const Icon(Icons.photo, size: 30)),
                  ),
                  title: Text(
                    data['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Text(
                    data['desc'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _addOrEditBanner(doc: banners[i]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Удалить баннер?"),
                              content: const Text("Вы уверены, что хотите удалить этот баннер?"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Нет")),
                                TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Да")),
                              ],
                            ),
                          );
                          if (confirm == true) await _deleteBanner(banners[i]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
