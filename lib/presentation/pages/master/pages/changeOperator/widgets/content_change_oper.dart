import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/button_change.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/change_list_operator.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/dialog_calendar.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/drop_area.dart';
// import 'calendar.dart';

class ChangeOperatorContent extends StatelessWidget {
  const ChangeOperatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Распределение на станки',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(
                builder: (context, state) => Visibility(
                  visible: state.listAreaMachine.length > 1,
                  child:
                      DropAreaChangeOper(state.activeArea, state.listItemArea),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(
                    builder: (context, state) => ElevatedButton(
                          onPressed: () async {
                            int? val;
                            val = await showDialog<int>(context: context,builder: (BuildContext context) => DialogCalendar(state.days));
                            if (val != null && context.mounted) context.read<CubitChangeOperator>().setDate(DateTime.fromMillisecondsSinceEpoch(val));
                          },
                          child: Text('Дата: ${TimeConverter().getStringDataYYMMDDdate(state.days)}', style: const TextStyle(color: Colors.black),),
                        )),
              ),
              const SizedBox(height: 8),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [ButtonChangeOper(1), Spacer(), ButtonChangeOper(2)],
              // ),

              BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(
                builder: (context, state) => state.maxChange != 0
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(state.maxChange, (int index) => ButtonChangeOper(index+1)),
                )
                : const Text('Нет смен')
              ),

              const SizedBox(height: 8),
              BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(
                builder: (context, state) => state.shiftsList!.isNotEmpty
                    ? ChangeListOperator(state.activeShiftsList)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
