import 'package:flutter/material.dart';
import 'package:proyecto_feria/ui/layouts/tabs/widgets/custom_card_payments.dart';
import 'package:proyecto_feria/ui/views/pending_payment.dart';

class PaymentsPageView extends StatelessWidget {
  const PaymentsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomCardTabs(
            title: 'Pago pendiente',
            subtitle: 'Fecha de vencimiento: 12/12/2021',
            description: 'Monto: \$100.00',
            trailing: 'Pagar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PendingPaymentPage()),
              );
            },
          ),
          SizedBox(height: 1),
          CustomCardTabs(
            title: 'Pago pendiente',
            subtitle: 'Fecha de vencimiento: 12/12/2021',
            description: 'Monto: \$100.00',
            trailing: 'Pagar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PendingPaymentPage()),
              );
            },
          ),
        ],
      ),
      
    );
  }
}
