import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String messageKey;

  const Failure(this.messageKey);

  @override
  List<Object?> get props => [messageKey];
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.messageKey = 'invalidInput']);
}

class SubnetFailure extends Failure {
  const SubnetFailure([super.messageKey = 'invalidSubnetMask']);
}

class RangeFailure extends Failure {
  const RangeFailure([super.messageKey = 'invalidRange']);
}

class CalculationFailure extends Failure {
  const CalculationFailure([super.messageKey = 'invalidInput']);
}
