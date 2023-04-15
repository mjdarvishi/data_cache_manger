//Method for creating fake data
import 'package:data_cache_manger/example/data_provider/fake_data_model.dart';

Future<FaKeData> getFakeDataAsync() async {
  print('Creating fake Data');
  await Future.delayed(const Duration(seconds: 1));
  return FaKeData('testName', 20);
}

