
import 'package:data_cache_manger/cache_manager.dart';
import 'package:data_cache_manger/cache_strategy.dart';
import 'package:data_cache_manger/storage/storage.dart';

class CacheOrAsyncStrategy extends CacheStrategy {
  static final CacheOrAsyncStrategy _instance =
      CacheOrAsyncStrategy._internal();

  factory CacheOrAsyncStrategy() {
    return _instance;
  }

  CacheOrAsyncStrategy._internal();

  @override
  Future<T?> applyStrategy<T>(
          AsyncFunc<T> asyncFunc,
          String key,
          SerializerFunc<T> serializerFunc,
          int ttlValue,
          Storage storage) async =>
      await fetchCacheData(key, serializerFunc, storage, ttlValue: ttlValue) ??
      await invokeAsync(asyncFunc, key, storage);
}
