import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Necesario para hacer solicitudes HTTP
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Map<String, dynamic>> favoriteColors = [];
  Map<String, dynamic>? selectedColor;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favoriteColorsString = prefs.getString('favoriteColors');
    if (favoriteColorsString != null) {
      setState(() {
        favoriteColors = List<Map<String, dynamic>>.from(
          json.decode(favoriteColorsString),
        );
      });
    }
  }

  // Función para hacer la solicitud a la API y obtener los datos del color
  Future<Map<String, dynamic>> fetchColorData(String hex) async {
    final response = await http.get(
      Uri.parse(
        'https://www.thecolorapi.com/id?hex=${hex.substring(1)}&format=json',
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load color data');
    }
  }

  // Función para seleccionar el color, hacer la solicitud a la API y actualizar la vista
  void selectColor(Map<String, dynamic> color) async {
    final colorData = await fetchColorData(color['hex']);
    setState(() {
      selectedColor = {
        'name': color['name'],
        'hex': color['hex'],
        'rgb': colorData['rgb']['value'],
        'hsl': colorData['hsl']['value'],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: const Color.fromARGB(255, 143, 210, 238),
      ),
      backgroundColor: const Color.fromARGB(255, 227, 222, 222),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Bienvenido a tu perfil',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aca vas a visualizar la informacion completa de cada color perteneciente a la paleta de colores que selecionaste como favorita por ultima vez.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ExpansionTile(
                  title: const Text(
                    'Ver Colores Favoritos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    favoriteColors.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No tienes colores favoritos aún.'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: favoriteColors.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color(
                                    int.parse(
                                        '0xFF${favoriteColors[index]['hex'].substring(1)}'),
                                  ),
                                ),
                                title: Text(favoriteColors[index]['name']),
                                subtitle: Text(favoriteColors[index]['hex']),
                                onTap: () {
                                  selectColor(favoriteColors[index]);
                                }, // Seleccionar color
                              );
                            },
                          ),
                  ],
                ),
                const SizedBox(height: 20),
                selectedColor != null
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 162, 225, 246),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(252, 71, 63, 86)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información del Color',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(
                                    int.parse(
                                        '0xFF${selectedColor!['hex'].substring(1)}'),
                                  ),
                                  radius: 30,
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nombre: ${selectedColor!['name']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Código Hex: ${selectedColor!['hex']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Código RGB: ${selectedColor!['rgb']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Código HSL: ${selectedColor!['hsl']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(), // Si no hay color seleccionado, no mostramos nada
              ],
            ),
          ),
        ],
      ),
    );
  }
}