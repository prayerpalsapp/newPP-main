import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/utils/credential_textfield.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/features/home/view/home_page_container.dart';
import 'package:prayer_pals/features/user/providers/auth_providers.dart';

class SignUpPage extends HookConsumerWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);
    final _auth = ref.watch(authControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 12,
                ),
                Text(
                  StringConstants.register,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockVertical! * 6,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 6,
                ),
                CredentialTextfield(
                  hintText: StringConstants.username,
                  controller: _usernameController,
                  obscure: false,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 3,
                ),
                CredentialTextfield(
                  hintText: StringConstants.emailAddress,
                  controller: _emailAddressController,
                  obscure: false,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 3,
                ),
                CredentialTextfield(
                  hintText: StringConstants.password,
                  controller: _passwordController,
                  obscure: true,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 12,
                ),
                PPCRoundedButton(
                  title: StringConstants.signUpCaps,
                  buttonRatio: 1,
                  buttonWidthRatio: 1,
                  callback: () {
                    _validateCreation(_auth, context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  iconSize: SizeConfig.safeBlockVertical! * 4,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _validateCreation(AuthController controller, BuildContext context) {
    controller.signUpNewUser(
      username: _usernameController.text,
      emailAddress: _emailAddressController.text,
      password: _passwordController.text,
      callback: (value) {
        if (value == StringConstants.success) {  
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (builder) => const HomePageContainer()),
          );
        } else {
          showPPCDialog(context, StringConstants.oops, value, null);
        }
      },
    );
  }
}
