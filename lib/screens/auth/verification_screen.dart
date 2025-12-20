import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/screens/home_screen.dart';
import 'package:khmer_cultur_app/widgets/bg_login_widget.dart';
import 'package:khmer_cultur_app/widgets/code_send_widget.dart';
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late TextEditingController code1;
  late TextEditingController code2;
  late TextEditingController code3;
  late TextEditingController code4;

  late FocusNode focus1;
  late FocusNode focus2;
  late FocusNode focus3;
  late FocusNode focus4;

  @override
  void initState() {
    super.initState();
    code1 = TextEditingController();
    code2 = TextEditingController();
    code3 = TextEditingController();
    code4 = TextEditingController();

    focus1 = FocusNode();
    focus2 = FocusNode();
    focus3 = FocusNode();
    focus4 = FocusNode();

    // Auto-focus the first box when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focus1);
    });
  }

  @override
  void dispose() {
    code1.dispose();
    code2.dispose();
    code3.dispose();
    code4.dispose();

    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.chevron_left, size: 32, color: Colors.grey),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          BgLoginWidget(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24, 110, 24, 16),
                child: Column(
                  children: [
                    Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'We have sent a code to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'example@gmail.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 18,right: 18,left: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Code", style: TextStyle(fontSize: 14)),
                            Text("Resend in 50 sec", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CodeBoxWidget(
                              controller: code1,
                              focusNode: focus1,
                              nextFocus: focus2,
                            ),
                            CodeBoxWidget(
                              controller: code2,
                              focusNode: focus2,
                              nextFocus: focus3,
                              previousFocus: focus1,
                            ),
                            CodeBoxWidget(
                              controller: code3,
                              focusNode: focus3,
                              nextFocus: focus4,
                              previousFocus: focus2,
                            ),
                            CodeBoxWidget(
                              controller: code4,
                              focusNode: focus4,
                              previousFocus: focus3,
                            ),
                          ],
                        ),
                        SizedBox(height: 40,),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              String code = code1.text + code2.text + code3.text + code4.text;
                              if (code.length == 4) {
                                print("Entered code: $code");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Please enter full code")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}