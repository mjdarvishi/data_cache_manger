

import 'package:data_cache_manger/cache_manager.dart';
import 'package:data_cache_manger/cache_strategy.dart';
import 'package:data_cache_manger/storage/storage.dart';

class JustAsyncStrategy extends CacheStrategy {
  static final JustAsyncStrategy _instance = JustAsyncStrategy._internal();

  factory JustAsyncStrategy() {
    return _instance;
  }

  JustAsyncStrategy._internal();

  @override
  Future<T?> applyStrategy<T>(
          AsyncFunc<T> asyncFunc,
          String key,
          SerializerFunc<T> serializerFunc,
          int ttlValue,
          Storage storage) async =>
      await invokeAsync(asyncFunc, key, storage);
}
