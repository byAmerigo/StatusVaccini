// ignore: must_be_immutable
import 'package:StatusVaccini/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GraphCard extends StatefulWidget {
  String typeinfo = "";
  String labelText = "";
  String iconpath = "";
  Function funTextInformation;
  Function funGetData;

  @override
  GraphCard({
    this.typeinfo,
    this.labelText,
    this.iconpath,
    this.funTextInformation,
    this.funGetData,
    Key key,
  }) : super(key: key);

  _GraphCardState createState() => _GraphCardState();
}

// ignore: must_be_immutable
class _GraphCardState extends State<GraphCard> {
  String _textInformation = "NOT SET INFORMATION";
  bool _readyGraph = false;
  bool _readyTextInformation = false;

  List<FlSpot> data = [];

  @override
  void initState() {
    super.initState();
    //GET INFORMATION
    getTextInformation();
    getInfoData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SVConst.radiusComponent),
      ),
      borderOnForeground: false,
      semanticContainer: false,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {},
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                children: <Widget>[
                  cardContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool ready() {
    return _readyGraph && _readyTextInformation;
  }

  Column cardContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                height: SVConst.kSizeIcons,
                width: SVConst.kSizeIcons,
                decoration: BoxDecoration(
                  //color: SVConst.iconColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  widget.iconpath,
                  height: SVConst.kSizeIcons,
                  width: SVConst.kSizeIcons,
                ),
              ),
              SizedBox(width: 25),
              Text(
                widget.labelText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        ready() ? futureInformationContent() : waitFutureInformation(),
      ],
    );
  }

  Row futureInformationContent() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: _textInformation + "\n",
                  style: GoogleFonts.roboto(
                    fontSize: 40,
                  ),
                ),
                TextSpan(
                  text: widget.typeinfo,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: drawGraph(),
        ),
      ],
    );
  }

  Column waitFutureInformation() {
    return Column(children: <Widget>[
      SizedBox(height: 40), // ELIA HACK, PER CENTRARE IL CARICAMENTO
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
        ],
      )
    ]);
  }

  void getTextInformation() async {
    await widget
        .funTextInformation()
        .then((value) => _textInformation = value.toString());
    setState(() {
      _readyTextInformation = true;
    });
  }

  AspectRatio drawGraph() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              colors: [SVConst.mainColor],
            )
          ],
        ),
      ),
    );
  }

  void getInfoData() async {
    await widget.funGetData().then((value) => data = value);

    if (data != List.empty())
      setState(() {
        _readyGraph = true;
      });
  }
}
