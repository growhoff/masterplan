import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/distributionDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/distributionDetails/bloc/state.dart';
import 'widgets/details_distrib_item.dart';

class DetailDistribPageChM extends StatelessWidget {
  const DetailDistribPageChM({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitDistributionDetailsChMas>(
      create: (context) => CubitDistributionDetailsChMas(stateMain.listAreaId!, stateMain.machineList!),
      child: const DetailDistribContent(),
    );
  }
}

class DetailDistribContent extends StatelessWidget {
  const DetailDistribContent({super.key});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Stack(
        children:[ 
          SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BlocBuilder<CubitDistributionDetailsChMas, StateDistributionDetailsChMas>(
                  builder: (context, state) {
                      List<ExpansionPanel> list = [];
                      for (var i = 0; i < state.pathListOper.length; i++) {
                        Color colorMain = ((state.pathListOper[i].setCount != null) && (state.pathListOper[i].setCount != 0) && (state.pathListOper[i].setMachine != null) ) ? Colors.greenAccent : Colors.white;
                        list.add(
                          ExpansionPanel(
                            headerBuilder: (context, isExpanded) => TitleItem(state.pathListOper[i], state.pathListOper[i].statusId == 4 ? Colors.amberAccent : colorMain), 
                            body: BodyItem(i, colorMain),
                            isExpanded: state.pathListOper[i].isSelected,
                            backgroundColor: colorMain,
                          ));
                      }
                      return state.isLoading 
                      ?  const Center(child: CircularProgressIndicator()) 
                      : state.pathListOper.isNotEmpty 
                      ? ExpansionPanelList(
                        children: list,
                        expansionCallback: (index, isExpanded) => context.read<CubitDistributionDetailsChMas>().toggleSelect(index),
                      )
                      : const Center(child: Text('Список пуст'));
                  }
                ),
                const SizedBox(height: 8),
                
              ],
            )
          ),
        ),
        Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () =>
                    context.read<CubitDistributionDetailsChMas>().updateOperation(),
                child: const Text('Отправить в работу')),
        )
        ]
      ),
    );
  }
}