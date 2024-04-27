import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/operations_distribution_page/chief_distribution_cubit/chief_distribution_cubit.dart';

class DropdownButtonCustom extends StatefulWidget {
  const DropdownButtonCustom(this.listItem,
      {required this.operationId, required this.areasMap, super.key});

  final List<String> listItem;
  final Map<String, dynamic> areasMap;
  final int operationId;

  @override
  State<DropdownButtonCustom> createState() => _DropdownButtonCustomState();
}

class _DropdownButtonCustomState extends State<DropdownButtonCustom> {
  late List<String> listItem;
  String? activeValue;

  @override
  void initState() {
    listItem = widget.listItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocProvider(
        create: (context) => ChiefDistributionCubit(),
        child: DropdownButton<String>(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            isExpanded: true,
            underline: Container(),
            borderRadius: BorderRadius.circular(12),
            value: activeValue,
            hint: const Text('Выберите участок'),
            items: listItem
                .map(
                  (e) => DropdownMenuItem(value: e, child: Text(e)),
                )
                .toList(),
            selectedItemBuilder: (context) => listItem
                .map((e) => Center(
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) {
              activeValue = value;
              setState(() {});
              if (value != null) {}
            }),
      ),
    );
  }
}
