import 'dart:convert';

import 'package:bizmodo_emenu/Models/ViewStockTransferModel/statusListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Config/app_config.dart';
import '../../Config/utils.dart';

import '../../Models/NavBarModel.dart';
import '../../Models/ProductsModel/SearchProductModel.dart';
import '../../Models/ViewStockAdjustmentModel/viewStockAdjusmentModel.dart';
import '../../Models/ViewStockTransferModel/viewStockTransferModel.dart';

import '../../Pages/Stocks/ViewStockAdjustment/viewStockAdjustment.dart';
import '../../Pages/Stocks/ViewStockTransfer/viewStockTransfer.dart';
import '../../Services/api_services.dart';
import '../../Services/api_urls.dart';
import '../../Services/storage_services.dart';
import 'package:http/http.dart' as http;

import '../ProductController/all_products_controller.dart';

enum OrderTabsPage {
  ActiveOrders,
  PastOrders,
}

class StockTransferController extends GetxController {
  String? statusValue;
  String? adjustmentTypeStatus;
  String? locationFromStatusValue;
  String? locationToStatusValue;
  String? locationFromID;
  String? locationToID;
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController searchCtrl = TextEditingController();
  TextEditingController additionalNotes = TextEditingController();
  TextEditingController totalAmountRecCtrl = TextEditingController(text: '0');
  TextEditingController reasonCtrl = TextEditingController();
  TextEditingController productNameCtrl = TextEditingController();
  List<TextEditingController> qtyCtrl = [];
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController totalCtrl = TextEditingController();
  TextEditingController remarksCtrl = TextEditingController();
//stock adjustment controllers
  TextEditingController additionalNotesCtrl = TextEditingController();
  String? statusAdjustmentTypeValue;
  //ending
  int allSaleOrdersPage = 1;
  bool isFirstLoadRunning = true;
  bool hasNextPage = true;
  RxBool isLoadMoreRunning = false.obs;

  static List<NavBarModel> stockTabsList() => [
        NavBarModel(
          identifier: OrderTabsPage.ActiveOrders,
          icon: 'Icons.order',
          label: 'Stock Transfer',
          page: ViewStockTransfer(), //StockTransfer(),
        ),
        NavBarModel(
          identifier: OrderTabsPage.PastOrders,
          icon: 'Icons.order',
          label: 'Stock Adjustment',
          page: ViewStockAdjustment(),
        ),
      ];

  List<String> stockSearchHeader = [
    'Product',
    'Sub Location',
    'Quantity',
    'Unit Price',
    'Subtotal',
    'Remarks',
    'Delete'
  ];

  List<String> stockViewHeader = [
    'Date',
    'Reference No',
    'Location (From)',
    'Location (To)',
    'Status',
    'Shipping Charges',
    'Total Amount',
    'Additional Notes',
    'Action',
  ];

  List<String> getAdjustmentTypeList() {
    List<String> options = ['Normal', 'Abnormal'];
    // for (int i = 0;
    // i < widget.listUserCtrlObj!.listuserModel!.data!.length;
    // i++) {
    //   options.add(
    //       '${widget.listUserCtrlObj?.listuserModel?.data?[i].firstName} ${widget.listUserCtrlObj?.listuserModel?.data?[i].lastName == null ? '' : widget.listUserCtrlObj?.listuserModel?.data?[i].lastName}' ??
    //           '');
    // }
    return options;
  }

  ///function to get Business Locations
  List<String> getBusinessLocationItems() {
    List<String> options = [];
    if (AppStorage.getBusinessDetailsData()?.businessData?.locations != null) {
      for (int i = 0;
          i <
              AppStorage.getBusinessDetailsData()!
                  .businessData!
                  .locations
                  .length;
          i++) {
        options.add(AppStorage.getBusinessDetailsData()
                ?.businessData
                ?.locations[i]
                .name ??
            '');
      }
    } else {
      progressIndicator();
    }
    return options;
  }

  ViewStockTransferModel? viewStockTransferMoodel;

  /// Fetching Stock transfer
  Future fetchStockTransfersList({String? pageUrl}) async {
    await ApiServices.getMethod(feedUrl: pageUrl ?? ApiUrls.viewStockTransfer)
        .then((_res) {
      update();
      if (_res == null) return null;
      viewStockTransferMoodel = viewStockTransferModelFromJson(_res);
      update();
    }).onError((error, stackTrace) {
      debugPrint('Error => $error');
      logger.e('StackTrace => $stackTrace');
      update();
    });
  }

