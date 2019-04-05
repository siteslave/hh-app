import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_sparkline/flutter_sparkline.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  static var barchartData = [
    new BarChartData('ม.ค', 5),
    new BarChartData('ก.พ', 25),
    new BarChartData('มี.ค', 100),
    new BarChartData('เม.ย', 75),
  ];

  List<charts.Series<BarChartData, String>> seriesList = [
    new charts.Series<BarChartData, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarChartData sales, _) => sales.year,
        measureFn: (BarChartData sales, _) => sales.total,
        data: barchartData,
        labelAccessorFn: (BarChartData sales, _) => '${sales.total.toString()}')
  ];

  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            child: new charts.BarChart(
              seriesList,
              animate: true,
              vertical: false,
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
            ),
          ),
          Container(
            height: 300,
            child: new charts.PieChart(seriesList,
                animate: true,
                defaultRenderer: new charts.ArcRendererConfig(
                    arcRendererDecorators: [
                      new charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.outside)
                    ])),
          ),
          new Container(
//        width: 300.0,
            height: 100.0,
            child: new Sparkline(
              lineColor: Colors.green[900],
              lineWidth: 5,
              data: data,
              fillMode: FillMode.below,
              fillGradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green[500], Colors.green[100]],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BarChartData {
  final String year;
  final int total;

  BarChartData(this.year, this.total);
}
