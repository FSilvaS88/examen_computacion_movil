import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'package:examen_computacion_movil/services/api_constants.dart';

class ProductService {
  /// Obtener productos
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}product_list_rest/'),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (!data.containsKey("Productos Listado")) {
        throw Exception('Respuesta inesperada al cargar productos');
      }

      final List<dynamic> list = data["Productos Listado"];
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  /// Crear producto
  Future<void> createProduct(ProductModel product) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}product_add_rest/'),
      headers: ApiConstants.headers,
      body: json.encode({
        'product_name': product.name,
        'product_price': product.price,
        'product_image': product.image,
        'product_state': product.state,
      }),
    );
  }

  /// Editar producto
  Future<void> editProduct(ProductModel product) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}product_edit_rest/'),
      headers: ApiConstants.headers,
      body: json.encode(product.toJson()),
    );
  }

  /// Eliminar producto
  Future<void> deleteProduct(int id) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}product_del_rest/'),
      headers: ApiConstants.headers,
      body: json.encode({'product_id': id}),
    );
  }
}
