import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/technologist/archive_page/widgets/archive_expansion_body_item.dart';
import 'package:master_plan/presentation/pages/technologist/archive_page/widgets/archive_expansion_title_item.dart';

import 'archive_cubit/archive_cubit.dart';

class DispatcherArchivePage extends StatelessWidget {
  const DispatcherArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchiveCubit(),
      child: const DispatcherArchivePageView(),
    );
  }
}

class DispatcherArchivePageView extends StatefulWidget {
  const DispatcherArchivePageView({super.key});

  @override
  State<DispatcherArchivePageView> createState() =>
      _DispatcherArchivePageViewState();
}

class _DispatcherArchivePageViewState extends State<DispatcherArchivePageView> {
  @override
  void initState() {
    context.read<ArchiveCubit>().fetchBatches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchiveCubit, ArchiveState>(
        builder: (context, state) {
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      await context
                          .read<ArchiveCubit>()
                          .loadDetailToArchive();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'технология загружается. пожалуйста, подождите')));
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10)),
                    child: const Text('Загрузить технологию (excel)',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                state.status == ArchiveStatus.success
                    ? Expanded(
                        child: ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => index <
                                    state.batchesList.length
                                ? ExpansionTile(
                                    maintainState: true,
                                    tilePadding: EdgeInsets.all(0),
                                    title: DispatcherArchiveExpansionTitleItem(
                                        state.batchesList[index]),
                                    childrenPadding:
                                        EdgeInsets.fromLTRB(20, 0, 20, 10),
                                    expandedAlignment: Alignment.topLeft,
                                    children: [
                                      DispatcherArchiveExpansionBodyItem(
                                        state.batchesList[index],
                                        deleteBatch: () => setState(() {
                                          context
                                              .read<ArchiveCubit>()
                                              .deleteBatchArchive(
                                                  state.batchesList[index].id);
                                        }),
                                      )
                                    ],
                                  )
                                : SizedBox(
                                    height: 50,
                                  ),
                            separatorBuilder: (ctx, i) => SizedBox(
                                  height: 5,
                                ),
                            itemCount: state.batchesList.length + 1),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
