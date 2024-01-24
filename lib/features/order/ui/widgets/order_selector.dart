import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/order/models/order_model.dart';

class OrderSelect extends StatefulWidget {
  final Order? initialOrder;
  final Function(Order?) onOrderSelected;
  final List<Order> allOrders;

  const OrderSelect({
    Key? key,
    this.initialOrder,
    required this.onOrderSelected,
    required this.allOrders,
  }) : super(key: key);

  @override
  _OrderSelectState createState() => _OrderSelectState();
}

class _OrderSelectState extends State<OrderSelect> {
  Order? selectedOrder;

  @override
  void initState() {
    super.initState();
    selectedOrder = widget.initialOrder;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Order>(
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
      items: widget.allOrders,
      itemAsString: (Order order) => 'Order ID: ${order.id}',
      onChanged: (Order? newValue) {
        widget.onOrderSelected(newValue);
      },
      selectedItem: selectedOrder,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Order",
          hintText: "Search and select order",
        ),
      ),
    );
  }
}