import 'package:flutter/material.dart';

class DataTableWidgetModel {
  final List<DataColumn>? columns;
  final List<DataRow>? rows;
  final bool? isEnable;

  DataTableWidgetModel(
      {required this.columns, required this.rows, this.isEnable = false});
}