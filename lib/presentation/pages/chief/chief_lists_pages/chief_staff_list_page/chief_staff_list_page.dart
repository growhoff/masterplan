import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_cubit/chief_staff_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/chief_staff_list_element.dart';

class ChiefStaffListPage extends StatelessWidget {
  const ChiefStaffListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefStaffCubit(),
      child: const ChiefStaffListPageView(),
    );
  }
}

class ChiefStaffListPageView extends StatefulWidget {
  const ChiefStaffListPageView({super.key});

  @override
  State<ChiefStaffListPageView> createState() => _ChiefStaffListPageViewState();
}

class _ChiefStaffListPageViewState extends State<ChiefStaffListPageView> {
  int activeIndex = 0;

  @override
  void initState() {
    context.read<ChiefStaffCubit>().fetchAreasAndStaff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('список персонала'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: SafeArea(
        child: Center(child: BlocBuilder<ChiefStaffCubit, ChiefStaffState>(
            builder: (context, state) {
          if (state is ChiefStaffState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                activeIndex = index;
                                context.read<ChiefStaffCubit>().activeAreaId =
                                    state.areasList[index].id;
                                context.read<ChiefStaffCubit>().fetchStaff();
                                setState(() {});
                              },
                              child: SizedBox(
                                  width: 200,
                                  child: Card(
                                      color: activeIndex == index
                                          ? Colors.blueGrey
                                          : const Color.fromARGB(0, 0, 0, 0),
                                      child: Center(
                                          child: Text(
                                              '${state.areasList[index].number} ${state.areasList[index].name}')))),
                            ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                        itemCount: state.areasList.length),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/chiefStaffAddPage')
                                  .then((_) {
                                context.read<ChiefStaffCubit>().fetchStaff();
                                setState(() {});
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10)),
                            child: Text(
                              'добавить',
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10)),
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text(
                                'загрузить(excel)',
                                style: TextStyle(fontSize: 18),
                              )))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => StaffListElement(
                            staffModel: state.staffList[index],
                            deleteStaff: () => {
                              context.read<ChiefStaffCubit>().deleteStaff(
                                  staffId: state.staffList[index].id,
                                  userId: state.staffList[index].userId,
                                  imagePath: '').then((_) => context
                                  .read<ChiefStaffCubit>()
                                  .fetchStaff()),
                            },
                            fetchStaff: () => {},
                          ),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: state.staffList.length),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        })),
      ),
    );
  }
}
