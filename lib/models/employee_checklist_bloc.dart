import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class EmployeeCheckListSite extends Equatable {
  final int id;
  final String knackId;
  final String customerSite;
  final String unitNoWithName;
  final DateTime workDate;

  EmployeeCheckListSite(
    this.id,
    this.knackId,
    this.customerSite,
    this.unitNoWithName,
    this.workDate,
  );

@override
List get props => [id, knackId, customerSite, unitNoWithName, workDate];
}
