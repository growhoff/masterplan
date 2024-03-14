// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/details.dart';
import 'package:master_plan/domain/model/equipment.dart';
import 'package:master_plan/domain/model/operatoroperations.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/region.dart';
import 'package:master_plan/domain/model/shiftsdistribution.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/domain/model/user_lite.dart';

class StateMain extends Equatable {
    final UserModel? user;
    final Company? company;
    final Region? region;
    final Position? position;
    final List<Equipment>? listEquipment;
    final List<Details>? listDetails;
    final List<Status>? listStatus;
    final List<OperatorOperations>? listoperatorOperations;
    final List<ShiftsDistribution>? listShiftsDistribution;
    final List<UserModelLite>? listOperators;
  const StateMain({
    this.user,
    this.company,
    this.region,
    this.position,
    this.listEquipment,
    this.listDetails,
    this.listStatus,
    this.listoperatorOperations,
    this.listShiftsDistribution,
    this.listOperators,
  });

  @override
  List<Object> get props {
    return [
      user ?? UserModel(id: -1, fio: '', position: '', region: '', company: ''),
      company ?? Company(id: -1, name: 'none', fullName: 'none'),
      region ?? Region(id: -1, name: 'none', number: -1),
      position ?? Position(id: -1, name: 'none'),
      listEquipment ?? [],
      listDetails ?? [],
      listStatus ?? [],
      listoperatorOperations ?? [],
      listShiftsDistribution ?? [],
      listOperators ?? [],
    ];
  }


  StateMain copyWith({
    UserModel? user,
    Company? company,
    Region? region,
    Position? position,
    List<Equipment>? listEquipment,
    List<Details>? listDetails,
    List<Status>? listStatus,
    List<OperatorOperations>? listoperatorOperations,
    List<ShiftsDistribution>? listShiftsDistribution,
    List<UserModelLite>? listOperators,
  }) {
    return StateMain(
      user: user ?? this.user,
      company: company ?? this.company,
      region: region ?? this.region,
      position: position ?? this.position,
      listEquipment: listEquipment ?? this.listEquipment,
      listDetails: listDetails ?? this.listDetails,
      listStatus: listStatus ?? this.listStatus,
      listoperatorOperations: listoperatorOperations ?? this.listoperatorOperations,
      listShiftsDistribution: listShiftsDistribution ?? this.listShiftsDistribution,
      listOperators: listOperators ?? this.listOperators,
    );
  }

  @override
  bool get stringify => true;
}
