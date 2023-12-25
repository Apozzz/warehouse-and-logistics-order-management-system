import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/delivery/ui/widgets/delivery_status_selector.dart';
import 'package:inventory_system/features/vehicle/ui/widgets/vehicle_selector.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/features/order/ui/widgets/order_multi_select.dart';

class DeliveryForm extends StatefulWidget {
  final Delivery? delivery; // Null if adding a new delivery
  final String companyId;
  final List<Order> allOrders;
  final List<Vehicle> allVehicles;
  final Function(Delivery) onSubmit;

  const DeliveryForm({
    Key? key,
    this.delivery,
    required this.companyId,
    required this.allOrders,
    required this.allVehicles,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _deliveryDate = DateTime.now();
  List<Order> _selectedOrders = [];
  Vehicle? _selectedVehicle;
  DeliveryStatus _status = DeliveryStatus.Preparing;

  @override
  void initState() {
    super.initState();
    final delivery = widget.delivery ?? Delivery.empty();

    if (widget.delivery != null) {
      // Initialize form fields with existing delivery data
      _deliveryDate = widget.delivery!.deliveryDate;
      _selectedOrders =
          mapOrderIdsToOrders(delivery.orderIds, widget.allOrders);
      _selectedVehicle = delivery.vehicleId.isNotEmpty
          ? widget.allVehicles.firstWhere((v) => v.id == delivery.vehicleId,
              orElse: () => Vehicle.empty())
          : (widget.allVehicles.isNotEmpty
              ? widget.allVehicles.first
              : Vehicle.empty());

      _status = widget.delivery!.status;
    }
  }

  List<Order> mapOrderIdsToOrders(
      List<String> orderIds, List<Order> allOrders) {
    return allOrders.where((order) => orderIds.contains(order.id)).toList();
  }

  Set<String> extractCategoryIdsFromOrders(List<Order> orders) {
    return orders.expand((order) => order.categories).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              initialValue: DateFormat('yyyy-MM-dd').format(_deliveryDate),
              decoration: const InputDecoration(labelText: 'Delivery Date'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _deliveryDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != _deliveryDate) {
                  setState(() {
                    _deliveryDate = pickedDate;
                  });
                }
              },
            ),
            OrderMultiSelect(
              allOrders: widget.allOrders,
              initialSelectedOrders: _selectedOrders,
              categoryIdsToCheck: _selectedVehicle?.allowedCategories ?? {},
              onSelectionChanged: (selectedOrders) {
                setState(() {
                  _selectedOrders = selectedOrders;
                });
              },
            ),
            VehicleSelect(
              allVehicles: widget.allVehicles,
              initialVehicle: _selectedVehicle,
              categoryIdsToCheck: extractCategoryIdsFromOrders(_selectedOrders),
              onSelected: (vehicle) {
                setState(() {
                  _selectedVehicle = vehicle;
                });
              },
            ),
            DeliveryStatusSelect(
              initialStatus: _status,
              onStatusChanged: (newStatus) {
                setState(() {
                  _status = newStatus;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final delivery = Delivery(
                    id: widget.delivery?.id ??
                        '', // Keep existing ID if editing
                    deliveryDate: _deliveryDate,
                    orderIds: _selectedOrders.map((order) => order.id).toList(),
                    vehicleId: _selectedVehicle?.id ?? '',
                    status: _status,
                    companyId: widget.companyId,
                  );
                  widget.onSubmit(delivery);
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
