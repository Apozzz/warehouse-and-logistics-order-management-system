class Category {
  final String id;
  final String name;
  final String companyId;
  final List<String> incompatibleCategories;

  Category({
    required this.id,
    required this.name,
    required this.companyId,
    this.incompatibleCategories = const [],
  });

  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      id: documentId,
      name: data['name'] ?? '',
      companyId: data['companyId'] ?? '',
      incompatibleCategories:
          List<String>.from(data['incompatibleCategories'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'companyId': companyId,
      'incompatibleCategories': incompatibleCategories,
    };
  }

  factory Category.empty() {
    return Category(
      id: '',
      companyId: '',
      name: '',
      incompatibleCategories: [],
      // Other properties with default values...
    );
  }
}
