import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;


class ApiClientScreen extends StatefulWidget {
  const ApiClientScreen({super.key});

  @override
  ApiClientScreenState createState() => ApiClientScreenState();
}

class ApiClientScreenState extends State<ApiClientScreen> {
  List<dynamic> _products = [];
  final String mensaje =
      'No has realizado ninguna petición, presiona el botón para obtener productos.';
  String responseData = '';
  // final _serverUrl = '192.168.0.199:8000';
  final _serverUrl = '127.0.0.1:8000';
  final _indexController = TextEditingController();

  //TODO: estos son controladores de Actualizar
  final _nombreController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() async {
    super.initState();
    responseData = mensaje;
    await getData();
  }


Future<void> getData() async {
    try {
      final response = await http.get(Uri.http(_serverUrl, 'api/products'));
      setState(() {
        _products = jsonDecode(response.body);
        responseData = 'Status: ${response.statusCode}\n${response.body}';
      });
    } catch (e) {
      if (!mounted) return;
      showResponseDialog('Error', e.toString(), context);
    }
  }

  Future<void> postData(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.http(_serverUrl, 'api/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (!mounted) return;
      showResponseDialog('POST Response',
          'Status: ${response.statusCode}\n${response.body}', context);
    } catch (e) {
      showResponseDialog('Error', e.toString(), context);
    }
  }

  Future<void> updateData(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.http(_serverUrl, 'api/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (!mounted) return;
      showResponseDialog('PUT Response',
          'Status: ${response.statusCode}\n${response.body}', context);
    } catch (e) {
      showResponseDialog('Error', e.toString(), context);
    }
  }

  Future<void> deleteData(int id) async {
    try {
      final response = await http.delete(
        Uri.http(_serverUrl, 'api/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (!mounted) return;
      showResponseDialog('DELETE Response',
          'Status: ${response.statusCode}\n${response.body}', context);
    } catch (e) {
      showResponseDialog('Error', e.toString(), context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 10,
          children: [
            const Icon(
              Icons.check,
              size: 30,
              color: Colors.lightGreen,
            ),
            const Text('Cliente Laravel-Flutter'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: getData,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text('Obtener Productos',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontFamily: 'Poppins')),
            ),
            _buildActionButtons(),
            Divider(height: 10, thickness: 2, color: Colors.black45),
            Expanded(
              child: _products.isEmpty
                  ? homeScreen(responseData)
                  : ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Column(
                          spacing: 8,
                          // mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('INDEX: ${product['id'] ?? 'Nan'}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: ListTile(
                                title: Text(product['name'] ?? 'Placeholder'),
                                subtitle: Text(
                                    'Stock: ${product['stock']?.toString() ?? '0'} unidades'),
                                trailing: Text(
                                    'Precio: \$${product['price']?.toString() ?? '0.00'} pesos'),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildActionButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => ventanaCreate(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Text(
            'Ingresar Producto',
            style: TextStyle(
                color: Colors.grey[50], fontSize: 11, fontFamily: 'Poppins'),
          ),
        ),
        ElevatedButton(
          onPressed: () => ventanaUpdate(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Text(
            'Actualizar Producto',
            style: TextStyle(
                color: Colors.grey[50], fontSize: 11, fontFamily: 'Poppins'),
          ),
        ),
        ElevatedButton(
          onPressed: () => ventanaDelete(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Text(
            'Eliminar Producto',
            style: TextStyle(
                color: Colors.grey[50], fontSize: 11, fontFamily: 'Poppins'),
          ),
        ),
        // boton que setie en homeScreen
        IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.black45),
          ),
          onPressed: () {
            setState(() {
              _products.clear();
              responseData = mensaje;
            });
          },
          icon: Icon(Icons.home_filled),
        ),
      ],
    );
  }

  

  void ventanaUpdate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('escribe el index del producto que deseas actualizar'),
          content: TextField(
            controller: _indexController,
            decoration: const InputDecoration(
                hintText: 'Index',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Actualizar producto',
                  style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
                updateDatos(_indexController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void ventanaDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Escribe el index del producto que deseas eliminar'),
          content: TextField(
            controller: _indexController,
            decoration: const InputDecoration(
                hintText: 'Index',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Eliminar producto',
                  style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                deleteConfirmacion(_indexController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteConfirmacion(index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                '¿Estás seguro de que deseas eliminar este producto?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child:
                    const Text('Eliminar', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                  deleteData(int.parse(index));
                  // getData();
                },
              ),
            ],
          );
        });
  }

  void updateDatos(String index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Escribe los nuevos datos del producto en el index $index'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 7.5,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                    hintText: 'Nombre',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                    hintText: 'Precio',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(
                    hintText: 'Stock',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                    hintText: 'Descripción',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Actualizar producto',
                  style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.pop(context);
                updateData(int.parse(index), {
                  'name': _nombreController.text,
                  'price': double.parse(_priceController.text),
                  'stock': int.parse(_stockController.text),
                  'description': _descController.text,
                });
                // getData();
              },
            ),
          ],
        );
      },
    );
  }

  void ventanaCreate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingresa los datos del nuevo producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 7.5,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                    hintText: 'Nombre',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                    hintText: 'Precio',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(
                    hintText: 'Stock',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                    hintText: 'Descripción',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Ingresar producto',
                  style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.pop(context);
                postData({
                  'name': _nombreController.text,
                  'price': double.parse(_priceController.text),
                  'stock': int.parse(_stockController.text),
                  'description': _descController.text,
                });
              },
            ),
          ],
        );
      },
    );
  }


  } // Fin de la clase ApiClientScreenState
