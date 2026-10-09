import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/path_switch.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Caso 3'),
        actions: [
          PathSwitch(
            problematico: _usarCaminoProblematico,
            onChanged: (valor) =>
                setState(() => _usarCaminoProblematico = valor),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CaseDescription(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 32),
                  Text(
                    'Resultado: ${_resultado.toStringAsFixed(2)} + ${Random().nextInt(100)}',
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
          ),
        ],
      ),
    );
  }

  /// Camino problemático: ejecuta el cálculo pesado de forma síncrona en el
  /// hilo de UI, congelando la pantalla hasta que termina.
  void _interaccionProblematica() {
    setState(() => _cargando = true);
    final resultado = _calculoPesado(50000000);
    setState(() {
      _resultado = resultado;
      _cargando = false;
    });
  }

  /// Camino optimizado: ejecuta el cálculo pesado en un Isolate con compute,
  /// manteniendo la UI fluida mientras se procesa en segundo plano.
  Future<void> _interaccionOptimizada() async {
    setState(() => _cargando = true);
    final resultado = await compute(_calculoPesado, 50000000);
    setState(() {
      _resultado = resultado;
      _cargando = false;
    });
  }
}

/// Operación matemática pesada que simula una interacción costosa.
double _calculoPesado(int iteraciones) {
  var result = 0.0;
  for (var i = 1; i < iteraciones; i++) {
    result += sqrt(i * 1.0) * sin(i.toDouble());
  }
  return result;
}

class _CaseDescription extends StatelessWidget {
  const _CaseDescription();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interacción costosa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'La pantalla se congela al presionar el botón porque el cálculo corre en el hilo de UI',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
