import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_form.dart';

class StaffList extends StatelessWidget {
  const StaffList({super.key});

  void _openForm(BuildContext context, [DocumentSnapshot? staff]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StaffForm(staff: staff)),
    );
  }

  void _deleteStaff(String docId) {
    FirebaseFirestore.instance.collection('staff').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final staffRef = FirebaseFirestore.instance.collection('staff');

    return Scaffold(
      appBar: AppBar(title: const Text('Staff List')),
      body: StreamBuilder(
        stream: staffRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading staff.'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return const Center(child: Text('No staff found.'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(data['name']),
                  subtitle: Text("ID: ${data['id']} | Age: ${data['age']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(context, docs[index])),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteStaff(docs[index].id)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
