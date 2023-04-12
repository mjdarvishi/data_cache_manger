

import 'package:data_cache_manger/cache_manager.dart';
import 'package:data_cache_manger/cache_strategy.dart';
import 'package:data_cache_manger/storage/storage.dart';

class JustCacheStrategy extends CacheStrategy {
  static final JustCacheStrategy _instance = JustCacheStrategy._internal();

  factory JustCacheStrategy() {
    return _instance;
  }

  JustCacheStrategy._internal();
  @override
  Future<T?> applyStrategy<T>(
          AsyncFunc<T> asyncFunc,
          String key,
          SerializerFunc<T> serializerFunc,
          int ttlValue,
          Storage storage) async =>
      await fetchCacheData(key, serializerFunc, storage, ttlValue: ttlValue);
}
