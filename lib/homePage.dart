import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colors Fixered'),
        backgroundColor: const Color.fromARGB(255, 143, 210, 238),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¿De qué trata Colors Fixered?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Colors Fixered, aunque tiene una lógica simple, es una herramienta útil para desarrolladores Front-End, ya que proporciona paletas de colores complementarios. Esto facilita la creación de interfaces de usuario atractivas, garantizando combinaciones armoniosas que cumplen con los estándares estéticos deseados.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '¿Que API consume la app?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Esta app consume la API "TheColorAPI" para generar combinaciones de colores en modo análogo. '
                      'Se generan 30 colores que congenian entre sí, ideal para seleccionar paletas visualmente agradables.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '¿Qué es el modo análogo?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'El modo análogo es una opción que proporciona la API para extraer colores adyacentes en la rueda cromática predeterminada. '
                      'Se seleccionó este modo porque los colores análogos son naturalmente concordantes entre sí, lo que ayuda a generar paletas que encajan bien y cumplen con el objetivo de la aplicación: crear combinaciones de colores visualmente armoniosas.',
                      style: TextStyle(fontSize: 16),
                    ),
                    // Aquí eliminamos el 'const'
                    Image.asset('assets/images/circulito.png'),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 143, 210, 238),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/detail');
                    },
                    child: const Text('Listado de colores'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: const Text('Usuario'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 184, 181, 181),
    );
  }
}
