import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:master_plan/domain/model/batch_archive.dart';

import '../../../../../domain/model/batch.dart';

class ArchiveExpansionBodyItem extends StatelessWidget {
  const ArchiveExpansionBodyItem(this.batch, {super.key});

  final BatchArchive batch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Описание:',
                ),
                Text(
                  '',
                  softWrap: true,
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10))),
                    onPressed: () {
                      Navigator.pushNamed(context, '/dispatcherArchiveStagesPage',
                          arguments: batch);
                    },
                    child: Text('подробнее'))),
          )
        ],
      ),
    );
  }
}
