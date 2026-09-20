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

  // Acciones (TODO: completar con setState)
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

          // TODO: Agregar la lista de hábitos

          // TODO: Agregar sección de notas y botón de reinicio
        ],
      ),
    );
  }
}
