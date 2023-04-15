import 'package:data_cache_manger/cache_manager.dart';
import 'package:data_cache_manger/example/data_provider/data_provider.dart';
import 'package:data_cache_manger/example/data_provider/fake_data_model.dart';
import 'package:flutter/foundation.dart';

void cacheOrAsync() async {
  // First it will check if the data exist in the storage retrieved data from there
  // and if it does not exist there, then it retrieved them from async function
  CacheManager<FaKeData> cacheManager = CacheManager<FaKeData>.cacheOrSync(
      serializerFunc: (data) => Future.value(FaKeData.fromJson(data)),
      key: 'your key',
      asyncBloc: getFakeDataAsync);
  FaKeData? faKeData = await cacheManager();

}
void justAsync() async {
  //  it will just retrieve data async
  CacheManager<FaKeData> cacheManager = CacheManager<FaKeData>.justAsync(
      key: 'your key',
      asyncBloc: getFakeDataAsync);
  FaKeData? faKeData = await cacheManager();

}
void justCache() async {
  //  it will just retrieve data async
  CacheManager<FaKeData> cacheManager = CacheManager<FaKeData>.justCache(
      key: 'your key',
    serializerFunc: (data) => Future.value(FaKeData.fromJson(data)),);
  FaKeData? faKeData = await cacheManager();
}

