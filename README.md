This package helps you to cache your data base on the expire time and also with diffrent kind of methods

<h2>Caching methods:</h2>
    <b>1-CacheOrAsynch</b></br>
    <b>2-JustCache</b></br>
    <b>3-JustAsync</b></br></br>

# Getting started

<p>For using this package you just to need add it to your pubspec.yaml file.</p>
<b>
data_cache_manger :last version </b>
  <br><br/>
After that import it where ever you want to use it.

<b>`import 'package:data_cache_manger/data_cache_manger.dart';`</b>

And finally like the blow codes use it to retrvied data from api or get data from storage.</br>
<b>Retrieved data cacheOrAsync</b>
And finally like the blow code use it to get data from api or get data from storage.

```dart
 void test() async {
  CacheManager _cacheManager = CacheManager(StorageImplimentation());
  final apiProvider = AuthRepository(http);

  await _cacheManager
      .from<Login>("")
      .withSerializer((result) {})
      .withAsync(() => apiProvider.sendCode(''))
      .withStrategy(CacheOrAsyncStrategy())
      .execute();
}
```
<br>

<b>Retrieved data justAsync</b>
```dart
void justAsync() async {
  //  it will just retrieve data async
  CacheManager<FaKeData> cacheManager = CacheManager<FaKeData>.justAsync(
      key: 'your key',
      asyncBloc: getFakeDataAsync);
  FaKeData? faKeData = await cacheManager();
  print(faKeData.toString());
}

```

<b>Retrieved data justAsync</b>
```dart
void justCache() async {
  //  it will just retrieve data async
  CacheManager<FaKeData> cacheManager = CacheManager<FaKeData>.justCache(
      key: 'your key',
    serializerFunc: (data) => Future.value(FaKeData.fromJson(data)),);
  FaKeData? faKeData = await cacheManager();
  print(faKeData.toString());
}
```

You can contribute on github https://github.com/mjdarvishi
