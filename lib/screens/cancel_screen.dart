import 'package:flutter/material.dart';

class CancelScreen extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CancelScreen({super.key, this.onConfirm, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Text(
                  'CANCEL CONFIRMATION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Main Question
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'ARE YOU SURE YOU\nWANT TO CANCEL\nTHIS?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              // Action Buttons
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    // NO Button (Blue)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue.shade300, Colors.blue.shade700],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (onCancel != null) {
                                onCancel!();
                              } else {
                                Navigator.pop(context, false);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              child: Text(
                                'NO',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // YES Button (Red)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 6, right: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.red.shade300, Colors.red.shade700],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (onConfirm != null) {
                                onConfirm!();
                              } else {
                                Navigator.pop(context, true);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              child: Text(
                                'YES',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
