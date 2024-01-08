class Sector {
  final String id;
  final String companyId;
  final String name;
  final String description;

  Sector({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
  });

  // Factory constructor to create a Sector instance from a Map
  factory Sector.fromMap(Map<String, dynamic> data, String id) {
    return Sector(
      id: id,
      companyId: data['companyId'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
    );
  }

  // Method to convert a Sector instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'name': name,
      'description': description,
    };
  }

  // Method to create a copy of the Sector with altered fields
  Sector copyWith({
    String? id,
    String? companyId,
    String? name,
    String? description,
  }) {
    return Sector(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Sector{id: $id, companyId: $companyId, name: $name, description: $description}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Sector &&
        other.id == id &&
        other.companyId == companyId &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companyId.hashCode ^
        name.hashCode ^
        description.hashCode;
  }
}
