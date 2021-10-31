import 'package:election_exit_poll_07610605/models/poll_item.dart';
import 'package:election_exit_poll_07610605/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/result';
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<List<PollItem>> _futureExitPoll;

  @override
  void initState() {
    super.initState();
    _futureExitPoll = _loadPoll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Image.asset(
                  "assets/images/vote_hand.png",
                  height: 110.0,
                  width: 110.0,
                ),
              ),
              Text(
                'EXIT POLL',
                style: TextStyle(fontSize: 23.0, color: Colors.white70),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                'เลือกตั้ง อบต.',
                style: GoogleFonts.prompt(fontSize: 30.0, color: Colors.white,fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'รายชื่อผู้สมัครรับเลือกตั้ง',
                style: GoogleFonts.prompt(fontSize: 20.0, color: Colors.white),
              ),
              Text(
                'นายกองค์การบริหารส่วนตำบลเขาพระ',
                style: GoogleFonts.prompt(fontSize: 20.0, color: Colors.white),
              ),
              Text(
                'อำเภอเมืองนครนายก จังหวัดนครนายก',
                style: GoogleFonts.prompt(fontSize: 20.0, color: Colors.white),
              ),
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: Container(
                    child: FutureBuilder<List<PollItem>>(
                      future: _futureExitPoll,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasData) {
                          var exitPoll = snapshot.data;
                          return ListView.builder(
                              padding: EdgeInsets.all(8.0),
                              itemCount: exitPoll!.length,
                              itemBuilder: (BuildContext context, int index) {
                                var pollItem = exitPoll[index];

                                return Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  margin: EdgeInsets.all(8.0),
                                  elevation: 5.0,
                                  shadowColor: Colors.black.withOpacity(0.2),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${pollItem.number}',
                                                  style: GoogleFonts.prompt(
                                                      fontSize: 25.0,color: Colors.green[800]),
                                                ),
                                                SizedBox(width: 15.0,),
                                                Text(
                                                  pollItem.displayName,
                                                  style: GoogleFonts.prompt(
                                                      fontSize: 20.0),
                                                ),
                                                Text(
                                                  '${pollItem.score}',
                                                  style: GoogleFonts.prompt(
                                                      fontSize: 20.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('ผิดพลาด: ${snapshot.error}'),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _futureExitPoll = _loadPoll();
                                      });
                                    },
                                    child: Text('ลองใหม่')),
                              ],
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<PollItem>> _loadPoll() async {
    List list = await Api().fetch('exit_poll/result');
    var exitPoll = list.map((item) => PollItem.fromJson(item)).toList();
    return exitPoll;
  }
}
