


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class dropDown extends StatelessWidget {

  dropDown({Key? key,

    required this.selectText,
    required this.sendValue,
    required this.viewValue,
    required this.selectedValue,
    required this.allItem,
    required this.onChanged,
  }) : super(key: key);


  var selectText;
  var sendValue;
  var viewValue;
  var selectedValue;
  var allItem = [];
  ValueChanged onChanged;



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xffC5C5C5),
          width: 0.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Text('$selectText',style: TextStyle(fontSize: 12,),),
          iconStyleData: IconStyleData(
            icon: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.keyboard_arrow_down),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            elevation: 1,
            maxHeight: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[50],
            ),
          ),
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 30,
          ),
          items: allItem.map((item) {
            return DropdownMenuItem(
              value: item['$sendValue'],
              child: Container(width: MediaQuery.of(context).size.width/2,child: Text('${item['$viewValue']}',style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
            );
          }).toList(),
          onChanged: onChanged,
          value:  selectedValue,
        ),
      ),
    );
  }
}


/* How to Call this Dynamic Dropdown

  var blockDropdownValue;
  var villageItems=[
    {
      "blockKey": 7,
      "blockName": "Fatehpur Sikri",
      "districtKey": 1
    },
    {
      "blockKey": 8,
      "blockName": "Jagner",
      "districtKey": 1
    },
  ];

  dropDown(selectText: 'Select Village', sendValue: 'blockKey', viewValue: 'blockName', selectedValue: blockDropdownValue, allItem: villageItems,
    onChanged: (value){
      setState(() {
        blockDropdownValue = value!;
        debugPrint('vvvvvvvvvvvvvvvvvvvv$blockDropdownValue');
      });
    },
  ),

*/
