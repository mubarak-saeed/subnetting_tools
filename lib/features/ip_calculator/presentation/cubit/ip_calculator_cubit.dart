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
  final String message;

  const IpCalculatorError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class IpCalculatorCubit extends Cubit<IpCalculatorState> {
  final IpCalculatorRepository repository;

  IpCalculatorCubit(this.repository) : super(IpCalculatorInitial());

  void calculateIp(String ipAddress, int subnetMask) async {
    try {
      emit(IpCalculatorLoading());

      if (!repository.validateIpAddress(ipAddress)) {
        emit(const IpCalculatorError('Invalid IP address format'));
        return;
      }

      final result = repository.calculateAll(ipAddress, subnetMask);
      await HistoryStorage.addHistory(
          'IP: $ipAddress/$subnetMask\nNetwork: ${result.networkAddress}\nBroadcast: ${result.broadcastAddress}\nClass: ${result.networkClass}\nHosts: ${result.totalHosts}');
      emit(IpCalculatorSuccess(result));
    } catch (e) {
      emit(IpCalculatorError(e.toString()));
    }
  }

  void reset() {
    emit(IpCalculatorInitial());
  }
}
