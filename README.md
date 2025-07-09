# 🚀 Comunicación Nativa en Flutter: Un Viaje a la Interoperabilidad

---

¡Bienvenido a este repositorio! Aquí exploraremos cómo Flutter se comunica con el código nativo de Android (Kotlin) e iOS (Swift), un aspecto crucial para construir aplicaciones potentes y completas. Si alguna vez te preguntaste cómo acceder a funcionalidades específicas del dispositivo o integrar librerías nativas, ¡estás en el lugar correcto!

Este proyecto es una **guía práctica** y un conjunto de **ejemplos funcionales** que demuestran las principales estrategias de comunicación entre **Dart** y las plataformas nativas.

## 🛠️ Tecnologías Exploradas

Aquí tienes un desglose de las herramientas que aprenderás a usar:

### 📱 MethodChannel: El Llamador de Funciones Nativo
El caballo de batalla para la comunicación **bidireccional**. Con `MethodChannel`, tu código Dart puede **invocar métodos específicos** en el lado nativo (Kotlin/Swift), pasarles argumentos y recibir un resultado de forma asíncrona.

* **¿Cuándo usarlo?** Para operaciones puntuales como:
    * Acceder a la cámara 📸
    * Obtener la ubicación GPS 📍
    * Guardar datos en el almacenamiento nativo 💾
    * Invocar APIs específicas del sistema operativo.

### ⚡ EventChannel: Flujos de Datos en Tiempo Real
Perfecto para recibir **flujos continuos de eventos** desde el código nativo hacia Flutter. Si necesitas que tu app reaccione a cambios constantes o notificaciones, `EventChannel` es tu aliado.

* **¿Cuándo usarlo?** Para:
    * Actualizaciones del nivel de batería 🔋
    * Datos de sensores (acelerómetro, giroscopio) 🌐
    * Cambios en la conectividad de red 📶
    * Progreso de descargas o subidas.

### ✉️ BasicMessageChannel: Comunicación Flexible de Bajo Nivel
Este es el canal más **genérico y de bajo nivel**. Permite enviar mensajes arbitrarios (binarios o estructurados) entre Dart y el nativo. Ofrece mayor flexibilidad en el formato de datos usando un `MessageCodec`.

* **¿Cuándo usarlo?** Cuando necesitas un control muy específico sobre el formato de los datos intercambiados, o si los patrones de `MethodChannel` y `EventChannel` no se ajustan a tus necesidades particulares.

### 🐦 Pigeon: ¡Adiós al Boilerplate y Hola a la Seguridad de Tipos!
Una **herramienta de generación de código** desarrollada por el equipo de Flutter. Pigeon simplifica y hace más robusta la comunicación, eliminando el código repetitivo (`boilerplate`) y los errores de tipo. Defines tus APIs en un archivo simple, y Pigeon genera automáticamente todo lo necesario para Dart, Kotlin/Java y Swift/Objective-C.

* **¿Cuándo usarlo?** Ideal para:
    * Proyectos grandes con muchas interacciones nativas.
    * Garantizar la **seguridad de tipos** y reducir errores.
    * Agilizar el desarrollo y mantener un código más limpio.

### 🔗 FFI (Foreign Function Interface): Rendimiento Extremo con C/C++
Permite a tu aplicación Dart interactuar **directamente** con librerías nativas escritas en **C** (o lenguajes compatibles con C, como C++ con `extern "C"`). Es la opción para **alto rendimiento** y acceso a funcionalidades de bajo nivel.

* **¿Cuándo usarlo?** Para:
    * Procesamiento de imágenes o audio de alta velocidad 🖼️🎧
    * Algoritmos matemáticos complejos ➕➖
    * Integración con hardware específico o drivers de bajo nivel.
    * Reutilizar grandes bases de código C/C++ existentes.

---

## 🚀 Implementación de Ejemplo: Calculadora Nativa con MethodChannel

Este ejemplo demuestra cómo utilizar **MethodChannel** para implementar una **calculadora básica** que realiza suma, resta, multiplicación y división. Aprenderás a enviar múltiples argumentos desde Flutter al código nativo y a manejar diferentes operaciones dentro de un mismo canal.

### 📝 Pasos Clave de la Implementación:

1.  **Definición del Canal en Flutter (Dart):**
    * Se creó el archivo `lib/calculator_channel.dart`.
    * Se definió un `MethodChannel` con un nombre único (`'com.pe.lab09/calculator'`).
    * Se implementó un método `calculate(operation, a, b)` que usa `_calculatorChannel.invokeMethod(operation, {'a': a, 'b': b})` para enviar la operación y los números como un mapa de argumentos al lado nativo.

2.  **Interfaz de Usuario en Flutter (Dart):**
    * Se modificó `lib/main.dart` para crear una interfaz de calculadora simple.
    * Se añadieron `TextField`s para la entrada de dos números y `ElevatedButton`s para cada operación (suma, resta, multiplicación, división).
    * Cada botón llama a `_performOperation(String operation)` que, a su vez, invoca al método `calculate` de `CalculatorChannel`.
    * El resultado de la operación nativa se muestra en un `Text` en la interfaz.

3.  **Lógica Nativa en Android (Kotlin):**
    * Se modificó `android/app/src/main/kotlin/com.tuapp.nombre/MainActivity.kt`.
    * Se configuró un `MethodChannel` con el **mismo nombre** que en Dart.
    * Dentro de `setMethodCallHandler`, se extrajeron los argumentos (`a` y `b`) del `call.argument<Double>()`.
    * Se usó una sentencia `when (call.method)` para ejecutar la lógica matemática correspondiente (`add`, `subtract`, `multiply`, `divide`).
    * Se incluyó manejo específico para la **división por cero**, enviando un `result.error()` a Flutter si ocurre.
    * Se envió el `result.success(operationResult)` de vuelta a Flutter, o `result.notImplemented()` si el método no se reconoció.

4.  **Lógica Nativa en iOS (Swift):**
    * Se modificó `ios/Runner/AppDelegate.swift`.
    * Se configuró un `FlutterMethodChannel` con el **mismo nombre** que en Dart y Android.
    * Dentro de `setMethodCallHandler`, se extrajeron los argumentos (`a` y `b`) del `call.arguments as? [String: Any]`.
    * Se utilizó un `switch call.method` para procesar la operación solicitada.
    * Se implementó la validación para la **división por cero**, enviando un `FlutterError` a Flutter en caso de ser necesario.
    * Se envió el resultado (`result(res)`) o un error (`result(FlutterError)`) de vuelta a Flutter.

---
