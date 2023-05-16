import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Components/textfield.dart';
import '../../Controllers/StockTransferController/stockTransferController.dart';
import '../../Theme/colors.dart';
import '../../Theme/style.dart';

class SearchStockProducts extends StatefulWidget {
  const SearchStockProducts({Key? key}) : super(key: key);

  @override
  State<SearchStockProducts> createState() => _SearchStockProductsState();
}

class _SearchStockProductsState extends State<SearchStockProducts> {
  StockTransferController stockTranCtrlObj =
      Get.find<StockTransferController>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
          padding:
              EdgeInsetsDirectional.only(top: 5, bottom: 5, start: 10, end: 10),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                bottom: 5,
              ),
              padding: EdgeInsets.symmetric(horizontal: 5),
              color: index.isEven ? kWhiteColor : primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AppFormField(
                          controller: stockTranCtrlObj.productNameCtrl,
                          padding: EdgeInsets.only(right: 10),
                          isOutlineBorder: false,
                          isColor:
                              index.isEven ? kWhiteColor : Colors.transparent,
                          // labelText: 'Product Name',
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppFormField(
                          controller: stockTranCtrlObj.qtyCtrl,
                          padding: EdgeInsets.only(right: 5),
                          isOutlineBorder: false,
                          isColor:
                              index.isEven ? kWhiteColor : Colors.transparent,
                          // labelText: 'Qty',
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppFormField(
                          controller: stockTranCtrlObj.priceCtrl,
                          padding: EdgeInsets.only(right: 5),
                          isOutlineBorder: false,
                          isColor:
                              index.isEven ? kWhiteColor : Colors.transparent,
                          // labelText: 'Price',
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppFormField(
                          controller: stockTranCtrlObj.totalCtrl,
                          padding: EdgeInsets.only(right: 5),
                          isOutlineBorder: false,
                          isColor:
                              index.isEven ? kWhiteColor : Colors.transparent,
                          // labelText: '1',
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AppFormField(
                          controller: stockTranCtrlObj.remarksCtrl,
                          padding: EdgeInsets.only(right: 10),
                          labelText: 'Remarks',
                          isOutlineBorder: false,
                          isColor:
                              index.isEven ? kWhiteColor : Colors.transparent,
                        ),
                      ),
                      Icon(
                        Icons.cancel_outlined,
                        color: buttonColor,
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Divider(
                  //
                  // ),
                ],
              ),
            );
          }),
    );
  }

  Text headings({required String txt}) {
    return Text(
      txt,
      style: appBarHeaderStyle,
    );
  }
}
