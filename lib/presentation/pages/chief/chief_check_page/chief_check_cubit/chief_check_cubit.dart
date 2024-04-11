import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/service/stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_operation_table.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../data/repositories/supabase/dto2/stage_dto.dart';
import '../../../../../domain/model/stage_model.dart';

part 'chief_check_state.dart';

class ChiefCheckCubit extends Cubit<ChiefCheckState> {
  ChiefCheckCubit() : super(ChiefCheckState());

  final stageStream = StageTable().stream();

  final operationsStream = ZOperationTable().stream().listen((list){print(list);});

  final replaySubject = ReplaySubject();

  Future<void> listenStreams()async{

   var x =  stageStream.listen((list) => print(list));

    print('начали листен');

      replaySubject.add(x);
    replaySubject.stream.listen(print);
    print('добавили первый');
    replaySubject.stream.listen(operationsStream);


  }

}
