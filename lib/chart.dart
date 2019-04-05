import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  static var barchartData = [
    new BarChartData('2014', 5),
    new BarChartData('2015', 25),
    new BarChartData('2016', 100),
    new BarChartData('2017', 75),
  ];

  List<charts.Series<BarChartData, String>> seriesList = [
    new charts.Series<BarChartData, String>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (BarChartData sales, _) => sales.year,
      measureFn: (BarChartData sales, _) => sales.total,
      data: barchartData,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            child: new charts.BarChart(
              seriesList,
              animate: true,
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
