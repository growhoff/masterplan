import 'package:open_filex/open_filex.dart';

import '../../data/repositories/local/dto/filters_info_model.dart';
import '../../data/repositories/local/service/excel_service.dart';
import '../../data/repositories/local/service/notification_service.dart';
import '../../presentation/pages/master/pages/analytics_page/analytics_operation_model.dart';
import '../model/area.dart';
import '../model/report_items_models/monitoring_statuses_model.dart';
import '../model/unit.dart';

class UploadReportsService {
  UploadReportsService();

  final _excelService = ExcelService();

  Future uploadTotalNumberReadyOperationsReport({
    required List<TotalNumberReadyOperationModel>
        totalNumberReadyOperationModelsList,
    List<Area>? areasList,
    List<Unit>? unitsList,
    DateTime? timeStart,
    DateTime? timeEnd,
  }) async {
    if (timeStart == null) {
      timeStart == DateTime.now();
    }

    if (timeEnd == null) {
      timeEnd == DateTime.now();
    }

    String filterAreasNumbersString = '';

    areasList?.forEach((area) {
      if (area.id != 0) {
        filterAreasNumbersString =
            '${filterAreasNumbersString} ${area.number},';
      }
    });

    String filterUnitsNumbersString = '';
    unitsList?.forEach((unit) {
      if (unit.id != 0) {
        filterUnitsNumbersString =
            '${filterUnitsNumbersString} ${unit.number},';
      }
    });

    var filterTimeStart =
        DateTime.fromMillisecondsSinceEpoch(timeStart!.millisecondsSinceEpoch);

    String dateStart =
        '${filterTimeStart.day}.${filterTimeStart.month}.${filterTimeStart.year}';

    var filterTimeEnd =
        DateTime.fromMillisecondsSinceEpoch(timeEnd!.millisecondsSinceEpoch);

    String dateEnd =
        '${filterTimeEnd.day}.${filterTimeEnd.month}.${filterTimeEnd.year}';

    final filtersInfoModel = FiltersInfoModel(
        timeStart: dateStart,
        timeEnd: dateEnd,
        unitsNumbersList: filterUnitsNumbersString,
        areasNumbersList: filterAreasNumbersString);

    String filePath =
        await _excelService.uploadTotalNumberReadyOperationsReport(
      totalNumberReadyOperationModelsList: totalNumberReadyOperationModelsList,
      filtersInfo: filtersInfoModel,
    );
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    }

    NotificationService.showNotification(
        title: 'Отчет о производстве загружен',
        body: 'путь: $filePath',
        payload: filePath);

