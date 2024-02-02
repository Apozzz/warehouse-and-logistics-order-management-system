class TransportationDetails {
  final String deliveryId;
  final String? pathImageUrl;
  final double? distanceTraveled; // in kilometers or miles
  final Duration? timeTaken;

  TransportationDetails({
    required this.deliveryId,
    this.pathImageUrl,
    this.distanceTraveled,
    this.timeTaken,
  });

  // Method to convert a TransportationDetails instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'deliveryId': deliveryId,
      'pathImageUrl': pathImageUrl,
      'distanceTraveled': distanceTraveled,
      'timeTaken': timeTaken?.inSeconds,
    };
  }

  // Factory constructor to create a TransportationDetails instance from a Map
  factory TransportationDetails.fromMap(Map<String, dynamic> data) {
    return TransportationDetails(
      deliveryId: data['deliveryId'],
      pathImageUrl: data['pathImageUrl'],
      distanceTraveled: data['distanceTraveled'],
      timeTaken: data['timeTaken'] != null
          ? Duration(seconds: data['timeTaken'])
          : null,
    );
  }

  // Creates a copy of the TransportationDetails instance with altered fields
  TransportationDetails copyWith({
    String? deliveryId,
    String? pathImageUrl,
    double? distanceTraveled,
    Duration? timeTaken,
  }) {
    return TransportationDetails(
      deliveryId: deliveryId ?? this.deliveryId,
      pathImageUrl: pathImageUrl ?? this.pathImageUrl,
      distanceTraveled: distanceTraveled ?? this.distanceTraveled,
      timeTaken: timeTaken ?? this.timeTaken,
    );
  }

  @override
  String toString() {
    return 'TransportationDetails{deliveryId: $deliveryId, pathImageUrl: $pathImageUrl, distanceTraveled: $distanceTraveled, timeTaken: $timeTaken}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransportationDetails &&
        other.deliveryId == deliveryId &&
        other.pathImageUrl == pathImageUrl &&
        other.distanceTraveled == distanceTraveled &&
        other.timeTaken == timeTaken;
  }

  @override
  int get hashCode {
    return deliveryId.hashCode ^
        pathImageUrl.hashCode ^
        distanceTraveled.hashCode ^
        timeTaken.hashCode;
  }
}
