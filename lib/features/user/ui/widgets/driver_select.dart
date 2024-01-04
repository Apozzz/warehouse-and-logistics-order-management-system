import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/features/user/services/user_service.dart';
import 'package:provider/provider.dart';

class DriverSelect extends StatefulWidget {
  final String? initialDriverId;
  final Function(User?) onSelected;
  final String companyId;

  const DriverSelect({
    Key? key,
    this.initialDriverId,
    required this.onSelected,
    required this.companyId,
  }) : super(key: key);

  @override
  _DriverSelectState createState() => _DriverSelectState();
}

class _DriverSelectState extends State<DriverSelect> {
  Future<User?>? _initialDriverFuture;
  List<User> drivers = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialDriverId != null) {
      final userDAO = Provider.of<UserDAO>(context, listen: false);
      _initialDriverFuture = userDAO.getUser(widget.initialDriverId!);
    }
    fetchDrivers();
  }

  void fetchDrivers() async {
    final userService = Provider.of<UserService>(context, listen: false);
    List<User> fetchedDrivers = await userService
        .fetchDriverUsersWithPackagingPermission(widget.companyId);
    setState(() {
      drivers = fetchedDrivers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _initialDriverFuture,
      builder: (context, snapshot) {
        return DropdownSearch<User>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
          ),
          items: drivers,
          itemAsString: (User user) => user.name,
          onChanged: (User? newValue) {
            widget.onSelected(newValue);
          },
          selectedItem: snapshot.data,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Select Driver",
              hintText: "Search and select driver",
            ),
          ),
        );
      },
    );
  }
}
