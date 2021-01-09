
import 'package:mobx/mobx.dart';

part 'symptomOverviewGraphStore.g.dart';



class SymptomOverviewGraphStore = _SymptomOverviewGraphStoreBase with _$SymptomOverviewGraphStore;

// The store-class
abstract class _SymptomOverviewGraphStoreBase with Store {
  @observable
  int touchedIndex;

  @action
  Future<void> initStore() async {
    touchedIndex=-1;
  }

}