  List<StatusListModel>? statusListModel;

  /// Fetching Status
  Future fetchStatusList({String? pageUrl}) async {
    await ApiServices.getMethod(feedUrl: pageUrl ?? ApiUrls.statusStockTransfer)
        .then((_res) {
      update();
      if (_res == null) return null;
      statusListModel = statusListModelFromJson(_res);
      update();
    }).onError((error, stackTrace) {
      debugPrint('Error => $error');
      logger.e('StackTrace => $stackTrace');
      update();
    });
  }

  // load more order page
  // void loadMoreSaleOrders() async {
  //   logger.wtf('load more sale orders function called!');
  //   if (hasNextPage && !isFirstLoadRunning && !isLoadMoreRunning.value) {
  //     isLoadMoreRunning.value = true;
  //
  //     allSaleOrdersPage += 1;
  //
  //     await fetchSaleOrders(allSaleOrdersPage).then((bool? _isFinished) {
  //       if (_isFinished == null) {
  //         allSaleOrdersPage -= 1;
  //       } else if (_isFinished) {
  //         // This means there is no more data
  //         // and therefore, we will not send another request
  //         hasNextPage = false;
  //       }
  //     });
  //     isLoadMoreRunning.value = false;
  //   }
  // }

  // Future<bool?> fetchSaleOrders(int _page) async {
  //   print('========================================');
  //   print('Function calling');
  //   return await ApiServices.getMethod(
  //           feedUrl: '${ApiUrls.viewStockTransfer}?page=$_page&per_page=20')
  //       .then((_res) {
  //     if (_res == null) return null;
  //     final _data = saleOrderModelFromJson(_res);
  //     if (_page > 1 && allSaleOrders != null) {
  //       allSaleOrders!.saleOrdersData.addAll(_data.saleOrdersData);
  //     } else {
  //       allSaleOrders = _data;
  //     }
  //     update();
  //
  //     /* fallback end status means is all item finished or not */
  //     if (allSaleOrders?.meta?.lastPage != null &&
  //         _page == allSaleOrders?.meta?.lastPage) {
  //       return true;
  //     }
  //
  //     return false;
  //   }).onError((error, stackTrace) {
  //     debugPrint('Error => $error');
  //     logger.e('StackTrace => $stackTrace');
  //     return null;
  //   });
  // }

  // initial order page load function
  // callFirstOrderPage() async {
  //   allSaleOrdersPage = 1;
  //   isFirstLoadRunning = true;
  //   hasNextPage = true;
  //   isLoadMoreRunning.value = false;
  //   await fetchSaleOrders(1);
  //   isFirstLoadRunning = false;
  // }

  createStockTransfer(/*{required bool isCheckout}*/) async {
    AllProductsController allProdCtrlObj = Get.find<AllProductsController>();
    var length = allProdCtrlObj.searchProductModel?.length ?? 0;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AppStorage.getUserToken()?.accessToken}'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('${AppConfig.baseUrl}${ApiUrls.createStockTransferApi}'));

    request.fields['location_id'] = '${locationFromID}';
    request.fields['transaction_date'] = '${dateCtrl.text}';
    request.fields['ref_no'] = '';
    request.fields['status'] = '${statusValue?.toLowerCase() ?? 'pending'}';
    request.fields['transfer_location_id'] = '${locationToID}';

    request.fields['final_total'] = '${allProdCtrlObj.finalTotal}';
    request.fields['shipping_charges'] = '0';
    request.fields['additional_notes'] = '${additionalNotes.text}';

