import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreakScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Streak',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.white),
        ),
        actions: [Icon(Icons.share, color: Colors.white)],
      ),
      body: PersonalTab(),
    );
  }
}

class PersonalTab extends StatefulWidget {
  @override
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  DateTime currentMonth = DateTime.now();

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "134",
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF99AAB5)),
              ),
              SizedBox(width: 10),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.9, end: 1.2),
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 20 * value,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Transform.scale(
                      scale: value,
                      child: Icon(
                        Icons.local_fire_department,
                        size: 50,
                        color: Color(0xFF42A5F5),
                      ),
                    ),
                  );
                },
                onEnd: () => setState(() {}),
              ),
            ],
          ),
          Text("day streak!",
              style: TextStyle(fontSize: 20, color: Colors.white)),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, color: Colors.purpleAccent, size: 30),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("3 hours until your streak resets!",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 5),
                    Text("START LESSON",
                        style: TextStyle(color: Colors.purpleAccent)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Streak Calendar",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: _previousMonth,
                    ),
                    Text(
                      DateFormat.yMMMM().format(currentMonth),
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CalendarGrid(currentMonth: currentMonth),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Streak Goal",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 134 / 150,
              backgroundColor: Color(0xFF2F3D48),
              color: Color(0xFF42A5F5),
              minHeight: 10,
            ),
          ),
          SizedBox(height: 5),
          Text("134 / 150 DAYS", style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),
          Text("Streak Society",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          SizedBox(height: 10),
          FreezeCard(),
          SizedBox(height: 10),
          LockedCard(),
        ],
      ),
    );
  }
}

class CalendarGrid extends StatelessWidget {
  final List<String> days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
  final DateTime currentMonth;

  CalendarGrid({required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final startingWeekday = firstDay.weekday % 7;
    final totalDays =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final totalCells = ((startingWeekday + totalDays) / 7).ceil() * 7;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map((e) => Expanded(
                    child: Center(
                      child: Text(e, style: TextStyle(color: Colors.white)),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: 6),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.2,
          ),
          itemCount: totalCells,
          itemBuilder: (context, index) {
            if (index < startingWeekday ||
                index >= startingWeekday + totalDays) {
              return Container(); // Empty cell
            }

            int day = index - startingWeekday + 1;
            bool isStreakDay = day <= 7;

            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isStreakDay ? Color(0xFF42A5F5) : Color(0xFF2F3D48),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class FreezeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: ListTile(
          leading: Icon(Icons.ac_unit, color: Colors.lightBlueAccent),
          title: Text("1 Extra Freeze", style: TextStyle(color: Colors.white)),
          subtitle: Text(
            "Additional protection for your streak if you miss a day of practice.\nREFILLS IN 66 DAYS",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class LockedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: ListTile(
          leading: Icon(Icons.lock, color: Colors.grey),
          title: Text("365 days", style: TextStyle(color: Colors.white)),
          subtitle: Text(
            "Reach a streak of 365 days to unlock this reward.\nLOCKED",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
