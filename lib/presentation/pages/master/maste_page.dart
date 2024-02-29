import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

List<String> list = ['ФИО1', 'ФИО2', 'ФИО3'];

class MasterPage extends StatelessWidget {
  const MasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentMaster();
  }
}

class ContentMaster extends StatefulWidget {
  const ContentMaster({super.key});

  @override
  State<ContentMaster> createState() => _ContentMasterState();
}

class _ContentMasterState extends State<ContentMaster> {

  int index = 0;

  static const List<Widget> tabs = [
    Tab(icon: Icon(Icons.laptop_windows, color: Colors.black)),
    Tab(icon: Icon(Icons.last_page, color: Colors.black)),
    Tab(icon: Icon(Icons.schema, color: Colors.black)),
    Tab(icon: Icon(Icons.add_box_outlined, color: Colors.black)),
    Tab(icon: Icon(Icons.check_box, color: Colors.black)),
    Tab(icon: Icon(Icons.outbox, color: Colors.black)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Master Список смен'),
            actions: [
              Tooltip(
                message: 'Закрепить все',
                child: IconButton(onPressed: (){
                  // await actions.updateEquipmentCustomReset();
                  // await actions.updateEquipmentCustom();
                }, icon: const Icon(Icons.auto_fix_high),),
              ),
              Tooltip(
                message: 'Открепить все',
                child: IconButton(onPressed: (){
                  // await actions.updateEquipmentCustomReset();
                }, icon: const Icon(Icons.auto_fix_off),),
              )
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: TabBar(tabs: tabs.map((Widget el) => el).toList()),
          ),
          body: const TabBarView (
            children: [
            PageOne(),
            PageTest('1'),
            PageTest('2'),
            PageTest('3'),
            PageTest('4'),
            PageTest('5'),
          ])
        ),
      ),
    );
  }
}

class PageTest extends StatelessWidget {
  const PageTest(this.text,{super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text),);
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [  
                  
                  const Card(child: Calendar()),
                  const SizedBox(height: 8),
                  const Text('Распределение на станки'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: (){}, child: const Text('1 смена')),
                      ElevatedButton(onPressed: (){}, child: const Text('2 смена'))
                    ],
                  ),
                  const SizedBox(height: 8),
                  const ListW(),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(onPressed: (){}, child: const Text('Назначить')),
                  )
                ],
              ),
              ),
          ),
        );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  DateTime day = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: day,
              onDaySelected: (selectedDay, focusedDay) {
                day = focusedDay;
                setState(() {});
              },
            );
  }
}

class ListW extends StatelessWidget {
  const ListW({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                  height: 220,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) =>  Column(
                      children: [
                        const Text('Title'),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(list[index]),
                                Row(
                              children: [
                                IconButton(onPressed: (){}, icon: const Icon(Icons.add)),
                                IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
                              ],
                            ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                );
  }
}