    NotificationService.onClickNotification.stream.listen((event) {
      print(event);
      OpenFilex.open(event);
    });
  }

  Future uploadTotalNumberReadyOperationsReportWithStringFilter({
    required List<TotalNumberReadyOperationModel>
        totalNumberReadyOperationModelsList,
    String? filterAreasNumbersString,
    String? filterUnitsNumbersString,
    DateTime? timeStart,
    DateTime? timeEnd,
  }) async {
    if (timeStart == null) {
      timeStart == DateTime.now();
    }

    if (timeEnd == null) {
      timeEnd == DateTime.now();
    }

    var filterTimeStart =
        DateTime.fromMillisecondsSinceEpoch(timeStart!.millisecondsSinceEpoch);

    String dateStart =
        '${filterTimeStart.day}.${filterTimeStart.month}.${filterTimeStart.year}';

    var filterTimeEnd =
        DateTime.fromMillisecondsSinceEpoch(timeEnd!.millisecondsSinceEpoch);

    String dateEnd =
        '${filterTimeEnd.day}.${filterTimeEnd.month}.${filterTimeEnd.year}';

    final filtersInfoModel = FiltersInfoModel(
        timeStart: dateStart,
        timeEnd: dateEnd,
        unitsNumbersList: filterUnitsNumbersString,
        areasNumbersList: filterAreasNumbersString);

    String filePath =
        await _excelService.uploadTotalNumberReadyOperationsReport(
      totalNumberReadyOperationModelsList: totalNumberReadyOperationModelsList,
      filtersInfo: filtersInfoModel,
    );
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    }
    NotificationService.showNotification(
        title: 'Отчет о производстве загружен',
        body: 'путь: $filePath',
        payload: filePath);

    NotificationService.onClickNotification.stream.listen((event) {
      print(event);
      OpenFilex.open(event);
    });
  }

  Future uploadReadyOperationsReport({
    List<Area>? areasList,
    List<Unit>? unitsList,
    DateTime? timeStart,
    DateTime? timeEnd,
    required List<AnalyticsOperationModel> analyticsOperationsModelsList,
  }) async {
    if (timeStart == null) {
      timeStart == DateTime.now();
    }

    if (timeEnd == null) {
      timeEnd == DateTime.now();
    }

    String filterAreasNumbersString = '';
    if (areasList != null) {
      for (int i = 0; i < areasList.length; i++) {
        final area = areasList[i];
        if (area.id != 0) {
          if (filterAreasNumbersString == '') {
            filterAreasNumbersString = area.number;
          } else {
            filterAreasNumbersString =
                '$filterAreasNumbersString, ${area.number}';
          }
        }
      }
    }

    String filterUnitsNumbersString = '';

    if (unitsList != null) {
      for (int i = 0; i < unitsList.length; i++) {
        final unit = unitsList[i];
        if (unit.id != 0) {
          if (filterUnitsNumbersString == '') {
            filterUnitsNumbersString = '${unit.number}';
          } else {
            filterUnitsNumbersString =
                '$filterUnitsNumbersString, ${unit.number}';
          }
        }
      }
    }

    var filterTimeStart =
        DateTime.fromMillisecondsSinceEpoch(timeStart!.millisecondsSinceEpoch);

    String dateStart =
        '${filterTimeStart.day}.${filterTimeStart.month}.${filterTimeStart.year}';

    var filterTimeEnd =
        DateTime.fromMillisecondsSinceEpoch(timeEnd!.millisecondsSinceEpoch);

    String dateEnd =
        '${filterTimeEnd.day}.${filterTimeEnd.month}.${filterTimeEnd.year}';

    final filtersInfoModel = FiltersInfoModel(
        timeStart: dateStart,
        timeEnd: dateEnd,
        unitsNumbersList: filterUnitsNumbersString,
        areasNumbersList: filterAreasNumbersString);

    analyticsOperationsModelsList.forEach((operation) => print(
        'analyticsOperation: ${operation.batch.order?.number}.${operation.batch.number}.${operation.stage.number}'));

    String filePath = await _excelService.uploadReadyOperationsReportNew(
        analyticsOperationsList: analyticsOperationsModelsList,
        filtersInfo: filtersInfoModel);
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    }
    NotificationService.showNotification(
        title: 'Отчет о производстве загружен',
        body: 'путь: $filePath',
        payload: filePath);

    NotificationService.onClickNotification.stream.listen((event) {
      print(event);
      OpenFilex.open(event);
    });
  }

  Future uploadReadyOperationsReportWithStringFilter({
    required List<AnalyticsOperationModel> analyticsOperationsModelsList,
    String? filterAreasNumbersString,
    String? filterUnitsNumbersString,
    DateTime? timeStart,
    DateTime? timeEnd,
  }) async {
    if (timeStart == null) {
      timeStart == DateTime.now();
    }

    if (timeEnd == null) {
      timeEnd == DateTime.now();
    }

    var filterTimeStart =
        DateTime.fromMillisecondsSinceEpoch(timeStart!.millisecondsSinceEpoch);

    String dateStart =
        '${filterTimeStart.day}.${filterTimeStart.month}.${filterTimeStart.year}';

    var filterTimeEnd =
        DateTime.fromMillisecondsSinceEpoch(timeEnd!.millisecondsSinceEpoch);

    String dateEnd =
        '${filterTimeEnd.day}.${filterTimeEnd.month}.${filterTimeEnd.year}';

    final filtersInfoModel = FiltersInfoModel(
        timeStart: dateStart,
        timeEnd: dateEnd,
        unitsNumbersList: filterUnitsNumbersString,
        areasNumbersList: filterAreasNumbersString);

    analyticsOperationsModelsList.forEach((operation) => print(
        'analyticsOperation: ${operation.batch.order?.number}.${operation.batch.number}.${operation.stage.number}'));

    String filePath = await _excelService.uploadReadyOperationsReportNew(
        analyticsOperationsList: analyticsOperationsModelsList,
        filtersInfo: filtersInfoModel);

    if (filePath == '') {
      filePath = 'что-то пошло не так';
    }
    NotificationService.showNotification(
        title: 'Отчет о производстве загружен',
        body: 'путь: $filePath',
        payload: filePath);

    NotificationService.onClickNotification.stream.listen((event) {
      print(event);
      OpenFilex.open(event);
    });
  }



  Future uploadMonitoringStatusesReport({
    required List<MonitoringStatusesModel> monitoringStatusesModelsList,
    String? filterAreasNumbersString,
    String? filterUnitsNumbersString,
    DateTime? timeStart,
    DateTime? timeEnd,
  }) async {
    if (timeStart == null) {
      timeStart == DateTime.now();
    }

    if (timeEnd == null) {
      timeEnd == DateTime.now();
    }

    var filterTimeStart =
        DateTime.fromMillisecondsSinceEpoch(timeStart!.millisecondsSinceEpoch);

    String dateStart =
        '${filterTimeStart.day}.${filterTimeStart.month}.${filterTimeStart.year}';

    var filterTimeEnd =
        DateTime.fromMillisecondsSinceEpoch(timeEnd!.millisecondsSinceEpoch);

    String dateEnd =
        '${filterTimeEnd.day}.${filterTimeEnd.month}.${filterTimeEnd.year}';

    final filtersInfoModel = FiltersInfoModel(
        timeStart: dateStart,
        timeEnd: dateEnd,
        unitsNumbersList: filterUnitsNumbersString,
        areasNumbersList: filterAreasNumbersString);

    String filePath = await _excelService.uploadMonitoringStatusesReport(

      monitoringStatusesModelsList: monitoringStatusesModelsList,
    );
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    }
    NotificationService.showNotification(
        title: 'Отчет о производстве загружен',
        body: 'путь: $filePath',
        payload: filePath);

    NotificationService.onClickNotification.stream.listen((event) {
      print(event);
      OpenFilex.open(event);
    });
  }
}
