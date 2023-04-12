import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'cache_manager.dart';
import 'cache_wrapper.dart';
import 'storage/storage.dart';

abstract class CacheStrategy {
  static const defaultTTLValue = 60 * 60 * 1000;

  Future _storeCacheData<T>(String key, T value, Storage storage) async {
    final cacheWrapper =
        CacheWrapper<T>(value, DateTime.now().millisecondsSinceEpoch);
    await storage.write(key, jsonEncode(cacheWrapper.toJson()));
  }

  Future<T> invokeAsync<T>(
      AsyncFunc<T> asyncFunc, String key, Storage storage) async {
    final asyncData = await asyncFunc();
    _storeCacheData(key, asyncData, storage);
    return asyncData;
  }

  Future<T?> fetchCacheData<T>(
      String key, SerializerFunc serializerFunc, Storage storage,
      {bool keepExpiredCache = false, int ttlValue = defaultTTLValue}) async {
    final value = await storage.read(key);
    if (value != null) {
      final cacheWrapper = CacheWrapper.fromJson(jsonDecode(value));
      if (_isValid(cacheWrapper, keepExpiredCache, ttlValue)) {
        if (kDebugMode) {
          print("Fetch cache data for key $key: ${cacheWrapper.data}");
        }
        return serializerFunc(cacheWrapper.data);
      }
    }
    return null;
  }

  Future<T?> applyStrategy<T>(AsyncFunc<T> asyncFunc, String key,
      SerializerFunc serializerFunc, int ttlValue, Storage storage);

  _isValid<T>(
          CacheWrapper<T> cacheWrapper, bool keepExpiredCache, int ttlValue) =>
      keepExpiredCache ||
      DateTime.now().millisecondsSinceEpoch <
          cacheWrapper.cachedDate + ttlValue;
}
