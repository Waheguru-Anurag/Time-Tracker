  import 'package:flutter/material.dart';
  import 'package:flutter/widgets.dart';
  import 'package:table_calendar/table_calendar.dart';
  import 'package:timetracker/Event.dart';
  import 'package:timetracker/CustomListView.dart';
  import 'package:timetracker/Input.dart';

  void main() => runApp(MaterialApp(
    home: MyHomePage(),
  ));

  class MyHomePage extends StatefulWidget {
    @override
    _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
    CalendarController _calendarController;
    List _selectedevents;
    Map<DateTime,List> _events;
    DateTime _presentDay,_selectedDay;
    CustomListView customListView;

    @override
    void initState() {
      _calendarController = CalendarController();
      _presentDay = DateTime.now();
      if(_events==null) {
        _events = {
          _presentDay: [],
          //_calendarController.selectedDay:[],
        };
      }
      _selectedevents = _events[_presentDay] ?? [];
      customListView = CustomListView(selectedevents: _selectedevents,);
    }

    Future<EventWidget> createAlertDialog(BuildContext context){
      TextEditingController Task = TextEditingController();
      TextEditingController Hour = TextEditingController();
      TextEditingController Minute = TextEditingController();
      TextEditingController Second = TextEditingController();

      return showDialog(context: context,builder: (context){
        return Form(
          child: AlertDialog(
            title: Text("Enter the Event"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Input(
                          hintText: "Name",
                          icon: Icons.event,
                          controller: Task,
                          cursorColor: Colors.blue,
                          textInputType: TextInputType.text,
                        )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Input(
                          hintText: "HH",
                          controller: Hour,
                          cursorColor: Colors.blue,
                          textAlign: TextAlign.center,
                          textInputType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        child: Input(
                          hintText: "MM",
                          controller: Minute,
                          cursorColor: Colors.blue,
                          textAlign: TextAlign.center,
                          textInputType: TextInputType.number,
                        )
                      ),
                      Expanded(
                        child: Input(
                          hintText: "SS",
                          controller: Second,
                          cursorColor: Colors.blue,
                          textAlign: TextAlign.center,
                          textInputType: TextInputType.number,
                        ),
                      ),
                    ],
                 )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Submit"),
                  elevation: 1.0,
                  textColor: Colors.blue,
                  hoverColor: Colors.blue,
                  textTheme: ButtonTextTheme.accent,
                  onPressed: (){
                        EventWidget eventwidget = new EventWidget(
                            Task.text.toString(), Hour.text.toString(),
                            Minute.text.toString(), Second.text.toString());
                        Navigator.of(context).pop(eventwidget);

                  },
                )
              ],
            ),
        );
        });
      }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Time Tracker"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TableCalendar(
                  calendarController: _calendarController,
                  calendarStyle: CalendarStyle(
                  todayColor: Colors.blue,
                  selectedColor: Colors.orange,
                ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  initialCalendarFormat: CalendarFormat.week,
                  events: _events,
                  onDaySelected: _onDaySelected,
              ),
              Divider(
                color: Colors.grey,
                height: 0,
              ),
              // Expanded is used for resizing
              Flexible(
                child: customListView
              )
            ],
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
              createAlertDialog(context).then((onValue) {
                if (onValue != null) {
                  _selectedDay = _SelectedDay();
                  List events = _events[_selectedDay] ?? [];
                  events.add(onValue);
                  _events[_selectedDay] = events;
                  _onDaySelected(_selectedDay, events);
                }
              });
          },
          child: Icon(Icons.add),
        ),
      );
    }

    // The logic behind this function is that when the _calendar.selectedDay method is invoked for the present day then
    // the Datetime Object's Time Parameters doesn't match with those of the presentDay as a result the Events are not saved
    // in the _Present Day event list.
    DateTime _SelectedDay(){
      if(compare(_calendarController.selectedDay, _presentDay))
        return _presentDay;
      else
        return _calendarController.selectedDay;
    }

    void _onDaySelected(DateTime day, List events) {
      print('CALLBACK: _onDaySelected');
          customListView.ChangeList(events);
    }

    bool compare(DateTime dateTime1, DateTime dateTime2){
      int _date1,_month1,_year1;
      int _date2,_month2,_year2;

      _date1=dateTime1.day;
      _date2=dateTime2.day;
      _year1=dateTime1.year;
      _year2=dateTime2.year;
      _month1=dateTime1.month;
      _month2=dateTime2.month;

      if(_date1 == _date2 && _month1==_month2 && _year1==_year2)
        return true;

      return false;
    }

  }
