class Product {
   String? name;
   int? id;
   double? cost;
   int? availability;
   String? details;
   String? category;
   String? image;

  Product({
    required this.name,
    required this.id,
    required this.cost,
    required this.availability,
    required this.details,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['p_name'],
      id: json['p_id'],
      cost: json['p_cost'].toDouble(),
      availability: json['p_availability'],
      details: json['p_details'],
      category: json['p_category'] ?? 'Uncategorized',
      image: json['p_img'],
    );
  }
}
