import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/stages_in_batch_page.dart';
// import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/stages_in_batch_page.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/bloc/state.dart';

class StageOnAreaContent extends StatelessWidget {
  const StageOnAreaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        thickness: 10,
        thumbVisibility: true,
        radius: const Radius.circular(10),
      child: ListView(
        children: [SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('№ этапа', textAlign: TextAlign.center)),
                        Expanded(child: Text('№ чертежа', textAlign: TextAlign.center)),
                        Expanded(child: Text('Наименование', textAlign: TextAlign.center)),
                        // Expanded(child: Text('% выполнения этапа', textAlign: TextAlign.center)),
                        Expanded(child: Text('Состояние этапа', textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<CubitStageOnArea, StateStageOnArea>(
                  builder: (context, state) => 
                  state.listRes.isEmpty 
                  ? const Text('Пусто')
                  : ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => StagesInBatchPage(batch: state.listRes[index].batch, selectedStageId: state.listRes[index].stageId,))),
                      child: Card(
                        color: Colors.white70, 
                        // context.read<CubitStageOnArea>().readyPercentToColor(state.listRes[index].precentPerfect),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(state.listRes[index].stageNumber, textAlign: TextAlign.center)),
                              Expanded(child: Text(state.listRes[index].batchNumber, textAlign: TextAlign.center)),
                              Expanded(child: Text(state.listRes[index].batchName, textAlign: TextAlign.center)),
                              // Expanded(child: Text('${state.listRes[index].precentPerfect}%', textAlign: TextAlign.center)),
                              Expanded(child: Text(state.listRes[index].status, textAlign: TextAlign.center))
                            ],
                          ),
                        ),
                      ),
                    ),
                    //  
                    // separatorBuilder:(context, index) => const SizedBox(height: 10), 
                    itemCount: state.listRes.length,
                  ),
                )
              ],
            ),
          ),
        )],
      ),
    );
  }
}
