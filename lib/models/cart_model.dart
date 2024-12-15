class CartItem {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;

  CartItem({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
    );
  }

  get productImage => null;
}

class Cart {
  final String username;
  final String cartId;
  final double total;
  final List<CartItem> items;
  final String createdAt;
  final String updatedAt;

  Cart({
    required this.username,
    required this.cartId,
    required this.total,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<CartItem> cartItems = itemsList.map((item) => CartItem.fromJson(item)).toList();

    return Cart(
      username: json['username'],
      cartId: json['cart_id'],
      total: json['total'].toDouble(),
      items: cartItems,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}