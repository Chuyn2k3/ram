import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ram/presentation/pages/wifi_connect.dart';

import 'data/datasources/fake_rampeda_service.dart';
import 'data/datasources/http_rampeda_service.dart';
import 'data/datasources/rampeda_service.dart';
import 'data/repositories/rampeda_repository_impl.dart';
import 'domain/repositories/rampeda_repository.dart';
import 'presentation/cubit/rampeda_cubit.dart';
import 'presentation/pages/rampeda_page.dart';

void main() {
  // Service fake cho demo UI
  //final RampedaService service = FakeRampedaService();
  final RampedaService service = HttpRampedaService();
  final RampedaRepository repository = RampedaRepositoryImpl(service);

  runApp(RampedaApp(repository: repository));
}

class RampedaApp extends StatelessWidget {
  final RampedaRepository repository;

  const RampedaApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RampedaCubit(repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RAMPEDA Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          brightness: Brightness.light,
          fontFamily: 'Roboto',
        ),
        home:
            //const WifiConnectionPage(),
            RampedaPage(),
      ),
    );
  }
}
