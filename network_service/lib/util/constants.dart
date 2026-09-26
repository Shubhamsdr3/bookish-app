import 'dart:collection';

enum Environment { DEV, PROD }

class Constants {
  static const TNC_URL = "https://bookissh-web.web.app/";

  static Map<String, dynamic> _config = HashMap();

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.DEV:
        _config = _Config.debugConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }

  static get BASE_URL {
    return _config[_Config.BASE_URL];
  }
}

class _Config {
  static const BASE_URL = "base_url";

  static Map<String, dynamic> debugConstants = {
    BASE_URL: "http://192.168.0.5:3000",
  };

  static Map<String, dynamic> prodConstants = {
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
