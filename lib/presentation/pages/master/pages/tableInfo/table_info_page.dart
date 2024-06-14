import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './widgets/table_info.dart';
import './bloc/cubit.dart';

class TableInfoPage extends StatelessWidget {
  const TableInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitTableInfo>(
      create: (context) => CubitTableInfo(1),
      child: const TableInfoContent(),
    );
  }
}

class TableInfoContent extends StatelessWidget {
  const TableInfoContent({super.key});
  @override
  Widget build(BuildContext context) {
    return  const SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child:  Column(
            children: [
              Text('1'),
              TableInfo([])
            ],
          )
        ),
      ),
    );
  }
}
