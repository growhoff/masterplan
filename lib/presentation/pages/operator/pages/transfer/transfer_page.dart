import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'package:master_plan/theme/theme.dart';

class TransferPage extends StatelessWidget {
  const TransferPage(this.activeTransfer, {super.key, required this.operation});
  final ItemOperOp? operation;
  final int activeTransfer;
  @override
  Widget build(BuildContext context) {
    final listTransfer = operation!.list.first.listTransfer;
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Список переходов'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.maxFinite,
                      child: Card(
                        color: Colors.white24,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text('№ п/п',
                                      textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Наименование перехода',
                                    textAlign: TextAlign.center,
                                  )),
                              Expanded(
                                  child: Text('Т шт., мин',
                                      textAlign: TextAlign.center)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Card(
                        color: index == activeTransfer
                            ? AppColors.orangeMaket
                            : index > activeTransfer
                                ? AppColors.greyMaket
                                : AppColors.greenMaket,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text('$index',
                                      textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    listTransfer[index].name,
                                    textAlign: TextAlign.center,
                                  )),
                              Expanded(
                                  child: Text(
                                      '${listTransfer[index].timesh}',
                                      textAlign: TextAlign.center)),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 2),
                      itemCount: listTransfer!.length,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
