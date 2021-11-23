part of disposables;

class DisposeException implements Exception {
  final String message;

  DisposeException._(this.message);

  DisposeException.custom(String message) : this._(message);

  DisposeException.disposing(Disposable disposable, [String? target])
      : this._('${_prefix(target)}$disposable is disposing');

  DisposeException.disposed(Disposable disposable, [String? target])
      : this._('${_prefix(target)}$disposable was disposed');

  DisposeException.unknown(Disposable disposable)
      : this._('$disposable is not subtype of AsyncDisposable or SyncDisposable');

  DisposeException.aggregate(Map<Disposable, Object> exceptions)
      : this._(_exceptionsToString(exceptions));

  factory DisposeException(Disposable disposable, [String? target]) {
    final prefix = _prefix(target);
    return DisposeException._('$prefix$disposable is disposing');
  }

  @override
  String toString() => message;
}

String _prefix(String? x) => x == null ? '' : 'Can not access $x because ';

String _exceptionsToString(Map<Disposable, Object> exceptions) {
  var lines = 'One or more exceptions has been occured while disposing bag\n';
  var i = 0;
  for (final ex in exceptions.entries) {
    lines += '$i ${ex.key}\n${ex.value}\n';
    i++;
  }

  return lines;
}
