import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'colornotifire.dart';


late ColorNotifire notifire;



class Customtextfild2 {

  static Widget textField(controller, txt, name1, clr, textcolor, img, suffixIcon,{required context,String? Function(String?)? validator}) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    print("15 , itextfield.dart , --- img ${img}");
    return Container(
      color: Colors.transparent,
      height: 45,
      child: TextFormField(
        controller: controller,
        obscureText: txt,
        validator: validator,
        style: TextStyle(color: textcolor),
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Image.asset("image/LockIcon.png", scale: 0.8,),
          labelText: name1,
          labelStyle: TextStyle(color: clr),
          suffixIcon: Padding(padding: const EdgeInsets.all(10), child: suffixIcon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: notifire.bordercolore, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff5669FF), width: 1),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
