import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:student_app/Utils/appData.dart';
import 'package:student_app/model/customCard.dart';
import 'package:student_app/model/dataTableModel.dart';
import 'package:student_app/model/donutChartModel.dart';
import 'package:student_app/model/drawerModel.dart';
import 'package:student_app/model/mentorModel.dart';
import 'package:student_app/model/programModel.dart';
import 'package:student_app/utils/widgets/dataTable.dart';
import 'package:student_app/views/dashboard_view.dart';

class DashBoardProvider extends ChangeNotifier {
  DashBoardProvider() : super();

  String name = "John Doe";
  String designation = "Mentor";

  List<CustomCardModel> cardList = [];

  List<ProgramModel> programList = [
    ProgramModel(
        programName: "Leadership Growth",
        category: "Engineer",
        createdBy: "(202)555-0191",
        rating: "contact@creativehub.com"),
    ProgramModel(
        programName: "Tech Mentorship",
        category: "Doctor",
        createdBy: "(303)555-0123",
        rating: "support@innovativeideas.com"),
    ProgramModel(
        programName: "Career Guidance",
        category: "Artist",
        createdBy: "(404)555-0145",
        rating: "info@techsolutions.com"),
    ProgramModel(
        programName: "Business Skills",
        category: "Chief",
        createdBy: "(505)555-0167",
        rating: "hello@designworld.com"),
    ProgramModel(
        programName: "Soft Skills",
        category: "Teacher",
        createdBy: "(606)555-0189",
        rating: "team@futuretech.com"),
  ];

  List<MentorModel> mentorList = [
    MentorModel(mentorName: "John kennedy", program: "Teaching Program", email: "johnk@gmail.com", rating: "4.9"),
    MentorModel(mentorName: "Jenifer Smith", program: "Teaching Program", email: "jenny@gmail.com", rating: "4.8"),
    MentorModel(mentorName: "Thomas shelby", program: "Teaching Program", email: "thomas@gmail.com", rating: "4.7"),
    MentorModel(mentorName: "John Miller", program: "Teaching Program", email: "miller@gmail.com", rating: "4.5"),
    MentorModel(mentorName: "Jason Morgan", program: "Teaching Program", email: "jason@gmail.com", rating: "4.8"),
  ];
  
  void initializeCardList() {
    cardList = [
      CustomCardModel(
        leadingLabel: "Planned Programs",
        trialLabel: "View All",
        showDropdown: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            InfoTile(
                count: '327',
                label: 'Programs',
                bgColor: Colors.amber.shade100,
                textColor: Colors.black87),
            const SizedBox(height: 10),
            InfoTile(
                count: '120',
                label: 'Mentors',
                bgColor: Colors.cyan.shade100,
                textColor: Colors.black87),
            const SizedBox(height: 10),
            InfoTile(
                count: '556',
                label: 'Mentees',
                bgColor: Colors.purple.shade100,
                textColor: Colors.black87),
            const SizedBox(height: 10),
          ],
        ),
      ),
      CustomCardModel(
        leadingLabel: "Program Status Metrics",
        trialLabel: "Month",
        showDropdown: true,
        child: BarChartWidget(f: this),
      ),

      CustomCardModel(
        leadingLabel: "Top Program",
        leadingIcon: Icons.open_in_new,
        trialLabel: "View All",
        showDropdown: false,
        child: DataTableWidget(getContext: (dataTableContext) {
          List<DataColumn> columns = [];
          List<DataRow> rows = [];
          columns.add(const DataColumn(label: Text('Program Name')));
          columns.add(const DataColumn(label: Text('Category')));
          columns.add(const DataColumn(label: Text('Created By')));
          columns.add(const DataColumn(label: Text('Rating')));
          columns.add(const DataColumn(label: Text('View')));

          if(programList.isNotEmpty) {
            for(var p in programList) {
              List<DataCell> singleCell = [];
              singleCell.add(DataCell(Text(p.programName)));
              singleCell.add(DataCell(Text(p.category)));
              singleCell.add(DataCell(Text(p.createdBy)));
              singleCell.add(DataCell(Text(p.rating)));
              singleCell.add(const DataCell(Icon(Icons.remove_red_eye_outlined)));
              rows.add(DataRow(cells: singleCell));
            }
          }

          return DataTableWidgetModel(
            columns: columns,
            rows: rows,
            isEnable: programList.isNotEmpty,
          );
        }),
      ),
      CustomCardModel(
        leadingLabel: "Top Mentors",
        leadingIcon: Icons.open_in_new,
        trialLabel: "View All",
        showDropdown: false,
        child: DataTableWidget(getContext: (dataTableContext) {
          List<DataColumn> columns = [];
          List<DataRow> rows = [];
          columns.add(const DataColumn(label: Text('Mentor Name')));
          columns.add(const DataColumn(label: Text('Program')));
          columns.add(const DataColumn(label: Text('Email')));
          columns.add(const DataColumn(label: Text('Rating')));
          columns.add(const DataColumn(label: Text('View')));

          if(mentorList.isNotEmpty) {
            for(var p in mentorList) {
              List<DataCell> singleCell = [];
              singleCell.add(DataCell(Text(p.mentorName)));
              singleCell.add(DataCell(Text(p.program)));
              singleCell.add(DataCell(Text(p.email)));
              singleCell.add(DataCell(Row(children: [const Icon(Icons.star,color: Colors.yellow,),Text(p.rating)],)));
              singleCell.add(const DataCell(Icon(Icons.remove_red_eye_outlined)));
              rows.add(DataRow(cells: singleCell));
            }
          }

          return DataTableWidgetModel(
            columns: columns,
            rows: rows,
            isEnable: mentorList.isNotEmpty,
          );
        }),
      ),

