import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';

class DeliveryStatusSelect extends StatefulWidget {
  final DeliveryStatus initialStatus;
  final Function(DeliveryStatus) onStatusChanged;

  const DeliveryStatusSelect({
    Key? key,
    required this.initialStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _DeliveryStatusSelectState createState() => _DeliveryStatusSelectState();
}

class _DeliveryStatusSelectState extends State<DeliveryStatusSelect> {
  late DeliveryStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DeliveryStatus>(
      value: _currentStatus,
      onChanged: (DeliveryStatus? newValue) {
        if (newValue != null) {
          setState(() {
            _currentStatus = newValue;
          });
          widget.onStatusChanged(newValue);
        }
      },
      items: DeliveryStatus.values.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(describeEnum(status)),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Delivery Status',
        border: OutlineInputBorder(),
      ),
    );
  }
}
