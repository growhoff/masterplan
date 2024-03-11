// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/user.dart';

class StateMain extends Equatable{
    final UserModel user;
  const StateMain({
    required this.user,
  });

  @override
  bool operator ==(covariant StateMain other) {
    if (identical(this, other)) return true;
  
    return 
      other.user == user;
  }

  @override
  int get hashCode => user.hashCode;


  StateMain copyWith({
    UserModel? user,
  }) {
    return StateMain(
      user: user ?? this.user,
    );
  }
  
  @override
  List<Object?> get props => [user];
}
