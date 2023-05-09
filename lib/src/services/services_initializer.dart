import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'local_storage/key_value_storage_base.dart';

final servicesInitializerProvider = Provider<ServicesInitializer>((ref) {
  return ServicesInitializer(ref);
});

class ServicesInitializer{
ServicesInitializer(this.ref);
final Ref ref;

  Future<void> init() async {
await _initKeyValueStorage();

  }
Future<void> _initKeyValueStorage() async {
    await KeyValueStorageBase.init();
  }
}