    if (allProdCtrlObj.searchProductModel != null)
      for (int i = 0; i < length; i++) {
        if (allProdCtrlObj.productQuantityCtrl[i].text.isNotEmpty &&
            allProdCtrlObj.productQuantityCtrl[i].text != '0') {
          request.fields['kitchen_id[$i]'] = '1';
          request.fields['product_id[$i]'] =
              '${allProdCtrlObj.searchProductModel?[i].productId}';
          request.fields['variation_id[$i]'] =
              '${allProdCtrlObj.searchProductModel?[i].variationId}';
          request.fields['enable_stock[$i]'] = '1';
          request.fields['quantity[$i]'] =
              '${allProdCtrlObj.productQuantityCtrl[i].text}';
          //   request.fields['base_unit_multiplier[$i]'] = '0';
          // request.fields['product_unit_id[$i]'] = '${allProdCtrlObj.searchProductModel?[i].}';
          // request.fields['sub_unit_id[$i]'] = '51';
          request.fields['unit_price[$i]'] =
              '${allProdCtrlObj.searchProductModel?[i].sellingPrice}';
          //request.fields['price[$i]'] = '${searchProductModel?[i].sellingPrice}';
          request.fields['remarks[$i]'] = '';
        }
      }

    // for (int i = 0; i < 2; i++) {
    //   request.fields['kitchen_id[$i]'] = '1';
    //   request.fields['product_id[$i]'] = '3640';
    //   request.fields['variation_id[$i]'] = '3659';
    //   request.fields['enable_stock[$i]'] = '1';
    //   request.fields['quantity[$i]'] = '1.00';
    //   request.fields['base_unit_multiplier[$i]'] = '1';
    //   request.fields['product_unit_id[$i]'] = '51';
    //   request.fields['sub_unit_id[$i]'] = '51';
    //   request.fields['unit_price[$i]'] = '1.00';
    //   request.fields['price[$i]'] = '100.00';
    //   request.fields['remarks[$i]'] = '';
    // }

    logger.i(request.fields);

    request.headers.addAll(headers);

