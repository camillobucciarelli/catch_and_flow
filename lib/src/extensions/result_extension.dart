import '../../catch_and_flow.dart';
import 'extensions.dart';

/// Estensioni per il tipo [Result] per una gestione più comoda dei risultati.
extension ResultExtension<T> on Result<T> {
  /// Restituisce `true` se questo risultato rappresenta un successo (ha un valore e nessun $1e).
  bool get isSuccess => $1 == null && $2 != null;

  /// Restituisce `true` se questo risultato rappresenta un fallimento (ha un $1e e nessun valore).
  bool get isFailure => $1 != null && $2 == null;

  /// Restituisce il valore di successo se presente, altrimenti `null`.
  ///
  /// Usa [when] o [map] per una gestione più sicura e senza null.
  T? get $2OrNull => $2;

  /// Restituisce l'$1e se presente, altrimenti `null`.
  ///
  /// Usa [when] o [map] per gestire esplicitamente il ramo $1e.
  CustomError? get $1OrNull => $1;

  /// Mappa il [Result] in un singolo valore fornendo handler per entrambi i casi.
  ///
  /// - [success]: chiamato con il valore se successo.
  /// - [$1]: chiamato con il [Custom$1] se fallimento.
  ///
  /// Restituisce il valore prodotto dall'handler invocato.
  R map<R>({
    required R Function(T? value) success,
    required R Function(CustomError error) error,
  }) {
    if (isSuccess) {
      return success($2);
    }
    return error($1!);
  }

  /// Esegue la callback appropriata in base allo stato del [Result].
  ///
  /// - [success]: callback opzionale chiamata con il valore di successo.
  /// - [error]: callback opzionale chiamata con il [CustomError].
  void when({SuccessCallback<T?>? success, ErrorCallback? error}) {
    if (isSuccess) {
      success?.call($2);
    } else {
      error?.call($1!);
    }
  }
}
