import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2 Hábitos',
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const PanelHabitos(),
    );
  }
}

class PanelHabitos extends StatefulWidget {
  const PanelHabitos({super.key});

  @override
  State<PanelHabitos> createState() => _PanelHabitosState();
}

class _PanelHabitosState extends State<PanelHabitos> {
  // Datos fijos
  final List<String> _habitos = const [
    'Beber 2 L de agua',
    'Leer 20 minutos',
    'Caminar 30 minutos',
    'Estudiar Flutter',
    'Dormir 8 horas',
  ];

  // Estado
  late List<bool> _cumplidos;
  int _meta = 3;
  bool _enfoque = false;
  String _nota = '';
  final TextEditingController _notaCtrl = TextEditingController();
  static const int _metaInicial = 3;

  @override
  void initState() {
    super.initState();
    _cumplidos = List<bool>.filled(_habitos.length, false);
  }

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  // Getters derivados
  int get _totalCumplidos => _cumplidos.where((c) => c).length;
  double get _progreso =>
      _habitos.isEmpty ? 0 : _totalCumplidos / _habitos.length;
  bool get _metaAlcanzada => _totalCumplidos >= _meta;

  String get _mensaje {
    final p = (_progreso * 100).round();
    if (p == 0) return '¡Empecemos!';
    if (p < 50) return 'Buen inicio';
    if (p < 100) return '¡Vas muy bien!';
    return '¡Día completado!';
  }

  // Acciones (Completadas con setState)
  void _alternarHabito(int index) {
    setState(() {
      _cumplidos[index] = !_cumplidos[index]; // Invierte el estado (de true a false o viceversa)
    });
  }

  void _cambiarMeta(double v) {
    setState(() {
      _meta = v.round(); // Convierte el valor decimal del Slider a entero
    });
  }

  void _alternarEnfoque(bool v) {
    setState(() {
      _enfoque = v; // Activa o desactiva el modo enfoque
    });
  }

  void _guardarNota() {
    setState(() {
      _nota = _notaCtrl.text
          .trim(); // Guarda el texto escrito, quitando espacios extra
    });
  }

  void _reiniciarDia() {
    setState(() {
      _cumplidos = List<bool>.filled(
        _habitos.length,
        false,
      ); // Desmarca todos los hábitos
      _meta = _metaInicial;
      _enfoque = false;
      _nota = '';
      _notaCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hábitos - Cumplidos: $_totalCumplidos / ${_habitos.length}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Barra de progreso y porcentaje
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: _progreso, // Este valor va de 0.0 a 1.0
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(_progreso * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Mensaje motivacional
          Center(
            child: Text(
              _mensaje,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const Divider(height: 40),

          // 3. Slider de meta del día
          Column(
            children: [
              Slider(
                value: _meta.toDouble(),
                min: 1,
                max: _habitos.length.toDouble(),
                divisions: _habitos.length - 1,
                onChanged: _cambiarMeta,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Meta: $_meta hábitos',
                    style: const TextStyle(fontSize: 16),
                  ),
                  // Muestra el distintivo solo si se alcanza la meta
                  if (_metaAlcanzada) ...[
                    const SizedBox(width: 10),
                    const Chip(
                      label: Text(
                        '¡Meta alcanzada!',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const Divider(height: 40),

          // 4. Switch de Modo enfoque
          SwitchListTile(
            title: const Text('Modo enfoque'),
            subtitle: const Text('Ocultar hábitos completados'),
            value: _enfoque,
            onChanged: _alternarEnfoque,
          ),

          // 5. Lista de hábitos
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Tus hábitos de hoy:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...List.generate(_habitos.length, (index) {
            // Si el modo enfoque está activado y el hábito ya se cumplió, lo ocultamos
            if (_enfoque && _cumplidos[index]) {
              return const SizedBox.shrink(); // Widget vacío (no ocupa espacio)
            }

            // Si no, mostramos la casilla de verificación
            return CheckboxListTile(
              title: Text(
                _habitos[index],
                style: TextStyle(
                  // Tachamos el texto si el hábito está cumplido
                  decoration: _cumplidos[index]
                      ? TextDecoration.lineThrough
                      : null,
                  color: _cumplidos[index] ? Colors.grey : Colors.black,
                ),
              ),
              value: _cumplidos[index],
              onChanged: (bool? value) {
                _alternarHabito(index);
              },
            );
          }),
          const Divider(height: 40),

          // 6. Sección de notas
          const Text(
            'Nota del día:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _notaCtrl,
                  decoration: const InputDecoration(
                    hintText: '¿Cómo te fue hoy?',
                    border: OutlineInputBorder(),
                    isDense:
                        true, // Hace el campo de texto un poco más compacto
                  ),
                  onSubmitted: (_) =>
                      _guardarNota(), // Guarda al presionar Enter en el teclado
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _guardarNota,
                child: const Text('Guardar'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tarjeta donde se muestra la nota guardada
          Card(
            color: Colors.green.shade50,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _nota.isEmpty ? 'Sin nota' : _nota,
                style: TextStyle(
                  fontStyle: _nota.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                  color: _nota.isEmpty ? Colors.grey : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 7. Botón Reiniciar Día
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _reiniciarDia,
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar día'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade900,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
