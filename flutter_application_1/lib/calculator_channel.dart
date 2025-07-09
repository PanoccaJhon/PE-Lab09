import 'package:flutter/services.dart';

class CalculatorChannel {
  // El nombre del canal. Debe ser único y consistente en Flutter y nativo.
  static const MethodChannel _calculatorChannel = MethodChannel('com.pe.lab09/calculator');

  /// Realiza una operación matemática en el lado nativo.
  /// [operation]: El nombre del método a invocar ('add', 'subtract', 'multiply', 'divide').
  /// [a], [b]: Los dos números sobre los que se realizará la operación.
  /// Retorna un String con el resultado o un mensaje de error.
  Future<String> calculate(String operation, double a, double b) async {
    String result;
    try {
      // Invoca el método nativo con el nombre de la operación y un mapa de argumentos.
      final double? nativeResult = await _calculatorChannel.invokeMethod(
        operation,
        {'a': a, 'b': b}, // Los argumentos se envían como un Map
      );
      if (nativeResult != null) {
        result = nativeResult.toString();
      } else {
        result = "Error: Resultado nulo del nativo.";
      }
    } on PlatformException catch (e) {
      // Captura errores específicos del canal (ej. división por cero, método no encontrado).
      result = "Error en la operación nativa: '${e.message}'.";
      print(result);
    } catch (e) {
      // Captura otros errores inesperados.
      result = "Error inesperado: $e";
      print(result);
    }
    return result;
  }
}