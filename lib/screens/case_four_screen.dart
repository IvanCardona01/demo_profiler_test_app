import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/path_switch.dart';

/// Caso 4: Memoria creciente.
///
/// Sintoma: Cada vez que se entra y se sale de la pantalla la app ocupa más
/// memoria y nunca la devuelve, aunque la pantalla ya no esté en uso.
///
/// Diagnostico: La pantalla registra un listener en un ChangeNotifier global y
/// no lo quita al salir. Ese listener mantiene vivo al State y a un objeto
/// pesado (LeakedProbe), así que cada visita deja basura retenida.
///
/// Cómo se soluciona: quitar el listener del ChangeNotifier al salir para que
/// el State y su payload puedan liberarse.

/// ChangeNotifier global que sobrevive a la pantalla y retiene a sus listeners.
final ChangeNotifier leakHost = ChangeNotifier();

/// Objeto pesado (~4 MB) que acompaña a cada visita para hacer visible el leak.
class LeakedProbe {
  final int visit;
  final List<int> payload;

  LeakedProbe(this.visit) : payload = List<int>.filled(1024 * 1024, 0);
}

class CaseFourScreen extends StatefulWidget {
  const CaseFourScreen({super.key});

  @override
  State<CaseFourScreen> createState() => _CaseFourScreenState();
}

class _CaseFourScreenState extends State<CaseFourScreen> {
  
  bool _usarCaminoProblematico = true;

  static int visitCount = 0;

  late final LeakedProbe _probe;
  late final int _visit;

  void _onHostChanged() {
    
  }

  @override
  void initState() {
    super.initState();
    visitCount++;
    _visit = visitCount;
    _probe = LeakedProbe(_visit);
    leakHost.addListener(_onHostChanged);
  }

  @override
  void dispose() {
    if (!_usarCaminoProblematico) {
      leakHost.removeListener(_onHostChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Caso 4'),
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
                  const Text(
                    'Visita número',
                    style: TextStyle(fontSize: 14, color: AppColors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_visit',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_probe.payload.length} datos retenidos en esta visita',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.black.withValues(alpha: 0.6),
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
            'Memoria creciente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cada vez que entras y sales de la pantalla la app ocupa más memoria y nunca la devuelve',
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
