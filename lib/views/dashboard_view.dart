import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/Utils/appData.dart';
import 'package:student_app/model/customCard.dart';
import 'package:student_app/model/donutChartModel.dart';
import 'package:student_app/providers/dashboard_provider.dart';
import 'package:student_app/utils/widgets/dataTable.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardView();
}

class _DashboardView extends State<DashboardView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<DashBoardProvider>().tabController =
        TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    context.read<DashBoardProvider>().tabController.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DashBoardProvider f = context.read<DashBoardProvider>();
    f.initializeCardList();
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppData.appPrimaryColor,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppData.appSecondColor,
                    width: 3.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: Image.asset(AppData.profile).image,
                ),
              ),
            ),
            actions: [
              AppBarIcon(icon: Icons.search, onPressed: () {}),
              const SizedBox(width: 1),
              AppBarIcon(icon: Icons.notifications, onPressed: () {}),
              const SizedBox(width: 1),
              GestureDetector(
                child: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
              const SizedBox(width: 5)
            ],
          ),
          endDrawerEnableOpenDragGesture: true,
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const ListTile(
                  title: Text('Admin',
                      style: TextStyle(
                          color: AppData.appSecondColor,
                          fontWeight: FontWeight.bold,
                          fontSize: AppData.fontSize * 3)),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppData.appSecondColor,
                            width: 8.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: Image.asset(AppData.profile).image,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(f.name),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(f.designation,
                          style: const TextStyle(fontWeight: FontWeight.w300)),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: List.generate(f.drawerMenus.length, (index) {
                    var a = f.drawerMenus[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      child: ListTile(
                        leading: Image.asset(a.icon!),
                        title: Text(a.menuName!),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          body: Selector(
            selector: (context, DashBoardProvider p) => p.selectedIndex,
            builder: (context, value, child) {
              return IndexedStack(
                index: value,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ResponsiveLayoutBuilder(f: f,list: f.cardList),
                      ],
                    ),
                  ),
                  const EmptyWidget(
                    icon: Icons.today_sharp,
                    text: "Coming Soon",
                    widgetColor: Colors.grey,
                  ),
                  UserWidget(f: f),
                  const EmptyWidget(
                    icon: Icons.description,
                    text: "There are no Pending Requests",
                    widgetColor: Colors.grey,
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: Selector(
            selector: (context, DashBoardProvider p) => p.selectedIndex,
            builder: (context, value, child) {
              return BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.today_sharp),
                    label: 'Programs',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_outlined),
                    label: 'Users',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.description),
                    label: 'Requests',
                  ),
                ],
                currentIndex: value,
                selectedItemColor: AppData.appSecondColor,
                unselectedItemColor: Colors.black,
                onTap: f.onItemTapped,
                type: BottomNavigationBarType.fixed,
              );
            },
          ),
        ),
      ),
    );
  }
}

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade50),
        child: IconButton(
          icon: Icon(icon, color: AppData.appThirdColor),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    super.key,
    required this.f,
    required this.list,
  });
  final DashBoardProvider f;
  final List<CustomCardModel> list;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTab = constraints.maxWidth > 600;
        if (isTab) {
          List<Widget> rows = [];
          for (int i = 0; i < list.length;) {
            final current = list[i];
            final isDataTable = current.child is DataTableWidget;
            if (isDataTable) {
              rows.add(Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomCard(f: f, model: current),
              ));
              i += 1;
            } else {
              final first = current;
              CustomCardModel? second;
              int nextIndex = i + 1;
              while (nextIndex < list.length) {
                if (list[nextIndex].child is! DataTableWidget) {
                  second = list[nextIndex];
                  break;
                }
                nextIndex++;
              }
              rows.add(Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: CustomCard(f: f, model: first)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: second != null
                            ? CustomCard(f: f, model: second)
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ));
              i += 1 + (second != null ? 1 : 0);
            }
          }
          return Column(children: rows);
        } else {
          return Column(
            children:
            List.generate(list.length, (i) {
              return CustomCard(
                  f: f, model: list[i]);
            }),
          );
        }
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.f,
    required this.model,
  });

  final DashBoardProvider f;
  final CustomCardModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: AppData.appPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.tealAccent,
                              Colors.blueAccent,
                              Colors.blue,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        width: MediaQuery.sizeOf(context).width / 100,
                        height: MediaQuery.sizeOf(context).height / 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        model.leadingLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppData.fontSize + 6,
                        ),
                      ),
                      const SizedBox(width: 5),
                      model.leadingIcon != null
                          ? Icon(model.leadingIcon,size: 19,)
                          : const SizedBox()
                    ],
                  ),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: AppData.appSecondColor.shade50,
                        borderRadius: BorderRadius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          model.showDropdown
                              ? DropdownButton<String>(
                                  value: model.trialLabel,
                                  iconEnabledColor: AppData.appSecondColor,
                                  iconDisabledColor: AppData.appSecondColor,
                                  focusColor: AppData.appSecondColor,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: [
                                    DropdownMenuItem(
                                      value: model.trialLabel,
                                      child: Text(model.trialLabel, style: const TextStyle(color: AppData.appSecondColor)),
                                    ),
                                  ],
                                  onChanged: null,
                                )
                              : Text(
                                  model.trialLabel,
                                  style: TextStyle(
                                    color: model.showDropdown ? AppData.appSecondColor : null,
                                    fontSize: AppData.fontSize + 6
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              model.child,
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.count,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  final String count;
  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({
    super.key,
    required this.f,
  });

  final DashBoardProvider f;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: f.getBarChartData().length * 60,
              child: AspectRatio(
                aspectRatio: 1.4,
                child: BarChart(BarChartData(
                  barGroups: f.getBarChartData(),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 10,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) {
                        switch (v.toInt()) {
                          case 0:
                            return const Text('Jan');
                          case 1:
                            return const Text('Feb');
                          case 2:
                            return const Text('Mar');
                          case 3:
                            return const Text('Apr');
                          case 4:
                            return const Text('May');
                          case 5:
                            return const Text('Jun');
                          case 6:
                            return const Text('Jul');
                          case 7:
                            return const Text('Aug');
                          case 8:
                            return const Text('Sep');
                          case 9:
                            return const Text('Oct');
                          case 10:
                            return const Text('Nov');
                          case 11:
                            return const Text('Dec');
                          default:
                            return const Text('');
                        }
                      },
                    )),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  groupsSpace: 20,
                )),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TitleDot(color: AppData.allProgramColor, text: 'All programs'),
            TitleDot(color: AppData.activeColor, text: 'Active'),
            TitleDot(color: AppData.completedColor, text: 'Completed'),
          ],
        ),
      ],
    );
  }
}

