import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar datos localmente

class PeopleScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>)? onFavoritesAdded;

  const PeopleScreen({super.key, this.onFavoritesAdded});

  @override
  _ColorScreenState createState() => _ColorScreenState();
}

class _ColorScreenState extends State<PeopleScreen> {
  List colors = [];
  bool isLoading = true;
  List<Map<String, dynamic>> favoriteColors = []; // Lista para almacenar colores favoritos

  @override
  void initState() {
    super.initState();
    fetchColors();
  }

  String getRandomColorHex() {
    final Random random = Random();
    final int color = random.nextInt(0xFFFFFF);
    return color.toRadixString(16).padLeft(6, '0').toUpperCase();
  }

  Future<void> fetchColors({String? baseColor}) async {
    setState(() {
      isLoading = true;
    });

    final colorHex = baseColor ?? getRandomColorHex( );

    final response = await http.get(Uri.parse(
        'https://www.thecolorapi.com/scheme?hex=$colorHex&mode=analogic&count=30'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        colors = data['colors'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load colors');
    }
  }

  // Función para agregar los colores actuales a favoritos
  void addToFavorites() {
    favoriteColors = colors
        .map((color) => {
              'name': color['name']['value'],
              'hex': color['hex']['value'],
            })
        .toList();

    if (widget.onFavoritesAdded != null) {
      widget.onFavoritesAdded!(favoriteColors);
    }

    saveFavorites();
  }

  Future<void> saveFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('favoriteColors', json.encode(favoriteColors));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paleta de colores'),
        backgroundColor: const Color.fromARGB(255, 143, 210, 238),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: addToFavorites, // Botón para agregar a favoritos
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 227, 222, 222),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                              '0xFF${colors[index]['hex']['value'].substring(1)}')),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                colors[index]['name']['value'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                colors[index]['hex']['value'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 143, 210, 238),
            child: ElevatedButton(
              onPressed: () {
                fetchColors();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 61, 130, 153),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Generar Colores Aleatorios'),
            ),
          ),
        ],
      ),
    );
  }
}




