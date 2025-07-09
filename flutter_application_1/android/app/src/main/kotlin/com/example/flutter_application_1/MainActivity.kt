package com.pe.lab09.flutter_application_1

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Define el nombre del canal. ¡Debe coincidir con el nombre en Dart!
    private val CHANNEL = "com.pe.lab09/calculator"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // Extrae los argumentos 'a' y 'b' del mapa enviado por Flutter
            // Los argumentos se reciben como Double por defecto si los envías como double en Dart
            val a = call.argument<Double>("a")
            val b = call.argument<Double>("b")

            if (a == null || b == null) {
                // Si los argumentos no son válidos, envía un error a Flutter
                result.error("INVALID_ARGUMENTS", "Se esperaban dos números 'a' y 'b'.", null)
                return@setMethodCallHandler // Sal del manejador
            }

            var operationResult: Double? = null
            var errorMessage: String? = null

            when (call.method) {
                "add" -> {
                    operationResult = a + b
                }
                "subtract" -> {
                    operationResult = a - b
                }
                "multiply" -> {
                    operationResult = a * b
                }
                "divide" -> {
                    if (b != 0.0) { // Evitar división por cero
                        operationResult = a / b
                    } else {
                        errorMessage = "División por cero no permitida."
                    }
                }
                else -> {
                    // Método no reconocido, informa a Flutter
                    result.notImplemented()
                    return@setMethodCallHandler
                }
            }

            if (errorMessage != null) {
                // Si hay un error específico de la operación (ej. división por cero)
                result.error("CALCULATION_ERROR", errorMessage, null)
            } else if (operationResult != null) {
                // Si la operación fue exitosa, envía el resultado de vuelta a Flutter
                result.success(operationResult)
            } else {
                // En caso de un escenario inesperado donde no hay resultado ni error específico
                result.error("UNKNOWN_ERROR", "No se pudo calcular el resultado.", null)
            }
        }
    }
}