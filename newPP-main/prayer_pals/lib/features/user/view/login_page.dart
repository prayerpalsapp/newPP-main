import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/push_notifications/message_root_handler.dart';
import 'package:prayer_pals/core/utils/credential_textfield.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/features/user/providers/auth_providers.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'sign_up_page.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Constants.ppcMainGradient,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical! * 8,
                  ),
                  Image.asset(
                    ImagesURLConstants.ppcLogo,
                    fit: BoxFit.contain,
                    height: SizeConfig.safeBlockVertical! * 20,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical! * 8,
                  ),
                  CredentialTextfield(
                    hintText: StringConstants.emailAddress,
                    controller: _emailAddressController,
                    obscure: false,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical! * 4,
                  ),
                  CredentialTextfield(
                    obscure: true,
                    hintText: StringConstants.password,
                    controller: _passwordController,
                  ),
                  _forgotPasswordButton(context, ref),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical! * 3,
                  ),
                  PPCRoundedButton(
                    title: StringConstants.loginCaps,
                    buttonRatio: .9,
                    buttonWidthRatio: 1,
                    callback: () async {
                      _validateSignIn(context, ref);
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical! * 10,
                  ),
                  Column(
                    children: [
                      const Text(
                        StringConstants.newToPrayerPals,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 1,
                      ),
                      PPCRoundedButton(
                        title: StringConstants.createAnAccountCaps,
                        buttonRatio: .9,
                        buttonWidthRatio: 1,
                        callback: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _forgotPasswordButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.safeBlockVertical! * 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () async {
            if (_emailAddressController.text.isNotEmpty) {
              final srvMsg = await ref
                  .read(authControllerProvider)
                  .sendForgotPasswordLink(
                      emailAddress: _emailAddressController.text);
              showPPCDialog(
                  context, StringConstants.almostThere, srvMsg, () {});
            } else {
              showPPCDialog(
                context,
                StringConstants.almostThere,
                StringConstants.pleaseEnterAnEmailAddress,
                null,
              );
            }
          },
          child: const Text(
            StringConstants.forgotPassword,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _validateSignIn(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider).signInUser(
          emailAddress: _emailAddressController.text,
          password: _passwordController.text,
          callback: (value) {
            if (value == StringConstants.success) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (builder) => MessageRootHandler(),
              ));
            } else {
              showPPCDialog(context, StringConstants.oops, value, null);
            }
          },
        );
  }
}