    return await request.send().then((http.StreamedResponse response) async {
      String result = await response.stream.bytesToString();
      logger.i('EndPoint => ${request.url}'
          '\nStatus Code => ${response.statusCode}'
          '\nResponse => $result');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(' successful');
        stopProgress();
      } else {
        final jd = jsonDecode(result);

        showToast(jd["message"]);

        return null;
      }
    }).onError((error, stackTrace) {
      debugPrint('Error => $error');
      logger.e('StackTrace => $stackTrace');
      return null;
    });
  }

  List<SearchProductModel> searchProductModelFinal = [];
  List<SearchProductModel>? listForStockAdjustment;

  /// Searching Product
  // Future searchProductList({String? pageUrl, String? term}) async {
  //   return await ApiServices.getMethod(
  //           feedUrl: pageUrl ??
  //               '${ApiUrls.searchProductListApi}?location_id${AppStorage.getBusinessDetailsData()?.businessData?.locations.first.id}=&term=${term}')
  //       .then((_res) {
  //     update();
  //     if (_res == null) return null;
  //     searchProductModel = searchProductModelFromJson(_res);
  //     update();
  //     return searchProductModel;
  //   }).onError((error, stackTrace) {
  //     debugPrint('Error => $error');
  //     logger.e('StackTrace => $stackTrace');
  //     function();
  //     update();
  //     return null;
  //   });
  // }

  List<TextEditingController> productNameeCtrl = [];
  AllProductsController allProdCtrlObj = Get.find<AllProductsController>();

  // Future createStockTransfer() async {
  //   Map<String, String> _field = {
  //     'transaction_date': '${dateCtrl.text}',
  //     'ref_no': '',
  //     'status': '${statusValue?.toLowerCase() ?? 'pending'}',
  //     'location_id':
  //         '${AppStorage.getBusinessDetailsData()?.businessData?.locations.first.id ?? AppStorage.getLoggedUserData()?.staffUser.locationId}',
  //     'transfer_location_id': '37',
  //     'final_total': '112',
  //     'shipping_charges': '0',
  //     'additional_notes': '${additionalNotes.text}',
  //     'kitchen_id[0]': '1',
  //     'product_id[0]': '3640',
  //     'variation_id[0]': '3659',
  //     'enable_stock[0]': '1',
  //     'quantity[0]': '1.00',
  //     'base_unit_multiplier[0]': '1',
  //     'product_unit_id[0]': '51',
  //     'sub_unit_id[0]': '51',
  //     'unit_price[0]': '100.00',
  //     'price[0]': '100.00',
  //     'remarks[0]': ''
  //   };
  //
  //   return await ApiServices.postMethod(
  //           feedUrl: ApiUrls.createStockTransferApi, fields: _field)
  //       .then((_res) {
  //     if (_res == null) return null;
  //     stopProgress();
  //     return true;
  //   }).onError((error, stackTrace) {
  //     debugPrint('Error => $error');
  //     logger.e('StackTrace => $stackTrace');
  //     throw '$error';
  //   });
  // }

  ViewStockAdjustmentModel? viewStockAdjustmentModel;

  /// Fetching Stock Adjustment
  Future fetchStockAdjustmentList({String? pageUrl}) async {
    await ApiServices.getMethod(feedUrl: pageUrl ?? ApiUrls.viewStockAdjustment)
        .then((_res) {
      update();
      if (_res == null) return null;
      viewStockAdjustmentModel = viewStockAdjustmentModelFromJson(_res);
      update();
    }).onError((error, stackTrace) {
      debugPrint('Error => $error');
      logger.e('StackTrace => $stackTrace');
      update();
    });
  }

  // Future createStockAdjustment() async {
  //   Map<String, String> _field = {
  //
  //   };
  //
  //   return await ApiServices.postMethod(
  //           feedUrl: ApiUrls.createStockAdjustmentApi, fields: _field)
  //       .then((_res) {
  //     if (_res == null) return null;
  //     stopProgress();
  //     return true;
  //   }).onError((error, stackTrace) {
  //     debugPrint('Error => $error');
  //     logger.e('StackTrace => $stackTrace');
  //     throw '$error';
  //   });
  // }

  createStockAdjustment(/*{required bool isCheckout}*/) async {
    AllProductsController allProdCtrlObj = Get.find<AllProductsController>();
    var length = allProdCtrlObj.searchProductModel?.length ?? 0;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AppStorage.getUserToken()?.accessToken}'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('${AppConfig.baseUrl}${ApiUrls.createStockAdjustmentApi}'));

    request.fields['location_id'] =
        '${AppStorage.getBusinessDetailsData()?.businessData?.locations.first.id ?? AppStorage.getLoggedUserData()?.staffUser.locationId}';
    request.fields['transaction_date'] = '${dateCtrl.text}';
    request.fields['ref_no'] = '';
    request.fields['adjustment_type'] =
        '${adjustmentTypeStatus?.toLowerCase() ?? 'normal'}';
    request.fields['final_total'] = '${allProdCtrlObj.finalTotal}';
    request.fields['total_amount_recovered'] = '${totalAmountRecCtrl.text}';
    request.fields['additional_notes'] = '${reasonCtrl.text}';

    if (allProdCtrlObj.searchProductModel != null)
      for (int i = 0; i < length; i++) {
        if (allProdCtrlObj.productQuantityCtrl[i].text.isNotEmpty &&
            allProdCtrlObj.productQuantityCtrl[i].text != '0') {
          request.fields['kitchen_id[$i]'] = '1';
          request.fields['product_id[$i]'] =
              '${allProdCtrlObj.searchProductModel?[i].productId}';
          request.fields['variation_id[$i]'] =
              '${allProdCtrlObj.searchProductModel?[i].variationId}';
          request.fields['enable_stock[$i]'] = '1';
          request.fields['quantity[$i]'] =
              '${allProdCtrlObj.productQuantityCtrl[i].text}';
          //   request.fields['base_unit_multiplier[$i]'] = '0';
          // request.fields['product_unit_id[$i]'] = '${allProdCtrlObj.searchProductModel?[i].}';
          // request.fields['sub_unit_id[$i]'] = '51';
          request.fields['unit_price[$i]'] =
              '${allProdCtrlObj.searchProductModel?[i].sellingPrice}';
          //request.fields['price[$i]'] = '${searchProductModel?[i].sellingPrice}';
          request.fields['remarks[$i]'] = '';
        }
      }
    logger.i(request.fields);

    request.headers.addAll(headers);

    return await request.send().then((http.StreamedResponse response) async {
      String result = await response.stream.bytesToString();
      logger.i('EndPoint => ${request.url}'
          '\nStatus Code => ${response.statusCode}'
          '\nResponse => $result');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(' successful');
        stopProgress();
      } else {
        final jd = jsonDecode(result);

        showToast(jd["message"]);

        return null;
      }
    }).onError((error, stackTrace) {
      debugPrint('Error => $error');
      logger.e('StackTrace => $stackTrace');
      return null;
    });
  }
}
