import 'dart:async';

import 'package:data_cache_manger/data_cache_manger.dart';

import 'cache_strategy.dart';
import 'storage/hive_impl.dart';

typedef AsyncFunc<T> = Function;
typedef SerializerFunc<T> = Function(dynamic);

class CacheManager<T> {
  final StorageImplimentation sotrageImplimentation = StorageImplimentation();

  CacheManager();

  String? defaultSessionName;
  late StrategyBuilder _strategyBuilder;

  CacheManager.cacheOrSync(
      {required SerializerFunc serializerFunc,
      required String key,
      required AsyncFunc<T> asyncBloc,
      int? ttlValue}) {
    _strategyBuilder = StrategyBuilder<T>(key, sotrageImplimentation)
        .withSerializer((serializerFunc))
        .withAsync(asyncBloc)
        .withStrategy(CacheOrAsyncStrategy());
    if (ttlValue != null) {
      _strategyBuilder.withTtl(ttlValue);
    }
  }

  CacheManager.justCache(
      {required String key, required SerializerFunc serializerFunc, int? ttlValue}) {
    _strategyBuilder = StrategyBuilder<T>(key, sotrageImplimentation)
        .withAsync((){})
        .withSerializer(serializerFunc)
        .withStrategy(JustCacheStrategy());
    if (ttlValue != null) {
      _strategyBuilder.withTtl(ttlValue);
    }
  }
  CacheManager.justAsync(
      {required String key, required AsyncFunc<T> asyncBloc, int? ttlValue}) {
    _strategyBuilder = StrategyBuilder<T>(key, sotrageImplimentation)
        .withAsync(asyncBloc)
        .withSerializer((p0) {})
        .withStrategy(JustAsyncStrategy());
    if (ttlValue != null) {
      _strategyBuilder.withTtl(ttlValue);
    }
  }

  Future<T?> call() async {
    try {
      return await _strategyBuilder._strategy.applyStrategy<T?>(
          _strategyBuilder._asyncFunc,
          _strategyBuilder.buildSessionKey(_strategyBuilder._key),
          _strategyBuilder._serializerFunc,
          _strategyBuilder._ttlValue,
          _strategyBuilder._cacheStorage);
    } catch (exception) {
      rethrow;
    }
  }

  Future clear({String? prefix}) async {
    if (defaultSessionName != null && prefix != null) {
      await sotrageImplimentation.clear(
          prefix: "${defaultSessionName}_$prefix");
    } else if (prefix != null) {
      await sotrageImplimentation.clear(prefix: prefix);
    } else if (defaultSessionName != null) {
      await sotrageImplimentation.clear(prefix: defaultSessionName);
    } else {
      await sotrageImplimentation.clear();
    }
  }
}

class StrategyBuilder<T> {
  final String _key;
  final StorageImplimentation _cacheStorage;

  StrategyBuilder(this._key, this._cacheStorage);

  late AsyncFunc<T> _asyncFunc;
  late SerializerFunc<T> _serializerFunc;
  late CacheStrategy _strategy;
  int _ttlValue = CacheStrategy.defaultTTLValue;
  String? _sessionName;

  StrategyBuilder withAsync(AsyncFunc<T> asyncBloc) {
    _asyncFunc = asyncBloc;
    return this;
  }

  StrategyBuilder withStrategy(CacheStrategy strategyType) {
    _strategy = strategyType;
    return this;
  }

  StrategyBuilder withTtl(int ttlValue) {
    _ttlValue = ttlValue;
    return this;
  }

  StrategyBuilder withSession(String? sessionName) {
    _sessionName = sessionName;
    return this;
  }

  StrategyBuilder withSerializer(SerializerFunc serializerFunc) {
    _serializerFunc = serializerFunc;
    return this;
  }

  String buildSessionKey(String key) =>
      _sessionName != null ? "${_sessionName}_$key" : key;

  Future<T?> execute() async {
    try {
      return await _strategy.applyStrategy<T?>(_asyncFunc,
          buildSessionKey(_key), _serializerFunc, _ttlValue, _cacheStorage);
    } catch (exception) {
      rethrow;
    }
  }
}
