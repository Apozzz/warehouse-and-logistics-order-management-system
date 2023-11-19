class Vehicle {
  String id;
  String companyId;
  String type;
  double maxWeight; // Maximum weight capacity in kilograms or pounds
  double maxVolume; // Maximum volume capacity in cubic meters or cubic feet
  bool availability;
  String registrationNumber;
  double distance;
  List<String> assignedOrderIds;

  Vehicle({
    required this.id,
    required this.companyId,
    required this.type,
    required this.maxWeight,
    required this.maxVolume,
    required this.availability,
    required this.registrationNumber,
    this.distance = 0.0,
    this.assignedOrderIds = const [],
  });

  // Factory constructor for creating a Vehicle from a map (e.g., from JSON)
  factory Vehicle.fromMap(Map<String, dynamic> map, String documentId) {
    return Vehicle(
      id: documentId,
      companyId: map['companyId'] ?? '',
      type: map['type'] ?? '',
      maxWeight: map['maxWeight']?.toDouble() ?? 0.0,
      maxVolume: map['maxVolume']?.toDouble() ?? 0.0,
      availability: map['availability'] ?? false,
      registrationNumber: map['registrationNumber'] ?? '',
      distance: map['distance']?.toDouble() ?? 0.0,
      assignedOrderIds: List<String>.from(map['assignedOrderIds'] ?? []),
    );
  }

  factory Vehicle.empty() {
    return Vehicle(
      id: '', // Empty or default ID
      companyId: '', // Empty or default company ID
      type: '', // Default type, could be 'Unknown' or similar
      maxWeight: 0.0, // Default weight capacity
      maxVolume: 0.0, // Default volume capacity
      availability: true, // Default availability
      registrationNumber: '', // Empty or default registration number
      distance: 0.0, // Default distance
      assignedOrderIds: const [],
    );
  }

  // Method to convert Vehicle object to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'type': type,
      'maxWeight': maxWeight,
      'maxVolume': maxVolume,
      'availability': availability,
      'registrationNumber': registrationNumber,
      'distance': distance,
      'assignedOrderIds': assignedOrderIds,
    };
  }

  // Method to check if a product/load can be carried based on weight and volume
  bool canCarry(double weight, double volume) {
    return weight <= maxWeight && volume <= maxVolume;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vehicle && other.registrationNumber == registrationNumber;
    // Include other fields if necessary for comparison
  }

  @override
  int get hashCode => registrationNumber
      .hashCode; // Include other fields in hashcode calculation if necessary
}
