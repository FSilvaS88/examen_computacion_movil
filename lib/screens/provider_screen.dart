import 'package:flutter/material.dart';
import '../models/provider.dart';
import '../services/provider_service.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  final ProviderService _service = ProviderService();
  late Future<List<ProviderModel>> _providers;

  final MaterialColor themeColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  void _loadProviders() {
    setState(() {
      _providers = _service.fetchProviders();
    });
  }

  void _showProviderForm({ProviderModel? provider}) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: provider?.name ?? '');
    final lastNameController = TextEditingController(
      text: provider?.lastName ?? '',
    );
    final emailController = TextEditingController(text: provider?.email ?? '');
    final stateController = TextEditingController(text: provider?.state ?? '');

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              provider == null ? 'Agregar Proveedor' : 'Editar Proveedor',
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
                      controller: lastNameController,
                      decoration: InputDecoration(labelText: 'Apellido'),
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Ingrese un apellido válido'
                                  : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Correo'),
                      keyboardType: TextInputType.emailAddress,
                      validator:
                          (value) =>
                              value == null || !value.contains('@')
                                  ? 'Ingrese un correo válido'
                                  : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: stateController,
                      decoration: InputDecoration(labelText: 'Estado'),
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Ingrese un estado válido'
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
                    final nuevoProveedor = ProviderModel(
                      id: provider?.id ?? 0,
                      name: nameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      email: emailController.text.trim(),
                      state: stateController.text.trim(),
                    );

                    try {
                      if (provider == null) {
                        await _service.createProvider(nuevoProveedor);
                      } else {
                        await _service.editProvider(nuevoProveedor);
                      }

                      _loadProviders();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al guardar: $e')),
                      );
                    }
                  }
                },
                child: Text(provider == null ? 'Agregar' : 'Guardar'),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(ProviderModel provider) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Eliminar Proveedor',
              style: TextStyle(color: Colors.red),
            ),
            content: Text('¿Estás seguro de eliminar a ${provider.name}?'),
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
                    await _service.deleteProvider(provider.id);
                    _loadProviders();
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
        title: Text('Proveedores'),
        centerTitle: true,
        backgroundColor: themeColor.shade700,
      ),
      body: FutureBuilder<List<ProviderModel>>(
        future: _providers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: themeColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar proveedores'));
          }
          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(child: Text('No hay proveedores registrados'));
          }

          return ListView.separated(
            padding: EdgeInsets.all(12),
            itemCount: data.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final provider = data[index];
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: themeColor.withOpacity(0.05),
                title: Text(
                  '${provider.name} ${provider.lastName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(provider.email),
                onTap: () => _showProviderForm(provider: provider),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(provider),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: () => _showProviderForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
