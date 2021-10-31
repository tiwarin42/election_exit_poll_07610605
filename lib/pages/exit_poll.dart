import 'package:election_exit_poll_07610605/models/poll_item.dart';
import 'package:election_exit_poll_07610605/pages/result.dart';
import 'package:election_exit_poll_07610605/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExitPoll extends StatefulWidget {
  static const routeName = '/exit_poll';

  const ExitPoll({Key? key}) : super(key: key);

  @override
  _ExitPollState createState() => _ExitPollState();
}

class _ExitPollState extends State<ExitPoll> {
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
                                onTap: () => _handleClickFoodItem(pollItem.number),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.pushNamed(
                        context,
                        ResultPage.routeName,
                      );
                    }, child: Text(
                      'ดูผล',
                      style: GoogleFonts.prompt(fontSize: 20.0,color: Colors.white),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<PollItem>> _loadPoll() async {
    List list = await Api().fetch('exit_poll');
    var exitPoll = list.map((item) => PollItem.fromJson(item)).toList();
    return exitPoll;
  }


  _handleClickFoodItem(int candidateNumber) async {
    var score = (await Api().submit('exit_poll',{'candidateNumber': candidateNumber}));
    return _showMaterialDialog('SUCCESS', score.toString());
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
