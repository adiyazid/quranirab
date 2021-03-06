import 'package:flutter/material.dart';

button115(String text, Color color, String icon, double radius, Function _callback, bool enable){
  return Stack(
    children: <Widget>[

      Container(
          height: 50,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Stack(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Container(
                            height: 40,
                            width: 40,
                            child: Image.asset(icon,
                              fit: BoxFit.contain,
                            ))
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white), textAlign: TextAlign.center,),
                    ),

                  ],
                ),
                if (enable)
                  Positioned.fill(
                    child: Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius)),
                        child: InkWell(
                          splashColor: Colors.black.withOpacity(0.2),
                          onTap: (){
                            _callback();
                          }, // needed
                        )),
                  )

              ])
      ),

    ],
  );
}


button115a(String text, TextStyle _style, Color color, String icon, double radius, Function _callback, bool enable){
  return FittedBox(child: Stack(
    children: <Widget>[
      Container(
          height: 50,
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Container(
                            height: 40,
                            width: 40,
                            child: Image.asset(icon,
                              fit: BoxFit.contain,
                            ))
                    ),
                    SizedBox(width: 5,),
                    Text(text, style: _style, textAlign: TextAlign.center,),
                    SizedBox(width: 15,),
                  ],
                )),
                if (enable)
                  Positioned.fill(
                    child: Container(
                      child: Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius)),
                        child: InkWell(
                          splashColor: Colors.black.withOpacity(0.2),
                          onTap: (){
                            _callback();
                          }, // needed
                        ))),
                  )

              ])
      ),

    ],
  ));
}
