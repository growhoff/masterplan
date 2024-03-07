/*
class ReorderWidget extends StatefulWidget {
  const ReorderWidget({super.key});

  @override
  State<ReorderWidget> createState() => _ReorderWidgetState();
}

class _ReorderWidgetState extends State<ReorderWidget> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
                header: const RowList(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки',),
                itemBuilder: (context, index) => RowList(text1: list[index].plan, text2: list[index].operation, text3: list[index].time), 
                itemCount: list1.length, 
                onReorder: (oldIndex, newIndex) {},
              );
  }
}
*/