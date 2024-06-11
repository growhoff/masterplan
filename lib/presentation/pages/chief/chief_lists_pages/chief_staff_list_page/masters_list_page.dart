import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_cubit/chief_staff_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/chief_staff_list_element.dart';

class MastersListPage extends StatelessWidget {
  const MastersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefStaffCubit(),
      child: const MastersListPageView(),
    );
  }
}

class MastersListPageView extends StatefulWidget {
  const MastersListPageView({super.key});

  @override
  State<MastersListPageView> createState() => _MastersListPageViewState();
}

class _MastersListPageViewState extends State<MastersListPageView> {
  @override
  void initState() {
    context.read<ChiefStaffCubit>().fetchDropDownsItems();
    super.initState();
    context.read<ChiefStaffCubit>().fetchMasters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список мастеров'),
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
                        context.read<ChiefStaffCubit>().fetchMasters();
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
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => StaffListElement(
                            fetchStaff:
                                context.read<ChiefStaffCubit>().fetchMasters,
                            staffModel: state.staffList[index],
                            deleteStaff: (){}),
                        separatorBuilder: (ctx, i) => SizedBox(height: 10,),
                        itemCount: state.staffList.length),
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
