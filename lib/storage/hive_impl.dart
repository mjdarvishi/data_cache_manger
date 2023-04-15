

import 'package:data_cache_manger/storage/storage.dart';
import 'package:hive_flutter/adapters.dart';

class StorageImplimentation implements Storage {
  final String _hiveBoxName = 'cache storage';
  StorageImplimentation() {
     Hive.initFlutter();
  }

  Future<Box> getBox()async{
    Box hive=await Hive.openBox(_hiveBoxName);
    return hive;
  }
  @override
  Future<void> clear({String? prefix}) async {
    final box=await getBox();
    if (prefix == null) {
      await box.clear();
    } else {
      for (var key in box.keys) {
        if (key is String && key.startsWith(prefix)) {
          await box.delete(key);
        }
      }
    }
  }

  @override
  Future<void> delete(String key) async {
    final box=await getBox();
    return box.delete(key);
  }

  @override
  Future<String?> read(String key) async {
    final box=await getBox();
    return box.get(key);
  }

  @override
  Future<void> write(String key, String value) async {
    final box=await getBox();
    return box.put(key, value);
  }

  @override
  Future<int> count({String? prefix}) async {
    final box=await getBox();
    if (prefix == null) {
      return box.length;
    } else {
      var count = 0;
      for (var key in box.keys) {
        if (key is String && key.startsWith(prefix)) {
          count++;
        }
      }
      return count;
    }
  }
}
