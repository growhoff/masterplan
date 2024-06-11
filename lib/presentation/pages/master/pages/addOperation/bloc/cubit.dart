import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class CubitAddOperation extends Cubit<StateAddOperation> { 
  CubitAddOperation() : super(const StateAddOperation());
}