import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _service = CategoryService();
  late Future<List<CategoryModel>> _categories;

  final MaterialColor themeColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = _service.fetchCategories();
    });
  }

  void _showCategoryForm({CategoryModel? category}) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: category?.name ?? '');
    final stateController = TextEditingController(text: category?.state ?? '');

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              category == null ? 'Agregar Categoría' : 'Editar Categoría',
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
                    final nuevaCategoria = CategoryModel(
                      id: category?.id ?? 0,
                      name: nameController.text.trim(),
                      state: stateController.text.trim(),
                    );

                    try {
                      if (category == null) {
                        await _service.createCategory(nuevaCategoria);
                      } else {
                        await _service.editCategory(nuevaCategoria);
                      }

                      _loadCategories();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al guardar: $e')),
                      );
                    }
                  }
                },
                child: Text(category == null ? 'Agregar' : 'Guardar'),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(CategoryModel category) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Eliminar Categoría',
              style: TextStyle(color: Colors.red),
            ),
            content: Text('¿Estás seguro de eliminar "${category.name}"?'),
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
                    await _service.deleteCategory(category.id);
                    _loadCategories();
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
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
        title: Text('Categorías'),
        centerTitle: true,
        backgroundColor: themeColor.shade700,
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: themeColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar categorías'));
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(child: Text('No hay categorías registradas'));
          }

          return ListView.separated(
            padding: EdgeInsets.all(12),
            itemCount: data.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final category = data[index];
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: themeColor.withOpacity(0.05),
                title: Text(
                  category.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Estado: ${category.state}'),
                onTap: () => _showCategoryForm(category: category),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(category),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: () => _showCategoryForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