      CustomCardModel(
        leadingLabel: "Program Type Metrics",
        trialLabel: "Month",
        showDropdown: true,
        child: DonutWidget(
          f: this,
          sections: [
            PieChartSectionData(
              value: 40,
              title: '',
              color: Colors.amber,
              radius: 30,
            ),
            PieChartSectionData(
              value: 54,
              title: '',
              color: Colors.blueAccent,
              radius: 30,
            ),
          ],
          pieChartValues: [
            DonutChartValues(value: 40, title: 'Premium', color: Colors.amber),
            DonutChartValues(value: 54, title: 'Free', color: Colors.blueAccent),
          ],
        ),
      ),
      CustomCardModel(
        leadingLabel: "Program Mode Metrics",
        trialLabel: "Month",
        showDropdown: true,
        child: DonutWidget(
          f: this,
          sections: [
            PieChartSectionData(
              value: 36,
              title: '',
              color: Colors.blueAccent,
              radius: 30,
            ),
            PieChartSectionData(
              value: 50,
              title: '',
              color: Colors.blue.shade200,
              radius: 30,
            ),
          ],
          pieChartValues: [
            DonutChartValues(
                value: 36, title: 'Virtual', color: Colors.blueAccent),
            DonutChartValues(
                value: 50, title: 'Physical', color: Colors.blue.shade200),
          ],
        ),
      ),
    ];
  }

  List<DrawerMenu> drawerMenus = [
    DrawerMenu(icon: AppData.schedular, menuName: "Schedular"),
    DrawerMenu(icon: AppData.timesheet, menuName: "Timesheet"),
    DrawerMenu(icon: AppData.discussions, menuName: "Discussions"),
    DrawerMenu(icon: AppData.reports, menuName: "Reports"),
    DrawerMenu(icon: AppData.feedback, menuName: "Feedback"),
    DrawerMenu(icon: AppData.certificates, menuName: "Certificates"),
    DrawerMenu(icon: AppData.timesheet, menuName: "Feed"),
    DrawerMenu(icon: AppData.analytics, menuName: "Analytics"),
  ];

  late TabController tabController;

  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  List<BarChartGroupData> getBarChartData() {
    return [
      BarChartGroupData(x: 0, barRods: [
        BarChartRodData(toY: 10, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 25, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 30, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(toY: 10, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 05, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 15, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 2, barRods: [
        BarChartRodData(toY: 10, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 20, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 30, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 3, barRods: [
        BarChartRodData(toY: 5, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 20, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 25, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 4, barRods: [
        BarChartRodData(toY: 05, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 10, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 15, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 5, barRods: [
        BarChartRodData(toY: 10, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 15, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 20, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 6, barRods: [
        BarChartRodData(toY: 20, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 05, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 25, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 7, barRods: [
        BarChartRodData(toY: 10, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 20, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 30, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 8, barRods: [
        BarChartRodData(toY: 20, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 10, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 30, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 9, barRods: [
        BarChartRodData(toY: 10, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 15, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 25, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 10, barRods: [
        BarChartRodData(toY: 10, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 10, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 20, color: AppData.completedColor, width: 8),
      ]),
      BarChartGroupData(x: 11, barRods: [
        BarChartRodData(toY: 10, color: AppData.allProgramColor, width: 8),
        BarChartRodData(toY: 25, color: AppData.activeColor, width: 8),
        BarChartRodData(toY: 35, color: AppData.completedColor, width: 8),
      ]),
    ];
  }
}