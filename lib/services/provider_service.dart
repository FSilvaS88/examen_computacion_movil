import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/provider.dart';
import 'package:examen_computacion_movil/services/api_constants.dart';

class ProviderService {
  Future<List<ProviderModel>> fetchProviders() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}provider_list_rest/'),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data["Proveedores Listado"];
      return list.map((json) => ProviderModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar proveedores');
    }
  }

  Future<void> deleteProvider(int id) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}provider_del_rest/'),
      headers: ApiConstants.headers,
      body: json.encode({'provider_id': id}),
    );
  }

  Future<void> editProvider(ProviderModel provider) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}provider_edit_rest/'),
      headers: ApiConstants.headers,
      body: json.encode(provider.toJson()),
    );
  }

  Future<void> createProvider(ProviderModel provider) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}provider_add_rest/'),
      headers: ApiConstants.headers,
      body: json.encode({
        'provider_name': provider.name,
        'provider_last_name': provider.lastName,
        'provider_state': provider.state,
        'provider_mail': provider.email,
      }),
    );
  }
}