class DonutWidget extends StatelessWidget {
  const DonutWidget({
    super.key,
    required this.f,
    required this.sections,
    required this.pieChartValues,
  });

  final DashBoardProvider f;
  final List<PieChartSectionData> sections;
  final List<DonutChartValues> pieChartValues;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.4,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 0,
                    startDegreeOffset: -190,
                    centerSpaceRadius: 90,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Programs',
                    style: TextStyle(fontSize: AppData.fontSize),
                  ),
                  Text(
                    sections.fold(0.0, (sum, section)=> sum + section.value).toInt().toString(),
                    style: const TextStyle(
                      fontSize: AppData.fontSize * 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(pieChartValues.length, (i) {
                return TitleDot(
                    color: pieChartValues[i].color, text: "${pieChartValues[i].title} ${pieChartValues[i].value.toInt()}");
              }))
        ],
      ),
    );
  }
}

class TitleDot extends StatelessWidget {
  final Color color;
  final String text;

  const TitleDot({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({
    super.key,
    required this.f,
  });

  final DashBoardProvider f;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppData.appSecondColor,
                width: 8.0,
              ),
            ),
            child: CircleAvatar(
              radius: MediaQuery.sizeOf(context).aspectRatio * 250,
              backgroundImage: Image.asset(AppData.profile).image,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            f.name,
            style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).aspectRatio * 100),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(f.designation,
              style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).aspectRatio * 80,
                  fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.widgetColor,
  });

  final IconData icon;
  final String text;
  final Color widgetColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,
              size: MediaQuery.sizeOf(context).aspectRatio * 150,
              color: widgetColor),
          const SizedBox(
            height: 10,
          ),
          Text(text,
              style: TextStyle(fontSize: AppData.fontSize, color: widgetColor)),
        ],
      ),
    );
  }
}
