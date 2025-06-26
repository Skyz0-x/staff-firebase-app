import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StaffForm extends StatefulWidget {
  final DocumentSnapshot? staff;
  const StaffForm({super.key, this.staff});

  @override
  State<StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _age = TextEditingController();

  @override
  void initState() {
    if (widget.staff != null) {
      final data = widget.staff!.data() as Map<String, dynamic>;
      _name.text = data['name'];
      _id.text = data['id'];
      _age.text = data['age'].toString();
    }
    super.initState();
  }

  void _saveStaff() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _name.text.trim(),
        'id': _id.text.trim(),
        'age': int.tryParse(_age.text.trim()) ?? 0,
      };

      final ref = FirebaseFirestore.instance.collection('staff');

      if (widget.staff == null) {
        ref.add(data);
      } else {
        ref.doc(widget.staff!.id).update(data);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.staff != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Staff' : 'Add Staff')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v!.isEmpty ? 'Enter name' : null,
            ),
            TextFormField(
              controller: _id,
              decoration: const InputDecoration(labelText: 'ID'),
              validator: (v) => v!.isEmpty ? 'Enter ID' : null,
            ),
            TextFormField(
              controller: _age,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
              validator: (v) =>
                  int.tryParse(v!) == null ? 'Enter valid age' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveStaff,
              child: Text(isEdit ? 'Update' : 'Save'),
            ),
          ]),
        ),
      ),
    );
  }
}
