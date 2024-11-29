import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/domain/usecase/button_status.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/status/status_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/transfer/transfer_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/button_icon_item.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_input_comment.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_work.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'package:master_plan/theme/theme.dart';
import 'line_text_spawn.dart';
import 'timer/timer.dart';
import 'elevated_button_castom.dart';

class ContentDetail extends StatelessWidget {
  const ContentDetail(this.pageData, this.statusBtn, this.countBr, this.activeTransfer, {super.key});
  final String statusBtn;
  final PageItem pageData;
  final int countBr;
  final int activeTransfer;

  @override
  Widget build(BuildContext context) {
    print(statusBtn);
    // print('${pageData.operActive!.list.first.operation.id}');
    final astivePage = context.read<CubitWork>().state.activePage;
    final activeTransfer = context.read<CubitWork>().state.activeTransfer;
    ItemOperOp? operation;
    if (pageData.operActive != null){
      operation = pageData.operActive!;
    } else{
      if (pageData.operQueueList.isNotEmpty){
        operation = pageData.operQueueList.first;
      }else{
        operation = null;
      }
    }

    return  operation == null
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.maxFinite,
              child: Card(
                color: Colors.red,
                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text('На оборудование не распределены детали. Обратитесь к мастеру!', textAlign: TextAlign.center,),
                ),
              ),
            ),

            const Time(true),
            const SizedBox(height: 16),
            Image.asset('assets/images/operator/notDetails.jpg', width: 300),

            const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButtonCastom(
                  icon: null,
                    text: 'Выбор статуса',
                    isActive: true,
                    color: Colors.greenAccent,
                    onPressed: () async{
                      String? value = '';
                      String? comment = '';
                      value = await Navigator.push(context, MaterialPageRoute(builder: (context) => StatusPage(statusBtn, true)));
                      if (value != null){
                        if (statusBtn != value && context.mounted) {comment = await showDialog<String>(context: context,builder: (BuildContext context) => DialogInputComment(operation == null ? 0 : operation.list.length));}
                        else{comment = '-';}
                        if (comment != ''){
                          if (context.mounted) await context.read<CubitWork>().setMonitor(value, comment!, statusBtn != value, operation == null ? -1 : operation.idPath);
                          if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != value);
                        }
                      }
                    }))
          ],
        )
        : Column(
            children: [
              LineButtonInfo(pageData, activeTransfer, operation, statusBtn),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${operation.list.first.batch.numberRS} ${operation.list.first.batch.name}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: operation.list.first.modific != null ? Colors.amber : Colors.black)),
                    Text('ТП: ${operation.list.first.batch.technology}'),
                    LineTextSpawn(title: '${operation.list.first.operation.number}.${operation.list.first.operation.name}', text: operation.list.first.listTransfer!.isEmpty ? '' : '(переходов - ${operation.list.first.listTransfer!.length})'),
                    Text('T п.з.= ${operation.list.first.operation.timepz}  T шт.= ${operation.list.first.operation.timeSH}  T шт.к.= ${(operation.list.first.operation.timeSH + (operation.list.first.operation.timepz / operation.list.length)).toStringAsFixed(2)}'),//T шт. + Т п. з./кол-во
                    // LineTextSpawn(title: 'Количество в опт. партии:', text: '${operation.list.length}'),
                    const SizedBox(height: 12),
                    Text('Производственный № детали: ${operation.idPath}'),
                  ],
                ),
              ),

              const Time(false),            
              
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButtonCastom(
                    icon: null,
                    text: 'Выбор статуса',
                    isActive: operation.pause == null,
                    color: operation.pause == null ? AppColors.greenMaket : Colors.white70,
                    onPressed: () async{
                      String? value = '';
                      String? comment = '';
                      value = await Navigator.push(context, MaterialPageRoute(builder: (context) => StatusPage(statusBtn, false)));
                      if (value != null){
                        if (statusBtn != value && context.mounted) {comment = await showDialog<String>(context: context,builder: (BuildContext context) => DialogInputComment(operation!.list.length));}
                        else{comment = '-';}
                        if (comment != ''){
                          if (context.mounted) await context.read<CubitWork>().setMonitor(value, comment!, statusBtn != value, operation!.idPath);
                          if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != value);
                        }
                      }
                    }))
            ],
          );
  }
}


class LineButtonInfo extends StatelessWidget {
  const LineButtonInfo(this.dataPage, this.activeTransfer, this.operation, this.statusBtn, {super.key});
  final PageItem dataPage;
  final int activeTransfer;
  final ItemOperOp? operation;
  final String  statusBtn;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonIconItem(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => QueuePage(dataPage: dataPage))), icon: Icons.description_outlined, isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой')),
            ButtonIconItem(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => TransferPage(operation: operation, activeTransfer))), icon: Icons.description, isActive: operation == null ? false : operation!.list.first.listTransfer!.isNotEmpty),
            ButtonIconItem(onPressed: ()=> showDialog(context: context,builder: (BuildContext context) => const DialogWork()), icon: Icons.import_contacts, isActive: true),
            ButtonIconItem(onPressed: ()=> showDialog(context: context,builder: (BuildContext context) => const DialogWork()), icon: Icons.devices_other, isActive: true),
          ],
        ),
      ),
    );
  }
}