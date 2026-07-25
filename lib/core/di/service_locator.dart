import '../../features/ip_calculator/data/repositories/ip_calculator_repository_impl.dart';
import '../../features/ip_calculator/domain/repositories/ip_calculator_repository.dart';
import '../settings/settings_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final IpCalculatorRepository ipCalculatorRepository;
  late final SettingsRepository settingsRepository;

  Future<void> init() async {
    settingsRepository = SettingsRepository();
    ipCalculatorRepository = IpCalculatorRepositoryImpl();
  }
}

final sl = ServiceLocator();
