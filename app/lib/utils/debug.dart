typedef OnCall = void Function(List arguments);

class VarargsFunction {
  VarargsFunction(this._onCall);

  final OnCall _onCall;

  @override
  noSuchMethod(Invocation invocation) {
    if (!invocation.isMethod || invocation.namedArguments.isNotEmpty) {
      super.noSuchMethod(invocation);
    }
    final arguments = invocation.positionalArguments;
    return _onCall(arguments);
  }
}

final smartPrint = VarargsFunction((arguments) {
  String toPrint = '';
  for (final value in arguments) {
    toPrint += '$value ';
  }
  print(toPrint);
}) as dynamic;
