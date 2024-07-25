import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_model.dart';

class DetailsInUnitQuantityPage extends StatelessWidget {
  const DetailsInUnitQuantityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stageInUnitModel =
        ModalRoute.of(context)?.settings.arguments as StagesInUnitModel;

    return DetailsInUnitQuantityPageView(
      stageInUnitModel: stageInUnitModel,
    );
  }
}

class DetailsInUnitQuantityPageView extends StatefulWidget {
  const DetailsInUnitQuantityPageView({
    required this.stageInUnitModel,
    super.key,
  });

  final StagesInUnitModel stageInUnitModel;

  @override
  State<DetailsInUnitQuantityPageView> createState() =>
      _DetailsInUnitQuantityPageViewState();
}

class _DetailsInUnitQuantityPageViewState
    extends State<DetailsInUnitQuantityPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('количество'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Text(
                              'Деталей в цехе',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text('В работе'),
                                Text(
                                    '${widget.stageInUnitModel.inWorkDetailsQuantity}'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Готовы к выгрузке',
                                ),
                                Text(
                                    '${widget.stageInUnitModel.readyDetailsQuantity}'),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Всего'),
                                Text(
                                    '${widget.stageInUnitModel.inUnitDetailsQuantity}'),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Text(
                              'Деталей диспетчеру(от диспетчера)',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text('Выгружено'),
                                Text(
                                    '${widget.stageInUnitModel.uploadedDetailsQuantity}'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Ожидается',
                                ),
                                Text(
                                    '${widget.stageInUnitModel.expectedDetailsQuantity}'),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Требуется добавить'),
                                Text(''),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Text(
                              'Всего деталей в этапе',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text('Требуется'),
                                Text(
                                    '${widget.stageInUnitModel.totalDetailsQuantity}'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Доступно',
                                ),
                                Text(
                                    '${widget.stageInUnitModel.availableDetailsQuantity}'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Отбраковано',
                                ),
                                Text(
                                    '${widget.stageInUnitModel.defectDetailsQuantity}'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
