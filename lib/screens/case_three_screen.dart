import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/case_scaffold.dart';

/// Caso 3: Interacción costosa.
///
/// Sintoma: Al presionar el botón la pantalla se congela, el indicador de carga
/// no gira y no se puede interactuar hasta que termina el cálculo.
///
/// Diagnostico: El trabajo pesado se ejecuta de forma síncrona en el hilo de UI
/// dentro del onPressed, bloqueando el frame y toda la interacción mientras
/// dura el cálculo.
///
/// Cómo se soluciona: mover el trabajo pesado fuera del hilo de UI con un
/// Isolate (compute), de modo que la interfaz siga respondiendo mientras el
/// cálculo ocurre en segundo plano.
class CaseThreeScreen extends StatefulWidget {
  const CaseThreeScreen({super.key});

  @override
  State<CaseThreeScreen> createState() => _CaseThreeScreenState();
}

class _CaseThreeScreenState extends State<CaseThreeScreen> {
  
  bool _usarCaminoProblematico = true;

  bool _cargando = false;
  double _resultado = 0;

  @override
  Widget build(BuildContext context) {
    return CaseScaffold(
      caseNumber: 3,
      title: 'Interacción costosa',
      description:
          'La pantalla se congela al presionar el botón porque el cálculo corre en el hilo de UI',
      problematico: _usarCaminoProblematico,
      onPathChanged: (valor) =>
          setState(() => _usarCaminoProblematico = valor),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 32),
            Text(
              'Resultado: ${_resultado.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: _cargando
                  ? null
                  : (_usarCaminoProblematico
                      ? _interaccionProblematica
                      : _interaccionOptimizada),
              child: Text(
                _cargando ? 'Procesando...' : 'Ejecutar cálculo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Camino problemático: ejecuta el cálculo pesado de forma síncrona en el
  /// hilo de UI, congelando la pantalla hasta que termina.
  void _interaccionProblematica() {
    setState(() => _cargando = true);
    final resultado = _calculoPesado((50000000, Random().nextInt(1000)));
    setState(() {
      _resultado = resultado;
      _cargando = false;
    });
  }

  /// Camino optimizado: ejecuta el cálculo pesado en un Isolate con compute,
  /// manteniendo la UI fluida mientras se procesa en segundo plano.
  Future<void> _interaccionOptimizada() async {
    setState(() => _cargando = true);
    final resultado =
        await compute(_calculoPesado, (50000000, Random().nextInt(1000)));
    setState(() {
      _resultado = resultado;
      _cargando = false;
    });
  }
}

/// Operación matemática pesada que simula una interacción costosa.
double _calculoPesado((int, int) args) {
  final (iteraciones, seed) = args;
  var result = seed.toDouble();
  for (var i = 1; i < iteraciones; i++) {
    result += sqrt(i * 1.0) * sin(i.toDouble());
  }
  return result;
}


