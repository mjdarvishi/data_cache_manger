This package helps you to cache your data base on the expire time and also with diffrent kind of methods
## Caching methods:
<h2>verity options:</h2></br>
    <b>1-CacheOrAsynch</b></br>
    <b>2-JustCache</b></br>
    <b>3-JustAsync</b></br>

## Getting started

<p>For using this package you just to need add it to your pubspec.yaml file.</p>
<b>
data_cache_manger :last version </b>
  <br><br/>
After that import it where ever you want to use it.

<b>`import 'package:data_cache_manger/data_cache_manger.dart';`</b>


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

## Additional information

You can contribute on github https://github.com/mjdarvishi
