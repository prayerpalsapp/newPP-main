import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/group/providers/search_groups_provider.dart';
import 'package:prayer_pals/features/group/view/search_groups_widget.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/utils/constants.dart';

//////////////////////////////////////////////////////////////////////////
//
//     when a user clicks join group, they go here and can search for groups
//     to join. logic for returning the search results is in the application
//     files
//
//////////////////////////////////////////////////////////////////////////

class GroupSearchPage extends HookConsumerWidget {
  GroupSearchPage({Key? key}) : super(key: key);

  final TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchGroupsController = ref.watch(searchGroupControllerProvider);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            StringConstants.joinGroup,
          ),
          centerTitle: true,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical! * 3,
                      ),
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: StringConstants.search,
                        hintStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 3,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.lightBlue,
                        size: SizeConfig.safeBlockHorizontal! * 8,
                      ),
                      onPressed: () {
                        searchGroupsController.notify();
                      },
                    ),
                  ),
                ]),
          ),
          PPCstuff.divider,
          PPCSearchGroupsWidget(searchTerm: _groupNameController.text),
        ]));
  }
}
