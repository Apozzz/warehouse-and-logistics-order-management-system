import 'package:flutter/material.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/features/delivery/ui/widgets/order_multi_select.dart';

class VehicleForm extends StatefulWidget {
  final Vehicle? vehicle; // Null if adding a new vehicle
  final String companyId;
  final List<Order> allOrders;
  final Function(Vehicle) onSubmit;

  const VehicleForm({
    Key? key,
    this.vehicle,
    required this.companyId,
    required this.allOrders,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  double _maxWeight = 0.0;
  double _maxVolume = 0.0;
  bool _availability = true;
  List<Order> _selectedOrders = [];

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      // Initialize form fields with existing vehicle data
      _typeController.text = widget.vehicle!.type;
      _registrationNumberController.text = widget.vehicle!.registrationNumber;
      _maxWeight = widget.vehicle!.maxWeight;
      _maxVolume = widget.vehicle!.maxVolume;
      _availability = widget.vehicle!.availability;
      _selectedOrders = mapOrderIdsToOrders(
          widget.vehicle!.assignedOrderIds, widget.allOrders);
    }
  }

  List<Order> mapOrderIdsToOrders(
      List<String> orderIds, List<Order> allOrders) {
    return allOrders.where((order) => orderIds.contains(order.id)).toList();
  }

  @override
  void dispose() {
    _typeController.dispose();
    _registrationNumberController.dispose();
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
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter vehicle type';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _registrationNumberController,
              decoration:
                  const InputDecoration(labelText: 'Registration Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter registration number';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _maxWeight.toString(),
              decoration: const InputDecoration(labelText: 'Max Weight (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null) {
                  return 'Please enter a valid weight';
                }
                return null;
              },
              onSaved: (newValue) => _maxWeight = double.parse(newValue ?? '0'),
            ),
            TextFormField(
              initialValue: _maxVolume.toString(),
              decoration: const InputDecoration(labelText: 'Max Volume (m³)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null) {
                  return 'Please enter a valid volume';
                }
                return null;
              },
              onSaved: (newValue) => _maxVolume = double.parse(newValue ?? '0'),
            ),
            SwitchListTile(
              title: const Text('Availability'),
              value: _availability,
              onChanged: (bool value) {
                setState(() {
                  _availability = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final assignedOrderIds =
                      _selectedOrders.map((order) => order.id).toList();
                  final newVehicle = Vehicle(
                    id: widget.vehicle?.id ?? '', // Keep existing ID if editing
                    companyId: widget.companyId,
                    type: _typeController.text,
                    registrationNumber: _registrationNumberController.text,
                    maxWeight: _maxWeight,
                    maxVolume: _maxVolume,
                    availability: _availability,
                    assignedOrderIds: assignedOrderIds,
                  );
                  widget.onSubmit(newVehicle);
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
