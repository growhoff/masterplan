import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/state.dart';
import 'widgets/details_distrib_item.dart';

class DetailDistribPage extends StatelessWidget {
  const DetailDistribPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider(
      create: (context) => CubitDistributionDetails(stateMain.user!.areaId!, stateMain.machineList!),
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
                BlocBuilder<CubitDistributionDetails, StateDistributionDetails>(
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
                        expansionCallback: (index, isExpanded) => context.read<CubitDistributionDetails>().toggleSelect(index),
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
                    context.read<CubitDistributionDetails>().updateOperation(),
                child: const Text('Отправить в работу')),
        )
        ]
      ),
    );
  }
}