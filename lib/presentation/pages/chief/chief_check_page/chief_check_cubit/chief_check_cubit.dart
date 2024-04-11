import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chief_check_state.dart';

class ChiefCheckCubit extends Cubit<ChiefCheckState> {
  ChiefCheckCubit() : super(ChiefCheckInitial());
}
