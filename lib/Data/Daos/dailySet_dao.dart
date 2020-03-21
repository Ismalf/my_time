import 'package:my_time/Data/Models/activity_model.dart';
import 'package:my_time/Data/Models/daily_set.dart';
import 'package:sembast/sembast.dart';

import '../database_controller.dart';

class DailySetDao {
  static const String DS_STORE_NAME = 'DS';
  final _taskStor = intMapStoreFactory.store(DS_STORE_NAME);

  Future get _db async => await DSDatabaseHelper.instance.db;

  Future insert(DailySet t) async {
    print('insert');
    print(t.toJson());
    return await _taskStor.add(await _db, t.toJson());
  }

  Future updateTask(DailySet u, int key) async {
    final finder = Finder(filter: Filter.byKey(key));
    await _taskStor.update(await _db, u.toJson(), finder: finder);
  }

  Future<bool> delete(int key) async {
    final finder = Finder(filter: Filter.byKey(key));
    try {
      await _taskStor.delete(await _db, finder: finder);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<DailySetList> getAllData() async {
    final record = await _taskStor.findFirst(await _db);
    return DailySetList.fromJson(record.value);
  }

  Future getDaySet(DateTime day) async {
    Finder finder = Finder(
      filter: Filter.custom(
        (snapshot) {
          var x = snapshot.value.day as DateTime;
          return x.day == day.day && x.month == day.month && x.year == day.year;
        },
      ),
    );
    final record = await _taskStor.find(await _db, finder: finder);
    if (record.length == 0) return new DailySet(day: day, tasks: []);
    return DailySet.fromJson(record[0].value);
  }
}
