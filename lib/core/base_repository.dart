

abstract class IRepository<T> {
  final Set<T> services;
  IRepository({required this.services});

  T getService<T>() {
    final apService = services
        .firstWhere((service) => service is T) as T;
    return apService;
  }
}
