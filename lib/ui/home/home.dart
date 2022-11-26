import 'package:bayt_test_app/provider/filter_provider.dart';

import 'package:bayt_test_app/ui/base_widiget/text_field.dart';

import 'package:bayt_test_app/ui/home/components/filter_sheet.dart';
import 'package:bayt_test_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ByatTextField(
            controller: context.read<FilterProvider>().searchController,
            focusNode: context.read<FilterProvider>().searchFocusNode,
            showBorder: false,
            suffixIcon:
                const Icon(Icons.search, size: 26, color: ByatColors.white)),
        actions: [
          IconButton(
              onPressed: () => showModalBottomSheet(
                  context: context, builder: (_) => const FilterSheet()),
              icon: Icon(Icons.filter_alt))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_travel), label: 'Checkout'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child:
                    Consumer<FilterProvider>(builder: (context, filter, child) {
                  return ListView.separated(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: filter.duplicatedData.length,
                      separatorBuilder: (_, index) => const Divider(),
                      itemBuilder: (_, index) {
                        final date = DateFormat.yMMMd()
                            .format(filter.duplicatedData[index].date);
                        return ListTile(
                          title: Text(filter.duplicatedData[index].name),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Date: $date'),
                              const SizedBox(width: 8),
                              Text(
                                  'Nationality: ${filter.duplicatedData[index].nationality}'),
                            ],
                          ),
                        );
                      });
                }),
              ),
            ],
          ),
          Consumer<FilterProvider>(builder: (context, filter, child) {
            if (filter.searchFocusNode.hasFocus &&
                filter.searchedHistory.isNotEmpty) {
              return Positioned(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Color(0xFFE9E8E8)),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: context
                          .watch<FilterProvider>()
                          .searchedHistory
                          .map((e) => CustomBadge(
                                title: e,
                                onTap: () => context
                                    .read<FilterProvider>()
                                    .onSavedHistoryTap(e),
                              ))
                          .toList(),
                    ),
                    const Divider(),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: CustomBadge(
                          title: 'Clear history',
                          onTap:
                              context.read<FilterProvider>().clearSearchHistory,
                          backgroundColor: ByatColors.ligtGrey,
                          titleColor: ByatColors.black,
                        )),
                  ],
                ),
              ));
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }
}

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    Key? key,
    this.onTap,
    required this.title,
    this.backgroundColor = ByatColors.primary,
    this.titleColor = ByatColors.white,
  }) : super(key: key);
  final VoidCallback? onTap;
  final String title;
  final Color? backgroundColor;
  final Color? titleColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
      ),
    );
  }
}
