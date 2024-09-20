import 'package:master_plan/domain/model/distrib_item_details.dart';

abstract class FilterList{

  static List<DistribItemDetails> getList(List<DistribItemDetails> pathListOper, String filter){
    Set<DistribItemDetails> newList = {};
   if (filter == 'clear'){
    newList.addAll(pathListOper);
   } else {
    newList.addAll(pathListOper.where((x) => x.detailNumber.toLowerCase().contains(filter.toLowerCase())).toList());
    newList.addAll(pathListOper.where((x) => x.stageNumber.toLowerCase().contains(filter.toLowerCase())).toList());
    newList.addAll(pathListOper.where((x) => x.operationName.toLowerCase().contains(filter.toLowerCase())).toList());
   }
  return newList.toList();
  }
  
}