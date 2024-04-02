// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageDistributionDTO2 extends Dto {
  final int id;
  final int stageId;
  final bool isdistributed;
  StageDistributionDTO2({
    required this.id,
    required this.stageId,
    required this.isdistributed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'stageId': stageId,
      'is_distributed': isdistributed,
    };
  }

  factory StageDistributionDTO2.fromMap(Map<String, dynamic> map) {
    return StageDistributionDTO2(
      id: map['id'] as int,
      stageId: map['stageId'] as int,
      isdistributed: map['is_distributed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDistributionDTO2.fromJson(String source) => StageDistributionDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
  }
