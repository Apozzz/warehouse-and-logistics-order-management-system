import 'package:flutter/material.dart';
import 'package:inventory_system/enums/delivery_status.dart';
import 'package:inventory_system/enums/order_status.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/delivery/models/ongoing_delivery_session.dart';
import 'package:inventory_system/features/delivery/models/transportation_details.dart';
import 'package:inventory_system/features/delivery/services/ongoing_delivery_session_servide.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/order/ui/widgets/order_status_floating_action_button.dart';
import 'package:inventory_system/features/packages/ui/widgets/delivery_detail_content.dart';
import 'package:inventory_system/shared/providers/delivery_tracking_provider.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class PackageTransportDetailPage extends StatefulWidget {
  final String deliveryId;
  final OngoingDeliverySession? ongoingSession;

  const PackageTransportDetailPage({
    Key? key,
    required this.deliveryId,
    this.ongoingSession,
  }) : super(key: key);

  @override
  _PackageTransportDetailPageState createState() =>
      _PackageTransportDetailPageState();
}

class _PackageTransportDetailPageState
    extends State<PackageTransportDetailPage> {
  bool _isDeliveryInProgress = false;
  bool _showMap = false;
  late Future<List<Order>> _ordersFuture;
  List<Order> _deliveryOrders = [];
  Delivery _currentDelivery = Delivery.empty();

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders(widget.deliveryId);
    if (widget.ongoingSession != null) {
      _isDeliveryInProgress = true;
      _showMap = true;
    }
  }

  Future<void> startDelivery(List<Order> deliveryOrders) async {
    final existingSession =
        await Provider.of<OngoingDeliverySessionService>(context, listen: false)
            .getSessionByUser(_currentDelivery.userId);

    if (existingSession != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "A delivery session is already in progress for delivery ${existingSession.deliveryId}.")));
      return; // Exit early if there's an ongoing session
    }

    Provider.of<DeliveryTrackingProvider>(context, listen: false)
        .startDeliveryTracking(_currentDelivery);

    await updateOrderStatuses(deliveryOrders, OrderStatus.InTransit);
    setState(() {
      _isDeliveryInProgress = true;
      _showMap = true;
    });
    refreshOrders();
  }

  Future<void> endDelivery() async {
    final deliveryDAO = Provider.of<DeliveryDAO>(context, listen: false);
    final deliveryTrackingProvider =
        Provider.of<DeliveryTrackingProvider>(context, listen: false);

    // Stop the delivery tracking
    await deliveryTrackingProvider.endDeliveryTracking(widget.deliveryId);

    // Retrieve the final route image URL
    String? imageUrl = deliveryTrackingProvider.finalRouteImageUrl;
    double? distanceTraveled = deliveryTrackingProvider.distanceTraveled;
    Duration? timeSpent = deliveryTrackingProvider.timeSpent;

    // Create or update TransportationDetails
    TransportationDetails transportationDetails = TransportationDetails(
      deliveryId: widget.deliveryId,
      pathImageUrl: imageUrl,
      distanceTraveled: distanceTraveled,
      timeTaken: timeSpent,
      // You can add more fields like distanceTraveled and timeTaken if available
    );

    // Update the Delivery object
    Delivery updatedDelivery = _currentDelivery.copyWith(
      status: DeliveryStatus.Delivered,
      transportationDetails: transportationDetails,
    );

    // Save the updated Delivery object
    await deliveryDAO.updateDelivery(
        widget.deliveryId, updatedDelivery.toMap());

    // Update local state
    setState(() {
      _currentDelivery = updatedDelivery;
      _isDeliveryInProgress = false;
      _showMap = false;
    });

    // Refresh the orders to reflect the new status
    refreshOrders();
  }

  Future<List<Order>> fetchOrders(String deliveryId) async {
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);
    final delivery = await Provider.of<DeliveryDAO>(context, listen: false)
        .getDeliveryById(deliveryId);
    final fetchedOrders = await orderDAO.fetchOrdersByIds(delivery.orderIds);

    setState(() {
      _deliveryOrders = fetchedOrders; // Update the state variable
      _currentDelivery = delivery;
    });

    return fetchedOrders;
  }

  Future<void> updateOrderStatuses(
      List<Order> orders, OrderStatus status) async {
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);
    for (var order in orders) {
      var updatedOrder = order.copyWith(status: status);
      await orderDAO.updateOrder(order.id, updatedOrder.toMap());
    }
  }

  Future<void> updateDeliveryStatus(DeliveryStatus status) async {
    final deliveryDAO = Provider.of<DeliveryDAO>(context, listen: false);
    await deliveryDAO
        .updateDelivery(widget.deliveryId, {'status': status.index});
  }

  void refreshOrders() async {
    final refreshedOrders = await fetchOrders(widget.deliveryId);

    setState(() {
      _deliveryOrders = refreshedOrders;
      _ordersFuture = fetchOrders(widget.deliveryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Transport Detail'),
      ),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No order information available'));
          }

          List<Order> deliveryOrders = snapshot.data!;
          final orderAddresses =
              deliveryOrders.map((order) => order.customerAddress).toList();

          return DeliveryDetailContent(
            deliveryOrders: deliveryOrders,
            isDeliveryInProgress: _isDeliveryInProgress,
            onStartDelivery: () => startDelivery(deliveryOrders),
            onEndDelivery: () => endDelivery(),
            showMap: _showMap,
            orderAddresses: orderAddresses,
            delivery: _currentDelivery,
          );
        },
      ),
      floatingActionButton: OrderStatusFloatingActionButton(
        isDeliveryInProgress: _isDeliveryInProgress,
        orders: _deliveryOrders,
        refreshOrders: refreshOrders,
      ),
    );
  }
}
