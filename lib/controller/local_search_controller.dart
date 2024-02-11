// ignore_for_file: public_member_api_docs, eol_at_end_of_file, unused_local_variable, require_trailing_commas

import 'package:flutter/foundation.dart';
import 'package:local_search/model/service_agreement_mask.dart';

class LocalSearchController {
  Future<List<ServiceAgreementMask>> fetchDataHigher90k(
      List<ServiceAgreementMask> items) async {
    final response = await compute(
      _LocalSearch.fetchZipCodeHigher,
      SearchZipModel(items, 94122),
    );
    return response;
  }

  List<ServiceAgreementMask> agreementFullSearch(
      List<ServiceAgreementMask> items, String key) {
    return items.where((element) => element.toString().contains(key)).toList();
  }
}

class SearchZipModel {
  SearchZipModel(this.items, this.maximumValue);

  final List<ServiceAgreementMask> items;
  final int maximumValue;
}

class _LocalSearch {
  static List<ServiceAgreementMask> fetchZipCodeHigher(
    SearchZipModel model,
  ) {
    final response = model.items
        .where((element) => element.agreement == ServiceAgreements.passive)
        .where((element) => element.zipCode > 0)
        .where(
          (element) => element.zipCode > model.maximumValue,
        )
        .toList();

    return response;
  }
}
