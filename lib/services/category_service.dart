import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  final String _baseUrl = "http://10.109.12.39:8000/api/";

  /// Obtener todas las categorías
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}category_list_rest/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data["Categorías Listado"];
        return list.map((item) => CategoryModel.fromJson(item)).toList();
      } else {
        throw Exception('Error al obtener categorías: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en fetchCategories: $e');
      rethrow;
    }
  }

  /// Crear nueva categoría
  Future<void> createCategory(CategoryModel category) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}category_add_rest/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'category_name': category.name,
          'category_state': category.state,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al crear categoría: ${response.body}');
      }
    } catch (e) {
      print('❌ Error en createCategory: $e');
      rethrow;
    }
  }

  /// Editar categoría (no implementado en backend actual)
  Future<void> editCategory(CategoryModel category) async {
    print('⚠️ Esta función aún no está implementada en el backend.');
    // Aquí puedes agregar lógica si luego activamos el endpoint de edición
  }

  /// Eliminar categoría (no implementado en backend actual)
  Future<void> deleteCategory(int id) async {
    print('⚠️ Esta función aún no está implementada en el backend.');
    // Aquí puedes agregar lógica si luego activamos el endpoint de eliminación
  }
}
