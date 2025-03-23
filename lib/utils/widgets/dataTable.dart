import 'package:flutter/material.dart';
import 'package:student_app/model/dataTableModel.dart';
import 'package:student_app/utils/appData.dart';

class DataTableWidget extends StatelessWidget {
  const DataTableWidget({super.key, this.getContext});

  final DataTableWidgetModel Function(BuildContext)? getContext;

  @override
  Widget build(BuildContext context) {
    DataTableWidgetModel dataTableWidgetModel = getContext!(context);

    return dataTableWidgetModel.isEnable!
        ? Container(
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            dividerThickness: 0,
            headingRowColor: WidgetStateProperty.all(AppData.appSecondColor.shade50),
            columns: dataTableWidgetModel.columns!,
            rows: dataTableWidgetModel.rows!,
          ),
        ),
      ),
    )
        : Container();
  }
}