import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/category/services/category_service.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:provider/provider.dart';

class OrderMultiSelect extends StatefulWidget {
  final List<Order> allOrders;
  final List<Order> initialSelectedOrders;
  final Function(List<Order>) onSelectionChanged;
  final Set<String> categoryIdsToCheck;

  const OrderMultiSelect({
    Key? key,
    required this.allOrders,
    required this.onSelectionChanged,
    required this.initialSelectedOrders,
    required this.categoryIdsToCheck,
  }) : super(key: key);

  @override
  _OrderMultiSelectState createState() => _OrderMultiSelectState();
}

class _OrderMultiSelectState extends State<OrderMultiSelect> {
  List<Order> selectedOrders = [];
  late CategoryService categoryService;

  @override
  void initState() {
    super.initState();
    selectedOrders = widget.initialSelectedOrders;
    categoryService = Provider.of<CategoryService>(context, listen: false);
  }

  bool isOrderCompatible(Order order) {
    Set<String> selectedOrderCategoryIds =
        selectedOrders.expand((o) => o.categories).toSet();

    Set<String> orderCategoryIds = order.categories.toSet();

    Set<String> combinedCategoryIds = {
      ...selectedOrderCategoryIds,
      ...orderCategoryIds,
      ...widget.categoryIdsToCheck,
    };

    return categoryService.areCategoriesCompatibleSync(combinedCategoryIds);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Order>.multiSelection(
      items: widget.allOrders, // This now has the data needed
      selectedItems: selectedOrders,
      itemAsString: (Order order) => order.id,
      compareFn: (Order item1, Order item2) => item1.id == item2.id,
      onChanged: (List<Order> newSelectedOrders) {
        widget.onSelectionChanged(newSelectedOrders);
        setState(() => selectedOrders = newSelectedOrders);
      },
      popupProps: PopupPropsMultiSelection.menu(
        disabledItemFn: (Order order) => !isOrderCompatible(order),
        showSelectedItems: true,
        showSearchBox: true,
        onItemAdded: (List<Order> selected, Order currentlySelected) {
          widget.onSelectionChanged(selected);
          setState(() => selectedOrders = selected);
        },
        onItemRemoved: (List<Order> selected, Order currentlySelected) {
          widget.onSelectionChanged(selected);
          setState(() => selectedOrders = selected);
        },
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Orders",
          hintText: "Search and select orders",
        ),
      ),
    );
  }
}
