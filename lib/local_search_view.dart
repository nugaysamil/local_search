// ignore_for_file: unused_local_variable, public_member_api_docs, unnecessary_null_comparison, require_trailing_commas, inference_failure_on_instance_creation, invalid_use_of_protected_member, unused_element

import 'package:flutter/material.dart';
import 'package:local_search/cancable/cancelable.dart';
import 'package:local_search/const/json_items.dart';
import 'package:local_search/controller/local_search_controller.dart';
import 'package:local_search/mixin/asset_reader_mixin.dart';
import 'package:local_search/model/service_agreement_mask.dart';
import 'package:local_search/model/services.dart';
import 'package:lottie/lottie.dart';

class LocalSearchView extends StatefulWidget {
  const LocalSearchView({super.key});

  @override
  State<LocalSearchView> createState() => _LocalSearchViewState();
}

class _LocalSearchViewState extends State<LocalSearchView> with AssertMixin {
  Services? services;
  late final LocalSearchController _localSearchController;
  List<ServiceAgreementMask>? get _agreementMasks =>
      services?.payload?.serviceAgreementMask;

  late final CancelableCustomOperation<String> cancelableCustomOperation;
  List<ServiceAgreementMask> rootList = [];

  @override
  void initState() {
    super.initState();
    _localSearchController = LocalSearchController();
    cancelableCustomOperation = CancelableCustomOperation((value) {
      print(value);
      setState(() {
        searchByKey(value);
      });
    });
  }

  final _localTextBigger = 'Show Bigger Zip';

  Future<void> load() async {
    final data = await readData(JsonItems.largeJsonPath);
    if (data == null) return;
    setState(() {
      services = Services.fromJson(data);
    });
    rootList = services?.payload?.serviceAgreementMask?.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: load,
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(
        title: Text(services?.header?.verb ?? ''),
        actions: [
          LottieBuilder.network(
            LottieItems.loading(),
          ),
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: PopupMenuItem(
                child: Text(_localTextBigger),
                onTap: () => search(),
              )),
            ];
          })
        ],
      ),
      body: _agreementMasks != null
          ? Column(
              children: [
                TextField(
                  onChanged: cancelableCustomOperation.onItemChanged,
                ),
                Expanded(
                  child: _AgreementListView(
                    items: _agreementMasks!,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

class _AgreementListView extends StatelessWidget {
  const _AgreementListView({
    super.key,
    required this.items,
  });

  final List<ServiceAgreementMask>? items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items!.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(
              items?[index].city ?? '',
            ),
            leading: Text('$index'),
            trailing: Text(
              items?[index].zip ?? '',
            ),
          ),
        );
      },
    );
  }
}

extension _LocalSearchHigher on _LocalSearchViewState {
  Future<void> search() async {
    final items = services?.payload?.serviceAgreementMask;
    if (items == null) return;
    final response = await _localSearchController.fetchDataHigher90k(items);

    setState(() {
      services?.payload?.serviceAgreementMask = response;
    });
  }

  void searchByKey(String key) {
    final items = services?.payload?.serviceAgreementMask;
    if (items == null) return;
    final response = _localSearchController.agreementFullSearch(rootList, key);

    setState(() {
      services?.payload?.serviceAgreementMask = response;
    });
  }
}

class LottieItems {
  static String loading() {
    return 'https://lottie.host/65b07874-6734-43dc-aedd-7175c8da570e/RLizlJpXlE.json';
  }
}
