import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './bloc/cubit.dart';
import './bloc/state.dart';
import 'widgets/details_distrib_item.dart';

class DetailDistribPageChM extends StatelessWidget {
  const DetailDistribPageChM({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitDistributionDetailsChMas>(
      create: (context) => CubitDistributionDetailsChMas(stateMain.listAreaId!, stateMain.machineList!, stateMain.listAreaMachineUser!),
      child: const DetailDistribContent(),
    );
  }
}

class DetailDistribContent extends StatelessWidget {
  const DetailDistribContent({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Распределение деталей'),
      ),
      body: SafeArea(
        child: Stack(
          children:[ 
            SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  BlocBuilder<CubitDistributionDetailsChMas,StateDistributionDetailsChMas>(
                      builder: (context, state) {
                        List<NameIndex> listItemArea = [];
                        if (state.listAreaMachine.isNotEmpty) {
                          for (var i = 0; i < state.listAreaMachine.length; i++) {
                            listItemArea.add(NameIndex(name: state.listAreaMachine[i].area.name, index: i));
                          }
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<int>(
                            isExpanded: true,
                            underline: Container(),
                            borderRadius: BorderRadius.circular(12),
                            hint: const Text('Выберите участок'),
                            value: state.activeArea,
                            items: listItemArea.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name))).toList(),
                            selectedItemBuilder: (context) => listItemArea.map((e) => Center(child: Text(e.name))).toList(),
                            onChanged: (value) => value != null ? context.read<CubitDistributionDetailsChMas>().setActiveArea(value) : null,
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 8),

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
      ),
    );
  }
}