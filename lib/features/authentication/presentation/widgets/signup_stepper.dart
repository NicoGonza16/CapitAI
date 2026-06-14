import 'package:flutter/material.dart';

/// Indicador de pasos del registro (círculos numerados conectados).
///
/// Los pasos completados muestran un check; el actual va resaltado en primario.
class SignupStepper extends StatelessWidget {
  const SignupStepper({
    required this.currentStep,
    required this.totalSteps,
    required this.label,
    super.key,
  });

  /// Paso actual (1-based).
  final int currentStep;
  final int totalSteps;

  /// Texto descriptivo, p. ej. "Paso 1 de 3".
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (var step = 1; step <= totalSteps; step++) ...[
          _StepCircle(
            step: step,
            isDone: step < currentStep,
            isActive: step == currentStep,
          ),
          if (step < totalSteps)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: step < currentStep
                    ? colors.primary
                    : colors.outlineVariant,
              ),
            ),
        ],
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.step,
    required this.isDone,
    required this.isActive,
  });

  final int step;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final filled = isDone || isActive;
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? colors.primary : colors.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: isDone
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : Text(
              '$step',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : colors.onSurfaceVariant,
              ),
            ),
    );
  }
}
