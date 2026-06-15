import 'dart:async';

import 'package:enterprise_flutter_template/features/authentication/data/services/verification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de la pantalla de verificación.
enum VerifyStatus { idle, loading, success, error }

/// Estado inmutable de la verificación de cuenta.
class VerifyState extends Equatable {
  const VerifyState({
    this.status = VerifyStatus.idle,
    this.secondsRemaining = 0,
    this.errorMessage,
  });

  final VerifyStatus status;
  final int secondsRemaining;
  final String? errorMessage;

  bool get isLoading => status == VerifyStatus.loading;
  bool get canResend => secondsRemaining == 0;

  VerifyState copyWith({
    VerifyStatus? status,
    int? secondsRemaining,
    String? errorMessage,
  }) {
    return VerifyState(
      status: status ?? this.status,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, secondsRemaining, errorMessage];
}

/// ViewModel de la verificación de cuenta (paso 2).
///
/// Gestiona la cuenta regresiva de reenvío y la verificación del código de 6
/// dígitos delegando en [VerificationService].
class VerifyAccountViewModel extends StateNotifier<VerifyState> {
  VerifyAccountViewModel({
    required VerificationService service,
    required this.email,
  })  : _service = service,
        super(const VerifyState()) {
    _startCountdown();
    unawaited(_service.sendCode(email));
  }

  final VerificationService _service;
  final String email;

  static const _resendSeconds = 59;
  Timer? _timer;

  void _startCountdown() {
    _timer?.cancel();
    state = state.copyWith(secondsRemaining: _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining <= 1) {
        timer.cancel();
        state = state.copyWith(secondsRemaining: 0);
      } else {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      }
    });
  }

  /// Reenvía el código y reinicia la cuenta regresiva.
  Future<void> resend() async {
    if (!state.canResend) return;
    await _service.sendCode(email);
    _startCountdown();
  }

  /// Verifica el [code] de 6 dígitos.
  Future<void> verify(String code) async {
    state = state.copyWith(status: VerifyStatus.loading);
    final ok = await _service.verifyCode(email: email, code: code);
    state = ok
        ? state.copyWith(status: VerifyStatus.success)
        : state.copyWith(
            status: VerifyStatus.error,
            errorMessage: 'Código inválido',
          );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Provider del ViewModel de verificación, parametrizado por correo.
final verifyAccountViewModelProvider = StateNotifierProvider.autoDispose
    .family<VerifyAccountViewModel, VerifyState, String>(
  (ref, email) => VerifyAccountViewModel(
    service: ref.watch(verificationServiceProvider),
    email: email,
  ),
);
