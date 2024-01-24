import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/enums/order_status.dart';

class OrderStatusSelect extends StatelessWidget {
  final OrderStatus? status;
  final Function(OrderStatus?) onStatusSelected;

  const OrderStatusSelect({
    Key? key,
    required this.status,
    required this.onStatusSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<OrderStatus>(
      popupProps: const PopupProps.menu(showSearchBox: true),
      items: OrderStatus.values,
      itemAsString: (OrderStatus status) => status.toString().split('.').last,
      onChanged: onStatusSelected,
      selectedItem: status,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Order Status",
          hintText: "Search and select status",
        ),
      ),
    );
  }
}
