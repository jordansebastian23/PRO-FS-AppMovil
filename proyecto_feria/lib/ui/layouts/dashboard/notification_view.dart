import 'package:flutter/material.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/widgets/custom_card_notify.dart';
import 'package:proyecto_feria/ui/shared/colors.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
      final TextEditingController _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        centerTitle: true,
        toolbarHeight: 100,
        title: Text('Notificaciones',
        style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold)),
        backgroundColor: CustomColor.background,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCardNotify(
              title: 'Notificación 1',	
              icon: Icons.notifications_active,
              state: 'Activa',
              colorBorder: CustomColor.details,
              colorIcon: CustomColor.details,
              notificationController: _messageController
              ),
              CustomCardNotify(
              title: 'Notificación 1',	
              icon: Icons.notifications_active,
              state: 'Activa',
              colorBorder: CustomColor.buttons,
              colorIcon: CustomColor.buttons,
              notificationController: _messageController),
              CustomCardNotify(
              title: 'Notificación 1',	
              icon: Icons.notifications_active,
              state: 'Activa',
              colorBorder: CustomColor.aditionalImportant,
              colorIcon: CustomColor.aditionalImportant,
              notificationController: _messageController)
            
          ],
        ),
      ),
    );
  }
}