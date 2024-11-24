import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCardNotify extends StatefulWidget {
  CustomCardNotify(
      {super.key,
      required this.title,
      required this.icon,
      required this.state,
      required this.colorBorder,
      required this.colorIcon,
      required this.notificationController});

  final String title;
  final IconData icon;
  final Color colorIcon;
  final String state;
  final Color colorBorder;
  final TextEditingController notificationController;
  @override
  State<CustomCardNotify> createState() => _CustomCardNotifyState();
}

class _CustomCardNotifyState extends State<CustomCardNotify> {
  // final TextEditingController _notificationController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: 360,
          height: 190,
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
            color: widget.colorBorder, width: 8),
            right: BorderSide(
            color: widget.colorBorder, width: 2),
            top: BorderSide(
            color: widget.colorBorder, width: 2),
            bottom: BorderSide(
            color: widget.colorBorder, width: 2),
          )
      ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.icon, color: widget.colorIcon, size: 24),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      )),
                  Text(widget.state,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      )),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    width: 230,
                    child: TextFormField(
                      controller: widget.notificationController,
                      maxLines: 5, // Permite múltiples líneas
                      decoration: InputDecoration(
                        hintText: '(Escriba aquí su mensaje)',
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 24),
                onPressed: () {
                  setState(() {
                    widget.notificationController.clear();
                  });
                },
              ),
            ],
          ),
        ),

        //seleccion de notificacion
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
