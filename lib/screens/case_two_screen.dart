import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/path_switch.dart';

/// Caso 2: Seguimiento de rebuilds.
///
/// Sintoma: Al presionar el botón que incrementa el contador, toda la pantalla
/// parpadea o se siente pesada, aunque solo cambia un número.
///
/// Diagnostico: El setState está en lo alto del árbol, así que al cambiar el
/// contador se reconstruyen todos los widgets de la pantalla, incluidos los
/// costosos que no dependen del contador.
///
/// Cómo se soluciona: aislar el estado que cambia en su propio widget, para que
/// solo se reconstruya esa parte y los widgets costosos se queden quietos.
class CaseTwoScreen extends StatefulWidget {
  const CaseTwoScreen({super.key});

  @override
  State<CaseTwoScreen> createState() => _CaseTwoScreenState();
}

class _CaseTwoScreenState extends State<CaseTwoScreen> {
  
  bool _usarCaminoProblematico = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Caso 2'),
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
            child: _usarCaminoProblematico
                ? const _ConteoProblematico()
                : const _ConteoOptimizado(),
          ),
        ],
      ),
    );
  }
}

/// Camino problemático: el contador vive en el State de todo el bloque, así que
/// al llamar setState se reconstruye también el widget costoso que no cambia.
class _ConteoProblematico extends StatefulWidget {
  const _ConteoProblematico();

  @override
  State<_ConteoProblematico> createState() => _ConteoProblematicoState();
}

class _ConteoProblematicoState extends State<_ConteoProblematico> {
  int _contador = 0;

  @override
  Widget build(BuildContext context) {
    
    return _Layout(
      contador: _contador,
      costoso: _WidgetCostoso(),
      onIncrementar: () => setState(() => _contador++),
    );
  }
}

/// Camino optimizado: el estado del contador se aísla en _ContadorAislado y el
/// widget costoso se crea una sola vez, así no se reconstruye al incrementar.
class _ConteoOptimizado extends StatefulWidget {
  const _ConteoOptimizado();

  @override
  State<_ConteoOptimizado> createState() => _ConteoOptimizadoState();
}

class _ConteoOptimizadoState extends State<_ConteoOptimizado> {

  @override
  Widget build(BuildContext context) {
    return _Layout(
      costoso: const _WidgetCostoso(),
      contadorAislado: const _ContadorAislado(),
    );
  }
}

class _Layout extends StatelessWidget {
  final int? contador;
  final Widget costoso;
  final VoidCallback? onIncrementar;
  final Widget? contadorAislado;

  const _Layout({
    required this.costoso,
    this.contador,
    this.onIncrementar,
    this.contadorAislado,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          costoso,
          const SizedBox(height: 32),
          contadorAislado ?? _ContadorView(valor: contador ?? 0),
          const SizedBox(height: 24),
          if (onIncrementar != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: onIncrementar,
              child: const Text('Incrementar'),
            ),
        ],
      ),
    );
  }
}

class _ContadorAislado extends StatefulWidget {
  const _ContadorAislado();

  @override
  State<_ContadorAislado> createState() => _ContadorAisladoState();
}

class _ContadorAisladoState extends State<_ContadorAislado> {
  int _contador = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContadorView(valor: _contador),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          onPressed: () => setState(() => _contador++),
          child: const Text('Incrementar'),
        ),
      ],
    );
  }
}

class _ContadorView extends StatelessWidget {
  final int valor;

  const _ContadorView({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$valor',
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
    );
  }
}

/// Widget costoso que no depende del contador. Si se reconstruye en cada
/// incremento, es la señal del problema
class _WidgetCostoso extends StatelessWidget {
  
  const _WidgetCostoso();

  @override
  Widget build(BuildContext context) {
    
    var acumulado = Random().nextInt(1000);
    for (var i = 0; i < 2000000; i++) {
      acumulado += i % 7;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Widget costoso (marca $acumulado)',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }
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
            'Seguimiento de rebuilds',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Al cambiar un solo número se reconstruye toda la pantalla, incluso partes que no cambian',
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
