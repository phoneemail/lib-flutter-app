import 'package:flutter/material.dart';
import 'package:phone_email_auth/phone_email_auth.dart';

class EmailAlertButton extends StatefulWidget {
  /// Total email count show in top of button
  final String jwtToken;

  /// Button Icon
  final Widget? buttonIcon;

  /// Email count text style
  final TextStyle? countTextStyle;

  /// Email count text background color
  final Color? textBackgroundColor;

  /// Email button background color
  final Color? buttonBackground;

  /// Email button padding to icon
  final double? buttonPadding;

  EmailAlertButton({
    Key? key,
    required this.jwtToken,
    this.buttonIcon,
    this.buttonPadding,
    this.countTextStyle,
    this.textBackgroundColor,
    this.buttonBackground,
  }) : assert(jwtToken.isNotEmpty);

  @override
  State<EmailAlertButton> createState() => _EmailAlertButtonState();
}

class _EmailAlertButtonState extends State<EmailAlertButton> {
  String _emailCount = '0';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) => getEmailCount(),
    );
  }

  @override
  void didUpdateWidget(EmailAlertButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Fetch email when last fetch time is more then 3 minutes
    final int? lastFetchTime =
        sharedPreference?.getInt(AppConstant.lastFetchEmailCountTime);
    if (lastFetchTime != null) {
      final lastFetchTimeStamp =
          DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
      if (DateTime.now().difference(lastFetchTimeStamp).inMinutes > 3) {
        getEmailCount();
      } else {
        _emailCount =
            sharedPreference?.getString(AppConstant.totalEmailCount) ?? '0';
        print("Email Count: "+_emailCount);
      }
    }else{
      getEmailCount();
    }
  }

  /// Get email count
  Future<void> getEmailCount() async {
    await PhoneEmail.getEmailCount(
      widget.jwtToken,
      onEmailCount: (count) async {
        setState(() {
          _emailCount = count;
        });
        await sharedPreference?.setInt(AppConstant.lastFetchEmailCountTime,
            DateTime.now().millisecondsSinceEpoch);
        await sharedPreference?.setString(AppConstant.totalEmailCount, count);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmailListView(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(widget.buttonPadding ?? 14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              widget.buttonBackground ?? const Color.fromARGB(255, 4, 201, 135),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            widget.buttonIcon ??
                const Icon(
                  Icons.email_rounded,
                  color: Colors.white,
                ),
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 4,
                  top: 1,
                  right: 4,
                  bottom: 1,
                ),
                decoration: BoxDecoration(
                  color: widget.textBackgroundColor ?? Colors.red,
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                child: Text(
                  _emailCount,
                  style: widget.countTextStyle ??
                      const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
