import 'cache_strategy.dart';
import 'storage/hive_impl.dart';

typedef AsyncFunc<T> = Function;
typedef SerializerFunc<T> = Function(dynamic);

class CacheManager {
  final StorageImplimentation sotrageImplimentation;

  CacheManager(
    this.sotrageImplimentation,
  );

  String? defaultSessionName;

  StrategyBuilder from<T>(String key) =>
      StrategyBuilder<T>(key, sotrageImplimentation)
          .withSession(defaultSessionName);

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
