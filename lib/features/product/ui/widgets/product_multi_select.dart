import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/features/category/services/category_service.dart';
import 'package:inventory_system/features/product/ui/widgets/quantity_input_dialog.dart';
import 'package:provider/provider.dart';

class ProductMultiSelect extends StatefulWidget {
  final List<Product> allProducts;
  final List<Product> initialSelectedProducts;
  final Function(List<Product>) onSelectionChanged;

  const ProductMultiSelect({
    Key? key,
    required this.allProducts,
    required this.onSelectionChanged,
    required this.initialSelectedProducts,
  }) : super(key: key);

  @override
  _ProductMultiSelectState createState() => _ProductMultiSelectState();
}

class _ProductMultiSelectState extends State<ProductMultiSelect> {
  List<Product> selectedProducts = [];
  List<Product> overQuantityProducts = [];
  late CategoryService categoryService;

  @override
  void initState() {
    super.initState();
    selectedProducts = widget.initialSelectedProducts;
    categoryService = Provider.of<CategoryService>(context, listen: false);
  }

  bool isProductCompatible(Product product) {
    // Extract IDs from the selected products' categories
    Set<String> selectedProductCategoryIds =
        selectedProducts.expand((p) => p.categories).toSet();

    // Extract IDs from the product's categories
    Set<String> productCategoryIds = product.categories.toSet();

    // Combine and check compatibility
    Set<String> combinedCategoryIds = {
      ...selectedProductCategoryIds,
      ...productCategoryIds
    };
    return categoryService.areCategoriesCompatibleSync(combinedCategoryIds);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Product>.multiSelection(
      items: widget.allProducts,
      selectedItems: selectedProducts,
      itemAsString: (Product product) =>
          '${product.name} - Available Quantity: ${product.quantity}',
      compareFn: (Product item1, Product item2) => item1.id == item2.id,
      onChanged: (List<Product> newSelectedProducts) {
        setState(() => selectedProducts = newSelectedProducts);
        widget.onSelectionChanged(newSelectedProducts);
      },
      popupProps: PopupPropsMultiSelection.menu(
        showSelectedItems: true,
        showSearchBox: true,
        disabledItemFn: (Product product) => !isProductCompatible(product),
        onItemAdded: (List<Product> selected, Product currentlySelected) async {
          int quantity = await showDialog<int>(
                context: context,
                builder: (context) => QuantityInputDialog(
                    maxQuantity: currentlySelected.quantity),
              ) ??
              1;

          final index =
              selected.indexWhere((item) => item.id == currentlySelected.id);

          selected[index] = currentlySelected.copyWith(quantity: quantity);

          setState(() => selectedProducts = selected);
          widget.onSelectionChanged(selected);
        },
        onItemRemoved: (List<Product> selected, Product currentlySelected) {
          setState(() => selectedProducts = selected);
          widget.onSelectionChanged(selected);
        },
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Products",
          hintText: "Search and select products",
        ),
      ),
    );
  }
}
