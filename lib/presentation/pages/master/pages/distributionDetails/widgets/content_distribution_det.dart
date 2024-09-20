import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/widgets/content_head_item.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/widgets/details_title_item.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/widgets/dialog_filter_chois.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/widgets/drop_area_distrib.dart';
import 'details_body_item.dart';

class DetailDistribContent extends StatelessWidget {
  const DetailDistribContent({super.key});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scrollbar(
        thickness: 10,
        thumbVisibility: true,
        radius: const Radius.circular(10),
      child: ListView(
        children: [Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocBuilder<CubitDistributionDetails, StateDistributionDetails>(
                builder: (context, state) => Visibility(
                  visible: state.pathListOper.isNotEmpty,
                  child:  Card(
                    child: Row(
                      children: [
                        const Expanded(flex: 10, child: ContentHeadItem('Деталь\nОперация', color: Colors.white70)),
                        const Expanded(flex: 2, child: ContentHeadItem('Прио-\nритет', color: Colors.white70)),
                        const Expanded(flex: 4, child: ContentHeadItem('на распр.\nна участке,шт.', color: Colors.white70)),
                        IconButton(onPressed: () async{
                            String? value = await showDialog(context: context, builder: (context) => const DialogFilterChois());
                            if (value != null){ if (context.mounted) context.read<CubitDistributionDetails>().getFilterList(value);}
                          },
                          icon: const Icon(Icons.filter_alt_off_outlined, color: Colors.amber),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      
              const SizedBox(height: 8),
              const DropAreaDistrib(),
              const SizedBox(height: 8),
              BlocBuilder<CubitDistributionDetails, StateDistributionDetails>(builder: (context, state) => Visibility(visible: state.filterListOper.isNotEmpty,child: Text('Загрузка: ${TimeConverter().convertTimeMinHMin(state.timeWork)}')),),
              const SizedBox(height: 8),
      
              BlocBuilder<CubitDistributionDetails, StateDistributionDetails>(
                builder: (context, state) {
                    List<ExpansionPanel> list = [];
                    for (var i = 0; i < state.filterListOper.length; i++) {
                      Color colorMain = ((state.filterListOper[i].setCount != null) && (state.filterListOper[i].setCount != 0) && (state.filterListOper[i].setMachine != null) ) ? Colors.greenAccent : Colors.white;
                      list.add(
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) => TitleItem(state.filterListOper[i], state.filterListOper[i].statusId == 4 ? Colors.amberAccent : Colors.white70), 
                          body: BodyItem(i, colorMain, state.filterListOper[i].countTransfer > 0, state.filterListOper[i]),
                          isExpanded: state.filterListOper[i].isSelected,
                          backgroundColor: colorMain,
                        ));
                    }
                    return state.isLoading 
                    ?  const Center(child: CircularProgressIndicator()) 
                    : state.filterListOper.isNotEmpty 
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
        )],
      ),
              ),
    );
  }

  TableRow tableRowColor(List<Widget> children) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.grey),
      children: children,
    );
  }
}

