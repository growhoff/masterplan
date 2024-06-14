import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_cubit/chief_staff_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/chief_staff_list_element.dart';

class OperatorsListPage extends StatelessWidget {
  const OperatorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefStaffCubit(),
      child: const OperatorsListPageView(),
    );
  }
}

class OperatorsListPageView extends StatefulWidget {
  const OperatorsListPageView({super.key});

  @override
  State<OperatorsListPageView> createState() => _OperatorsListPageViewState();
}

class _OperatorsListPageViewState extends State<OperatorsListPageView> {
  @override
  void initState() {
    context.read<ChiefStaffCubit>().fetchDropDownsItems();
    super.initState();
    context.read<ChiefStaffCubit>().fetchOperators();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список операторов'),
      ),
      body: SafeArea(
        child: BlocBuilder<ChiefStaffCubit, ChiefStaffState>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: context.read<ChiefStaffCubit>().selectedArea,
                      onChanged: (String? value) {
                        setState(() => context
                                .read<ChiefStaffCubit>()
                                .selectedArea =
                            value ??
                                context.read<ChiefStaffCubit>().selectedArea);
                        context.read<ChiefStaffCubit>().fetchOperators();
                      },
                      items: state.areasNamesList
                          .map((String region) => DropdownMenuItem(
                                value: region,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(region),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  state.status == ChiefStaffStatus.success
                      ? Expanded(
                          child: ListView.separated(
                              addAutomaticKeepAlives: false,
                              itemBuilder: (context, index) => StaffListElement(
                                  fetchStaff: () => context
                                      .read<ChiefStaffCubit>()
                                      .fetchOperators(),
                                  positionStaff: state.positionStaffList[index],
                                  deleteStaff: () {
                                    context.read<ChiefStaffCubit>().deleteStaff(
                                        positionStaff:
                                            state.positionStaffList[index]);
                                  }),
                              separatorBuilder: (ctx, i) => SizedBox(
                                    height: 10,
                                  ),
                              itemCount: state.positionStaffList.length),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
