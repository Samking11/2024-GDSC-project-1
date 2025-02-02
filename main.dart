class Product {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

abstract class ProductRepository {
  List<Product> getAllProducts();
  Product? getProductById(int id);
  void createProduct(Product product);
  void updateProduct(Product product);
  void deleteProduct(int id);
}

class InMemoryProductRepository implements ProductRepository {
  final List<Product> _products = [];

  @override
  List<Product> getAllProducts() => _products;

  @override
  Product? getProductById(int id) =>
      _products.firstWhere((product) => product.id == id, orElse: () => null);

  @override
  void createProduct(Product product) {
    _products.add(product);
  }

  @override
  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  void deleteProduct(int id) {
    _products.removeWhere((product) => product.id == id);
  }
}

abstract class UseCase<T, Params> {
  T call(Params params);
}

class ViewAllProductsUseCase implements UseCase<List<Product>, void> {
  final ProductRepository repository;
  
  ViewAllProductsUseCase(this.repository);
  
  @override
  List<Product> call(void params) => repository.getAllProducts();
}

class ViewProductUseCase implements UseCase<Product?, int> {
  final ProductRepository repository;
  
  ViewProductUseCase(this.repository);
  
  @override
  Product? call(int id) => repository.getProductById(id);
}

class CreateProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;
  
  CreateProductUseCase(this.repository);
  
  @override
  void call(Product product) => repository.createProduct(product);
}

class UpdateProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;
  
  UpdateProductUseCase(this.repository);
  
  @override
  void call(Product product) => repository.updateProduct(product);
}

class DeleteProductUseCase implements UseCase<void, int> {
  final ProductRepository repository;
  
  DeleteProductUseCase(this.repository);
  
  @override
  void call(int id) => repository.deleteProduct(id);
}

void main() {
  final repo = InMemoryProductRepository();
  final viewAllUseCase = ViewAllProductsUseCase(repo);
  final createUseCase = CreateProductUseCase(repo);
  final viewProductUseCase = ViewProductUseCase(repo);
  final updateUseCase = UpdateProductUseCase(repo);
  final deleteUseCase = DeleteProductUseCase(repo);

  createUseCase(Product(id: 1, name: "Laptop", description: "Gaming Laptop", imageUrl: "image_url_1", price: 1200.99));
  createUseCase(Product(id: 2, name: "Phone", description: "Smartphone", imageUrl: "image_url_2", price: 699.49));

  print(viewAllUseCase(null));
  print(viewProductUseCase(1));

  updateUseCase(Product(id: 1, name: "Laptop Pro", description: "Gaming Laptop Updated", imageUrl: "image_url_1", price: 1300.99));
  print(viewProductUseCase(1));

  deleteUseCase(2);
  print(viewAllUseCase(null));
}
