import 'dart:collection';

enum Environment { staging, production }

const String appEnvName = String.fromEnvironment(
  'APP_ENV',
  defaultValue: 'staging',
);

class Constants {
  static const TNC_URL = "https://bookissh-web.web.app/";
  static const SOCKET_URL = 'http://192.168.0.5:3000';

  static Map<String, dynamic> _config = HashMap();

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.production:
        _config = _Config.productionConstants;
      default:
        _config = _Config.stagingConstants;
        break;
    }
  }

  static get BASE_URL {
    return _config[_Config.BASE_URL];
  }
}

class _Config {
  static const BASE_URL = "base_url";

  static Map<String, dynamic> get stagingConstants => {
    BASE_URL: "http://localhost:3000",
  };

  static Map<String, dynamic> get productionConstants => {
    BASE_URL: "https://20241221t151330-dot-bookish-5aae7.df.r.appspot.com",
  };
}

class LazyInitializer<T> {
  T? _value;

  bool get isInitialized => _value != null;

  T get value {
    if (_value == null) {
      throw StateError('Value has not been initialized');
    }
    return _value!;
  }

  set value(T newValue) => _value = newValue;
}
