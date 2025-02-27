import 'dart:convert';
import 'dart:io';

import 'package:mineral/framework.dart';
import 'package:mineral_environment/environment.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';

class EnvironmentService extends MineralService with Console {
  final MineralEnvironment environment = MineralEnvironment();

  EnvironmentService(): super(inject: true);

  Future<MineralEnvironment> load () async {
    if (hasValidEnvironment()) {
      environment.data.putIfAbsent('APP_TOKEN', () => Platform.environment.getOrFail('APP_TOKEN'));
      environment.data.putIfAbsent('LOG_LEVEL', () => Platform.environment.getOrFail('LOG_LEVEL'));
      environment.data.putIfAbsent('DEBUGGER', () => Platform.environment.getOrFail('DEBUGGER'));

      return environment;
    }

    File file = File(join(Directory.current.path, '.env'));
    if (!await file.exists()) {
      await createEnvironmentFile();
      exit(0);
    }

    List<String> content = await file.readAsLines(encoding: utf8);

    for (String line in content) {
      if (line.isNotEmpty) {
        List<String> content = line.split(':');
        String key = content.removeAt(0).trim();
        String value = content.join(':').trim();

        environment.data.putIfAbsent(key, () => value);
      }
    }

    return environment;
  }

  Future<void> createEnvironmentFile () async {
    String token = '';
    console.info('We will create your environment file..');

    final environmentFile = File(join(Directory.current.path, '.env'));
    final sink = environmentFile.openWrite();
    sink.write(['APP_NAME: My mineral application', 'APP_TOKEN: $token', 'LOG_LEVEL: info', 'REPORTER: debug'].join('\n'));

    await sink.flush();
    await sink.close();
  }

  bool hasValidEnvironment () {
    final requiredEnvironmentKeys = ['APP_TOKEN', 'APP_NAME', 'LOG_LEVEL', 'DEBUGGER'];
    final requiredKeysChecked = requiredEnvironmentKeys.fold([], (previousValue, element) => [...previousValue, Platform.environment.get(element) != null]);

    return !requiredKeysChecked.contains(false);
  }
}