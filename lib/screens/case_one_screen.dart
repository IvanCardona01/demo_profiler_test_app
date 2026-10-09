import 'dart:math';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';
import '../widgets/case_scaffold.dart';

/// Caso 1: Scroll o animación con tirones.
///
/// Sintoma: Al desplazar la lista de productos el scroll se siente trabado,
/// con saltos
///
/// Diagnostico: Antes de renderizar cada elemento se ejecuta una operación
/// matemática pesada en el hilo de UI, además se
/// construyen los 500 productos de una sola vez dentro de un
/// SingleChildScrollView + Column. El hilo de UI no alcanza a entregar cada
/// frame en 16 ms.
///
/// Cómo se soluciona: usar ListView.builder para construir solo los elementos
/// visibles de forma perezosa y mover el cálculo pesado fuera del build (por
/// ejemplo precalculándolo o en un isolate), liberando el hilo de UI.
class CaseOneScreen extends StatefulWidget {
  const CaseOneScreen({super.key});

  @override
  State<CaseOneScreen> createState() => _CaseOneScreenState();
}

class _CaseOneScreenState extends State<CaseOneScreen> {
  
  bool _usarCaminoProblematico = true;

  @override
  Widget build(BuildContext context) {
    final products = buildSampleProducts();

    return CaseScaffold(
      caseNumber: 1,
      title: 'Scroll con tirones',
      description:
          'La lista se traba al hacer scroll lo que hace que la experiencia sea poco fluida',
      problematico: _usarCaminoProblematico,
      onPathChanged: (valor) =>
          setState(() => _usarCaminoProblematico = valor),
      child: _usarCaminoProblematico
          ? _buildListaProblematica(products)
          : _buildListaOptimizada(products),
    );
  }

  /// Camino problemático: construye todos los ítems a la vez 
  /// lo que provoca tirones al hacer scroll.
  Widget _buildListaProblematica(List<Product> products) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: products.map((product) {
          final score = _calculoPesado(product.id);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.white,
                ],
              ),
            ),
            child: _ProductRow(product: product, score: score),
          );
        }).toList(),
      ),
    );
  }

  /// Camino optimizado: construye solo los ítems visibles con ListView.builder
  /// el scroll se mantiene fluido y no hay janks.
  Widget _buildListaOptimizada(List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final score = _calculoPesado(product.id);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.12),
                AppColors.white,
              ],
            ),
          ),
          child: _ProductRow(product: product, score: score),
        );
      },
    );
  }

  /// Operación matemática pesada que simula un procesamiento costoso por ítem.
  /// Se ejecuta en el hilo de UI antes de renderizar cada elemento.
  double _calculoPesado(int seed) {
    var result = 0.0;
    for (var i = 1; i < 60; i++) {
      result += sqrt((seed + i) * 1.0) * sin(i.toDouble());
    }
    return result;
  }
}

class _ProductRow extends StatelessWidget {
  final Product product;
  final double score;

  const _ProductRow({required this.product, required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            product.name.substring(product.name.length - 1),
            style: const TextStyle(color: AppColors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                '${product.category} · score ${score.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
