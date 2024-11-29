part of 'dispatcher_analytics_2_cubit.dart';

@immutable
sealed class DispatcherAnalytics2State {}

final class DispatcherAnalytics2InitialState
    extends DispatcherAnalytics2State {}

final class DispatcherAnalyticsLoadedState extends DispatcherAnalytics2State {
  //сюда то что при загруке старнгциы
}

final class DispatcherAnalyticsSelectUnitState
    extends DispatcherAnalytics2State {
  //список цехов открываем на блоклистенер диалог

  final List<Unit> unitsList;

  DispatcherAnalyticsSelectUnitState({
    required this.unitsList,
  });
}

final class DispatcherAnalyticsSelectedUnitState
    extends DispatcherAnalytics2State {
  final Unit selectedUnit;

  DispatcherAnalyticsSelectedUnitState({required this.selectedUnit});
}

final class DispatcherAnalyticsSelectedAreaState
    extends DispatcherAnalytics2State {
  final Area selectedArea;

  DispatcherAnalyticsSelectedAreaState({required this.selectedArea});
}

final class DispatcherAnalyticsSelectAreaState
    extends DispatcherAnalytics2State {
  //список участков открываем на блоклистенер диалог

  DispatcherAnalyticsSelectAreaState({required this.areasList});

  final List<Area> areasList;
}

final class DispatcherAnalyticsSelectDateState
    extends DispatcherAnalytics2State {
  //на блок листенер открыть дейт рендж пикер(хуйню)
}

final class DispatcherAnalyticsSelectedDateState
    extends DispatcherAnalytics2State {
  //на блок листенер открыть дейт рендж пикер(хуйню)
}

final class DispatcherAnalyticsUploadReadyOperationsReportState
    extends DispatcherAnalytics2State {}



final class DispatcherAnalyticsUploadedReadyOperationsReportState
    extends DispatcherAnalytics2State {



}

final class DispatcherAnalyticsUploadTotalNumberReadyOperationsReportState
    extends DispatcherAnalytics2State {
  //
}

final class DispatcherAnalyticsSelectMonitoringStatusesFiltersState
    extends DispatcherAnalytics2State {}
