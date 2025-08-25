import 'package:flutter/material.dart';
import 'package:musix/Auth.dart';
import 'package:musix/views/user_account_view.dart';
import 'package:provider/provider.dart';
import '../view_models/payment_view_model.dart';
import '../testClient.dart';
class PaymentView extends StatelessWidget {
  final double pay;
  const PaymentView({super.key, required this.pay});


  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider=context.read<AuthProvider>();
    final PaymentViewModel vm = PaymentViewModel(userPassword: authProvider.password ?? '1234');
    return ChangeNotifierProvider.value(
        value: vm,
        child: Consumer<PaymentViewModel>(
        builder: (context, vm, _) =>  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(centerTitle: true, title: Text("Payment", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text("Price: ",style: TextStyle(fontSize: 24),),
                  Text('$pay\$', style: TextStyle(fontSize: 24),)
                ]
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: vm.updateCardNumber,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 30,),
                TextField(
                  onChanged: vm.updatePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
                if (vm.errorMessage != null)
                  Text(vm.errorMessage!, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[ElevatedButton(
                    onPressed: () async {
                      vm.processPayment();
                      if (vm.isSuccess) {
                        final client = Provider.of<CommandClient>(context, listen: false);
                        final auth = Provider.of<AuthProvider>(context, listen: false);
                        final newCredit=(auth.credit??0)+pay;
                        final response = await client.sendCommand(
                          'Update',
                          extraData: {"credit": newCredit},
                        );

                        if (response['status-code'] == 200) {
                          auth.updateField("credit", newCredit);
                        } else {
                          print("Update failed: ${response['message']}");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment complete!')),
                        );
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserAccount()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                    SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Center(child: Text('Are you sure?')),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            actions: [
                              Center(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Center(child: Text('Payment Canceled.'))),
                                        );
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserAccount()));
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      child: Text('Yes'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                      child: Text('Back To Payment'),
                                    ),
                                  ],
                                ),
                              )
                            ],
                            backgroundColor: Colors.white.withOpacity(0.8),
                          ),
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                    ),]
                ),
              ],
            ),
          ),
        ),

        ),);
  }
}
