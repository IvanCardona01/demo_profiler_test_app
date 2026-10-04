/// Producto de ejemplo usado en la lista del Caso 1.
class Product {
  final int id;
  final String name;
  final String category;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });
}

/// Genera una lista grande de productos para forzar scroll extenso.
List<Product> buildSampleProducts({int count = 500}) {
  const categories = ['Tecnología', 'Hogar', 'Ropa', 'Deporte', 'Juguetes'];
  return List.generate(count, (index) {
    return Product(
      id: index,
      name: 'Producto #$index',
      category: categories[index % categories.length],
      price: 10 + (index % 90) + 0.99,
    );
  });
}
