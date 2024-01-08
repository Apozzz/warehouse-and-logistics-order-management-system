import 'package:flutter/material.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';

class AddEditSectorForm extends StatefulWidget {
  final Sector? sector; // Null if adding a new sector
  final String companyId;
  final Function(Sector) onSubmit;

  const AddEditSectorForm({
    Key? key,
    this.sector,
    required this.companyId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _AddEditSectorFormState createState() => _AddEditSectorFormState();
}

class _AddEditSectorFormState extends State<AddEditSectorForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sector != null) {
      // Initialize form fields with existing sector data
      _nameController.text = widget.sector!.name;
      _descriptionController.text = widget.sector!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Sector Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter sector name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newSector = Sector(
                    id: widget.sector?.id ?? '', // Keep existing ID if editing
                    companyId: widget.companyId,
                    name: _nameController.text,
                    description: _descriptionController.text,
                  );
                  widget.onSubmit(newSector);
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
