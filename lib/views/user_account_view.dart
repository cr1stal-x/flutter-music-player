import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musix/Auth.dart';
import 'package:musix/testClient.dart';
import 'package:musix/views/admin_chat.dart';
import 'package:musix/views/payment_view.dart';
import 'package:musix/views/profile_changer.dart';
import 'package:musix/views/sign_up_view.dart';
import 'package:provider/provider.dart';
import 'login_view.dart';

class UserAccount extends StatefulWidget {


  UserAccount({Key? test}) : super(key: test);

  @override
  State<UserAccount> createState() => _UserAccount();
}

class _UserAccount extends State<UserAccount> {
  


  void edit(String field, String edited) async {
    final client = Provider.of<CommandClient>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final response = await client.sendCommand(
      'Update',
      extraData: {field: edited},
    );

    if (response['status-code'] == 200) {
      auth.updateField(field, edited);
    } else {
      print("Update failed: ${response['message']}");
    }
  }


  Uint8List? decodeBase64ImageSafely(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      print("Base64 string is null or empty");
      return null;
    }

    try {
      String normalized = base64.normalize(base64String);

      print("Normalized base64 length: ${normalized.length}");

      Uint8List bytes = base64Decode(normalized);

      print("Decoded bytes length: ${bytes.length}");

      return bytes;
    } catch (e, stacktrace) {
      print("Error decoding base64 image: $e");
      print(stacktrace);
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();
    Uint8List? profileImageBytes = decodeBase64ImageSafely(authProvider.profileCover);
    TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title:  Text(
          "User Account",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 120,
                backgroundImage: profileImageBytes != null
                    ? MemoryImage(profileImageBytes)
                    : AssetImage('assets/images/girl.jpg') as ImageProvider,
              ),
              SizedBox(height: 10),

              Text(
                authProvider.username ?? 'User',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.secondary),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Username",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        "${authProvider.username ?? 'User'}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "E-mail",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        authProvider.email??"no email found.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        "Credit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        "${authProvider.credit ?? '0.0'}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        "VIP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        (authProvider.isVip??false?"Active":"Diactive"),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          showEditChoiceDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Edit Info"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.secondary),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Credit",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      /*
                      Text("${person["credit"]}\$",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),

                       */
                      Text(
                        "Subscription",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      /*
                      Text("${person["isPremium"]}",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 12),

                       */
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  backgroundColor: Colors.white70,
                                  title: Text("Enter amount of increasing",textAlign: TextAlign.center,),
                                  content: TextField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText:"amount",
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Theme.of(context).colorScheme.secondary,
                                            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                          ),
                                          child: Text("Cancel"),
                                        ),
                                        SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            String newValue = controller.text.trim();
                                            if(newValue.isNotEmpty) {
                                              try {
                                                int parsedInt = int.parse(newValue);
                                                Navigator.pop(context);
                                                goToPaymentView(parsedInt);
                                              } on FormatException catch (e) {
                                                print("Error parsing string: $e");
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.secondary,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text("ok"),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Increase Credit"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showPremiumOptions(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Buy Premium"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Account deleted successfully")),
                      );
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpView(),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Want to delete account?"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Future.delayed(Duration(seconds: 1), () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              ChatPage(),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Chat with admin"),
                  ),
                  SizedBox(height: 30),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showEditChoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          title: const Text(
            "Which field do you want to edit?",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showEditInputDialog(context, "username");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Username"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showEditInputDialog(context, "password");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                child: const Text("Password"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showEditInputDialog(context, "email");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                child: const Text("e=Email"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileCoverPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                child: const Text("Profile Cover"),
              ),
              const SizedBox(width: 20),
            ],
          ),
        );
      },
    );
  }

  void showEditInputDialog(BuildContext context, String field) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          title: Text("Enter new $field"),
          content: TextField(
            controller: controller,
            obscureText: field == "password",
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText:"New",
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                  child: Text("Cancel"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    String newValue = controller.text.trim();
                    if(newValue.isNotEmpty) {
                      edit(field, newValue);
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$field edited!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showPremiumOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          title: const Text(
            "Choose a Subscription Plan",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  activateVip(true,5);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text("Monthly Subscription: 5.0\$"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  activateVip(true,10);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  foregroundColor: Colors.white,
                ),
                child: Text("3-Month Subscription: 10\$"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  activateVip(true,30);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text("Yearly Subscription: 30\$"),
              ),
            ],
          ),
        );
      },
    );
  }

  void goToPaymentView(int pay) {
    Navigator.push(
      context,
      MaterialPageRoute(
        //builder: (context) => PaymentPage(plan: plan),
        builder: (context) => PaymentView(pay: pay),
      ),
    );
  }
  Future<void> activateVip(bool value, int amount) async {
    final client = Provider.of<CommandClient>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if((auth.credit??0)<amount){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('credit is not enough.')),
      );
    }else{
      double newCredit=(auth.credit??0)-amount;
      final response = await client.sendCommand(
        'Update',
        extraData: {"isVip": value, "credit":newCredit},
      );

      if (response['status-code'] == 200) {
        auth.updateField("isVip", value);
        auth.updateField("credit", newCredit);
      } else {
        print("Update failed: ${response['message']}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('vip activated.')),
      );
    }

  }

}