import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/features/home/models/scripture_list.dart';

class ScriptureSection extends HookWidget {
  const ScriptureSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal! * 8,
      ),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.safeBlockVertical! * 2,
          ),
          const GetScripture(),
        ],
      ),
    );
  }
}
