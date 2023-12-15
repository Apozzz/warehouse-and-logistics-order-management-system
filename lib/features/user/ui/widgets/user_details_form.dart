import 'package:flutter/material.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:provider/provider.dart';

class UserDetailsForm extends StatefulWidget {
  final User user;

  const UserDetailsForm({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _email, _phoneNumber;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _email = widget.user.email;
    _phoneNumber = widget.user.phoneNumber;
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);

      try {
        // Create a new User instance with updated values
        User updatedUser = User(
          id: widget.user.id,
          name: _name,
          email: _email,
          phoneNumber: _phoneNumber,
          createdAt: widget.user.createdAt,
          companyIds: widget.user.companyIds,
        );

        // Use Provider to access UserDAO and update the user
        await Provider.of<UserDAO>(context, listen: false)
            .updateUser(updatedUser);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
        );
        Navigator.of(context).pop(); // Navigate back on success
      } catch (e) {
        // Handle any errors here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update user')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Name field
          TextFormField(
            initialValue: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            onSaved: (value) => _name = value!,
            validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
          ),
          // Email field
          TextFormField(
            initialValue: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            onSaved: (value) => _email = value!,
            validator: (value) =>
                value!.isEmpty ? 'Please enter an email' : null,
          ),
          // Phone Number field
          TextFormField(
            initialValue: _phoneNumber,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            onSaved: (value) => _phoneNumber = value!,
            validator: (value) =>
                value!.isEmpty ? 'Please enter a phone number' : null,
          ),
          // Save button
          ElevatedButton(
            onPressed: _isLoading ? null : _saveForm,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Save'),
          ),
        ],
      ),
    );
  }
}
