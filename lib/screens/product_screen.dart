import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _service = ProductService();
  late Future<List<ProductModel>> _products;

  final MaterialColor themeColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = _service.fetchProducts();
    });
  }

  void _showProductForm({ProductModel? product}) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    final imageController = TextEditingController(text: product?.image ?? '');

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              product == null ? 'Agregar Producto' : 'Editar Producto',
              style: TextStyle(color: themeColor),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Ingrese un nombre válido'
                                  : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Precio'),
                      validator:
                          (value) =>
                              value == null || double.tryParse(value) == null
                                  ? 'Ingrese un precio válido'
                                  : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: imageController,
                      decoration: InputDecoration(labelText: 'URL Imagen'),
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Ingrese una URL válida'
                                  : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final nuevoProducto = ProductModel(
                      id: product?.id ?? 0,
                      name: nameController.text.trim(),
                      price: double.tryParse(priceController.text) ?? 0.0,
                      image: imageController.text.trim(),
                      state: 'Activo',
                    );

                    try {
                      if (product == null) {
                        await _service.createProduct(nuevoProducto);
                      } else {
                        await _service.editProduct(nuevoProducto);
                      }

                      _loadProducts();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al guardar: $e')),
                      );
                    }
                  }
                },
                child: Text(product == null ? 'Agregar' : 'Guardar'),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(ProductModel product) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Eliminar Producto',
              style: TextStyle(color: Colors.red),
            ),
            content: Text('¿Eliminar "${product.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  try {
                    await _service.deleteProduct(product.id);
                    _loadProducts();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al eliminar: $e')),
                    );
                  }
                },
                child: Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Productos'),
        centerTitle: true,
        backgroundColor: themeColor.shade700,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: themeColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar productos'));
          }
          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(child: Text('No hay productos registrados'));
          }

          return ListView.separated(
            padding: EdgeInsets.all(12),
            itemCount: data.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final product = data[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(0)}'),
                onTap: () => _showProductForm(product: product),
                tileColor: themeColor.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(product),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: () => _showProductForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
