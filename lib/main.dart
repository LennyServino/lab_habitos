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
  void _alternarHabito(int index) {
    // TODO
  }

  void _cambiarMeta(double v) {
    // TODO
  }

  void _alternarEnfoque(bool v) {
    // TODO
  }

  void _guardarNota() {
    // TODO
  }

  void _reiniciarDia() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hábitos - Cumplidos: $_totalCumplidos / ${_habitos.length}',
        ),
      ),
      body: const Center(
        child: Text('TODO: construir la interfaz según los requerimientos'),
      ),
    );
  }
}
