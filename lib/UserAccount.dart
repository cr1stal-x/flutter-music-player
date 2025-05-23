import 'package:fintest/login.dart';
import 'package:flutter/material.dart';

class UserAccount extends StatefulWidget {
  UserAccount({Key? test}) : super(key: test);

  @override
  State<UserAccount> createState() => _UserAccount();
}

class _UserAccount extends State<UserAccount> {
  List<String> Tem = ["default", "pink", "orange", "blue"];
  String currentTenTem = "default";

  Map<String, dynamic> person = {
    "name": "Sara",
    "username": "Saytania",
    "password": "1234",
    "e-mail": "sara.ata.ana@gmail.com",
    "credit": "10.0",
    "isPremium": "normal",
  };

  void edit(String field, String edited) {
    if(field == "username") {
      setState(() {
        person['username'] = edited;
      });
    }
    if (field == "password") {
      setState(() {
        person['password'] = edited;
      });
    }
    else
      return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE4E6),
      appBar: AppBar(
        title: const Text(
          "User Account",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
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
                radius: 100,
                backgroundImage: AssetImage('assets/images/girl.jpg'),
              ),
              SizedBox(height: 10),

              Text(
                person["name"],
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
                    border: Border.all(color: Colors.pink),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Username",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      Text(
                        "${person["username"]}",
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
                          color: Colors.pink,
                        ),
                      ),
                      Text(
                        "${person["e-mail"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          showEditChoiceDialog(context);
                        },
                        child: Text("Edit Info"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                        ),
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
                    border: Border.all(color: Colors.pink),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Credit",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      Text("${person["credit"]}\$",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text(
                        "Subscription",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      Text("${person["isPremium"]}",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              goToPaymentPage("Increase Credit");
                            },
                            child: Text("Increase Credit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showPremiumOptions(context);
                            },
                            child: Text("Buy Premium"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                            ),
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
                            builder: (context) =>
                                //SignUpPage(plan: "Deleted Account"),
                            Login(),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Want to delete account?"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Future.delayed(Duration(seconds: 1), () {
                        //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                            //builder: (context) =>
                                //PaymentPage(plan: "Chat with Admin"),
                          //),
                        //);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
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
                          //builder: (context) => SignUpPage(plan: "Logout"),
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.pink,
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
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showEditInputDialog(context, "username");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
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
                  foregroundColor: Colors.pink,
                  side: const BorderSide(color: Colors.pink),
                ),
                child: const Text("Password"),
              ),
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
              labelText: field == "password" ? "New Password" : "New Username",
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
                    foregroundColor: Colors.pink,
                    side: BorderSide(color: Colors.pink),
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
                    backgroundColor: Colors.pink,
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
                  goToPaymentPage("Monthly Subscription");
                },
                child: Text("Monthly Subscription: 5.0\$"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  goToPaymentPage("3-Month Subscription:");
                },
                child: Text("3-Month Subscription: 10.2\$"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  goToPaymentPage("Yearly Subscription:");
                },
                child: Text("Yearly Subscription: 30.0\$"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void goToPaymentPage(String plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        //builder: (context) => PaymentPage(plan: plan),
        builder: (context) => Login(),
      ),
    );
  }
}