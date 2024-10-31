import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection_igls.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureInjection() => $initGetIt(getIt);
