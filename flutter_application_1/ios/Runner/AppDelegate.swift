import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    // Define el MethodChannel con el mismo nombre que en Dart y Android
    let calculatorChannel = FlutterMethodChannel(name: "com.pe.lab09/calculator",
                                                 binaryMessenger: controller.binaryMessenger)

    // Establece el manejador de llamadas de métodos
    calculatorChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Los argumentos de Flutter se reciben como un NSDictionary en Swift
      guard let args = call.arguments as? [String: Any],
            let a = args["a"] as? Double,
            let b = args["b"] as? Double else {
        // Si los argumentos no son válidos, envía un error a Flutter
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Se esperaban dos números 'a' y 'b'.", details: nil))
        return
      }

      var operationResult: Double? = nil
      var errorMessage: String? = nil

      switch call.method {
      case "add":
        operationResult = a + b
      case "subtract":
        operationResult = a - b
      case "multiply":
        operationResult = a * b
      case "divide":
        if b != 0.0 { // Evitar división por cero
          operationResult = a / b
        } else {
          errorMessage = "División por cero no permitida."
        }
      default:
        // Método no reconocido, informa a Flutter
        result(FlutterMethodNotImplemented)
        return
      }

      if let error = errorMessage {
        // Si hay un error específico de la operación
        result(FlutterError(code: "CALCULATION_ERROR", message: error, details: nil))
      } else if let res = operationResult {
        // Si la operación fue exitosa, envía el resultado de vuelta a Flutter
        result(res)
      } else {
        // En caso de un escenario inesperado
        result(FlutterError(code: "UNKNOWN_ERROR", message: "No se pudo calcular el resultado.", details: nil))
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}