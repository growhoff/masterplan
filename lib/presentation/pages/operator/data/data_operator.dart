import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/work_page.dart';

abstract class DataOperator{

    static List<ElementBarData> listWork = [
    ElementBarData(header: 'Втулка', content: const PageDetail(detail: 'Втулка', operations: 'Резак')),
    ElementBarData(header: 'Карандаш', content: const PageDetail(detail: 'Карандаш', operations: 'Стакан')),
    ElementBarData(header: 'Ручка', content: const PageDetail(detail: 'Ручка', operations: 'Вилка')),
  ];
}