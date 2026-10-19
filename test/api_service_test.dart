import 'package:flutter_test/flutter_test.dart';
import 'package:network_service/base_api_service.dart';
import 'package:network_service/util/constants.dart';

void main() {
  test('ApiService creates the Dio client without forcing Alice early', () {
    Constants.setEnvironment(Environment.staging);
    final service = ApiService();

    expect(service.isInitialized, isFalse);
    expect(() => service.alice, throwsStateError);
    expect(service.aliceNavigatorKey, isNull);
    expect(service.apiClient.options.baseUrl, isNotNull);
    expect(service.apiClient.options.baseUrl, Constants.BASE_URL);
  });

  test('staging and production select different base URLs', () {
    Constants.setEnvironment(Environment.staging);
    expect(Constants.BASE_URL, 'http://localhost:3000');

    Constants.setEnvironment(Environment.production);
    expect(
      Constants.BASE_URL,
      'https://20241221t151330-dot-bookish-5aae7.df.r.appspot.com',
    );
  });

  test('APP_ENV defaults to staging and rejects an unknown name', () {
    expect(appEnvName, 'staging');
    expect(environmentFromName('staging'), Environment.staging);
    expect(environmentFromName('production'), Environment.production);
    expect(() => environmentFromName('dev'), throwsArgumentError);
  });
}
