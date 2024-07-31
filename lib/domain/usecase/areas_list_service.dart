class AreasListService {
  List<int> areasIdsList = [];

  static final AreasListService instance = AreasListService._internal();

  AreasListService._internal();

  factory AreasListService(List<int> areasIdsList) {
    instance.areasIdsList = areasIdsList;

    return instance;
  }
}
