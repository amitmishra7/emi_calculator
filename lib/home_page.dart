import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _loanAmountController = TextEditingController();
  TextEditingController _interestRateController = TextEditingController();
  TextEditingController _tenureController = TextEditingController();

  num totalInterest = 0;
  num emi = 0;
  num totalAmountToPay = 0;
  bool isYearSelected = true;

  @override
  void initState() {
    setState(() {
      _loanAmountController.text = "100000";
      _interestRateController.text = "10";
      _tenureController.text = "10";
    });
    _calculateInterest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitleText('Loan Amount'),
              _buildTextField(
                  controller: _loanAmountController,
                  trailingWidget1: _buildRupeeIcon()),
              _buildTitleText('Interest Rate'),
              _buildTextField(
                  controller: _interestRateController,
                  trailingWidget1: _buildInterestIcon()),
              _buildTitleText('Loan Tenure'),
              _buildTextField(
                  controller: _tenureController,
                  trailingWidget1: _buildYearIcon(),
                  trailingWidget2: _buildMonthIcon()),
              _buildResult(),
            ],
          ),
        ),
      ),
    );
  }

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
        child: Column(
          children: [
            _buildValueText('Loan EMI', ' ${emi.toStringAsFixed(0)}'),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            _buildValueText('Total Interest Payable',
                ' ${totalInterest.toStringAsFixed(0)}'),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            _buildValueText('Total Paymnent\n(Principal + Interest)',
                ' ${totalAmountToPay.toStringAsFixed(0)}'),
          ],
        ),
      ),
    );
  }

  _buildTitleText(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Text(
        text,
        style: GoogleFonts.nunitoSans(
          textStyle: TextStyle(
            fontSize: 25,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  _buildValueText(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 12.5,bottom: 12.5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '\u{20B9} $value',
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 35,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTextField(
      {TextEditingController controller,
      Widget trailingWidget1,
      Widget trailingWidget2}) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Theme(
        data: new ThemeData(
          primaryColor: Colors.grey,
          primaryColorDark: Colors.grey,
        ),
        child: Container(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (text){
                    _calculateInterest();
                  },
                  controller: controller,
                  style: TextStyle(fontSize: 25),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              trailingWidget1,
              trailingWidget2 != null ? trailingWidget2 : Container(),
            ],
          ),
        ),
      ),
    );
  }

  _buildRupeeIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        border: Border.all(color: Colors.blueGrey, width: 1),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
      ),
      child: Center(
        child: Text(
          '\u{20B9}',
          style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  _buildInterestIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        border: Border.all(color: Colors.blueGrey, width: 1),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
      ),
      child: Center(
        child: Text(
          '%',
          style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  _buildYearIcon() {
    return InkWell(
      onTap: () {
        if (!isYearSelected) {
          setState(() {
            isYearSelected = true;
            _calculateInterest();
          });
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: !isYearSelected ? Colors.white : Colors.blueGrey.shade100,
          border: Border.all(color: Colors.blueGrey, width: 1),
        ),
        child: Center(
          child: Text(
            'Yr',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildMonthIcon() {
    return InkWell(
      onTap: () {
        if (isYearSelected) {
          setState(() {
            isYearSelected = false;
            _calculateInterest();
          });
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isYearSelected ? Colors.white : Colors.blueGrey.shade100,
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          ),
        ),
        child: Center(
          child: Text(
            'Mo',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _calculateInterest() {
    var P = num.parse(_loanAmountController.text.isNotEmpty
        ? _loanAmountController.text
        : '0');
    var N = num.parse(
        _tenureController.text.isNotEmpty ? _tenureController.text : '0');
    var R = num.parse(_interestRateController.text.isNotEmpty
        ? _interestRateController.text
        : '0');

    setState(() {
      emi = emiCalculator(P, R, N);

      if (isYearSelected) {
        totalAmountToPay = emi * N * 12;
      } else {
        totalAmountToPay = emi * N;
      }

      totalInterest = totalAmountToPay - P;
    });
  }

  num emiCalculator(num p, num r, num t) {
    num emi;
    if (isYearSelected) {
      r = r / (12 * 100); // one month interest
      t = t * 12; // one month period
    } else {
      r = r / (12 * 100); // one month interest
      t = t * 1; // one month period
    }
    emi = (p * r * pow(1 + r, t)) / (pow(1 + r, t) - 1);

    return (emi);
  }
}
