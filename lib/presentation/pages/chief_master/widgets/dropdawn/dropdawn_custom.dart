import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/chief_master/widgets/dropdawn/cubit/cubit.dart';
import 'package:master_plan/presentation/pages/chief_master/widgets/dropdawn/cubit/state.dart';
// import 'package:master_plan/domain/model/name_index.dart';

class Drop extends StatelessWidget {
  const Drop(this.widget, {super.key});
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    final cubitMain = context.read<CubitMain>().state;
    return BlocProvider<CubitDrop>(
      create: (context) => CubitDrop(cubitMain.listAreaMachine!),
      child: DropContent(widget),
      );
  }
}

class DropContent extends StatelessWidget {
  const DropContent(this.widget, {super.key});
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitDrop, StateDrop>(builder: (context, state) {
        return state.listItemArea!.isNotEmpty || state.listItemMachine!.isNotEmpty
      ? Column(
        children: [
            Container(
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
                items: state.listItemArea!.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name)),).toList(),
                selectedItemBuilder: (context) => state.listItemArea!.map((e) => Center(child: Text(e.name),)).toList(),
                onChanged: (value) => value != null ? context.read<CubitDrop>().setActiveArea(value) : null,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
              child: DropdownButton<int>(
                isExpanded: true,
                underline: Container(),
                borderRadius: BorderRadius.circular(12),
                hint: const Text('Выберите станок'),
            
                value: state.activeMachine,
                items: state.listItemMachine!.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name)),).toList(),
                selectedItemBuilder: (context) => state.listItemMachine!.map((e) => Center(child: Text(e.name),)).toList(),
                onChanged: (value) => value != null ? context.read<CubitDrop>().setActiveMachine(value) : null,
              ),
            ),
            const SizedBox(height: 20),
            widget],
      )
      : const Center(child: CircularProgressIndicator());
      });}
}