import 'package:flutter/material.dart';

button114(String text, Color color, String icon, double radius, Function _callback, bool enable){
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
                    Expanded(
                      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white), textAlign: TextAlign.center,),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset(icon,
                          fit: BoxFit.contain,
                        ))
                    ),
                    const SizedBox(width: 5,)
                  ],
                ),
                if (enable)
                  Positioned.fill(
                    child: Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius) ),
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
