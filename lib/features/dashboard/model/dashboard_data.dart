class DashboardData {
  final int totalOrders;
  final int totalDeliveries;
  final int totalProducts; // New field
  final int totalUsers; // New field
  // ... more data fields as necessary

  DashboardData({
    required this.totalOrders,
    required this.totalDeliveries,
    required this.totalProducts, // Initialize new field
    required this.totalUsers, // Initialize new field
    // ... initialize more fields as necessary
  });
}
