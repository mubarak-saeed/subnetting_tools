import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ip_address.dart';
import '../../domain/repositories/ip_calculator_repository.dart';
import '../../../history/logic/history_storage.dart';

// States
abstract class IpCalculatorState extends Equatable {
  const IpCalculatorState();

  @override
  List<Object> get props => [];
}

class IpCalculatorInitial extends IpCalculatorState {}

class IpCalculatorLoading extends IpCalculatorState {}

class IpCalculatorSuccess extends IpCalculatorState {
  final IpAddress ipAddress;

  const IpCalculatorSuccess(this.ipAddress);

  @override
  List<Object> get props => [ipAddress];
}

class IpCalculatorError extends IpCalculatorState {
  final String messageKey;

  const IpCalculatorError([this.messageKey = 'invalidInput']);

  @override
  List<Object> get props => [messageKey];
}

// Cubit
class IpCalculatorCubit extends Cubit<IpCalculatorState> {
  final IpCalculatorRepository repository;

  IpCalculatorCubit(this.repository) : super(IpCalculatorInitial());

  void calculateIp(String ipAddress, int subnetMask) async {
    try {
      emit(IpCalculatorLoading());

      if (!repository.validateIpAddress(ipAddress)) {
        emit(const IpCalculatorError('invalidInput'));
        return;
      }

      final result = repository.calculateAll(ipAddress, subnetMask);
      await HistoryStorage.addHistoryEntry(
        HistoryEntry(
          title: '$ipAddress/$subnetMask',
          details: 'Network: ${result.networkAddress}\nBroadcast: ${result.broadcastAddress}\nNetmask: ${result.netmask}\nHosts: ${result.usableHosts}',
          featureType: 'IP Calculator',
        ),
      );
      emit(IpCalculatorSuccess(result));
    } catch (_) {
      emit(const IpCalculatorError('invalidInput'));
    }
  }

  void reset() {
    emit(IpCalculatorInitial());
  }
}
