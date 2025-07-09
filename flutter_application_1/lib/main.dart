import 'package:flutter/material.dart';
import 'package:flutter_application_1/calculator_channel.dart';
 // ¡Actualiza la importación!

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Native Calculator',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Cambiamos el color para que se vea diferente
      ),
      home: const CalculatorPage(title: 'Calculadora Nativa Flutter'),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, required this.title});

  final String title;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  String _calculationResult = '0.0';

  // Instancia de nuestra clase CalculatorChannel
  final CalculatorChannel _calculatorChannel = CalculatorChannel();

  // Función para realizar la operación
  Future<void> _performOperation(String operation) async {
    final double? a = double.tryParse(_controllerA.text);
    final double? b = double.tryParse(_controllerB.text);

    if (a == null || b == null) {
      setState(() {
        _calculationResult = 'Por favor, ingrese números válidos.';
      });
      return;
    }

    String result;
    try {
      result = await _calculatorChannel.calculate(operation, a, b);
    } catch (e) {
      result = 'Error inesperado: $e';
    }

    if (mounted) {
      setState(() {
        _calculationResult = result;
      });
    }
  }

  @override
  void dispose() {
    _controllerA.dispose();
    _controllerB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controllerA,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número A',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controllerB,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número B',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _performOperation('add'),
                  child: const Text('+ Suma'),
                ),
                ElevatedButton(
                  onPressed: () => _performOperation('subtract'),
                  child: const Text('- Resta'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _performOperation('multiply'),
                  child: const Text('* Multiplicación'),
                ),
                ElevatedButton(
                  onPressed: () => _performOperation('divide'),
                  child: const Text('/ División'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Resultado: $_calculationResult',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}