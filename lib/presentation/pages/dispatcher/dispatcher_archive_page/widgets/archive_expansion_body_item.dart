import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/batch_archive.dart';
import 'package:master_plan/presentation/pages/dispatcher/dispatcher_archive_page/archive_cubit/dispatcher_archive_cubit.dart';

class DispatcherArchiveExpansionBodyItem extends StatelessWidget {
  const DispatcherArchiveExpansionBodyItem(this.batchArchive,
      {required this.deleteBatch, super.key});

  final BatchArchive batchArchive;
  final VoidCallback deleteBatch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10))),
                  onPressed: () {
                    Navigator.pushNamed(context, '/archiveStagesPage',
                        arguments: batchArchive);
                  },
                  child: Text('подробнее'))),
          IconButton(
            onPressed: () {
              deleteBatch();
            },
            icon: Icon(
              Icons.delete_rounded,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
