import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FilterOptionsContainer extends StatefulWidget {
  const FilterOptionsContainer(
      {super.key,
      required this.optionChoice,
      required this.deviceWidth,
      required this.deviceHeight});
  final Function optionChoice;
  final double deviceWidth, deviceHeight;

  @override
  State<FilterOptionsContainer> createState() => _FilterOptionsContainerState();
}

class _FilterOptionsContainerState extends State<FilterOptionsContainer> {
  int? modeActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: widget.deviceWidth * 0.62,
          height: widget.deviceHeight * 0.04,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 1, color: Colors.black),
            color: Color.fromRGBO(94, 166, 61, 0.42),
          ),
        ),
        Container(
          width: widget.deviceWidth * 0.62,
          height: widget.deviceHeight * 0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    backgroundColor: modeActive == 0
                        ? Color.fromRGBO(75, 158, 37, 0.774)
                        : Colors.transparent,
                  ),
                  onPressed: () {
                    widget.optionChoice("chart_option_month".tr());
                    setState(() {
                      modeActive = 0;
                    });
                  },
                  child: Text(
                    "chart_option_month".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                height: widget.deviceHeight * 0.04,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    backgroundColor: modeActive == 1
                        ? Color.fromRGBO(75, 158, 37, 0.774)
                        : Colors.transparent,
                  ),
                  onPressed: () {
                    widget.optionChoice("chart_option_year".tr());
                    setState(() {
                      modeActive = 1;
                    });
                  },
                  child: Text(
                    "chart_option_year".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                height: widget.deviceHeight * 0.04,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    backgroundColor: modeActive == 2
                        ? Color.fromRGBO(75, 158, 37, 0.774)
                        : Colors.transparent,
                  ),
                  onPressed: () {
                    widget.optionChoice("chart_option_range".tr());
                    setState(() {
                      modeActive = 2;
                    });
                  },
                  child: Text(
                    "chart_option_range".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
