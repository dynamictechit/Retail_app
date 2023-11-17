import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/CRMControllers/LeadsController/leadsController.dart';
import 'addLifeStage.dart';
import 'allLifeStageTile.dart';


class AllLifeStage extends StatefulWidget {
  const AllLifeStage({super.key});

  @override
  State<AllLifeStage> createState() => _AllLifeStageState();
}

class _AllLifeStageState extends State<AllLifeStage> {
  ScrollController? crmScrollCtrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Life Stage'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
          child: Icon(Icons.add),
          backgroundColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.5),
          onPressed: () {
            Get.to(AddLifeStage(isUpdate: false,));
          }),
      body: Stack(
        children: [
          GetBuilder(
            builder: (LeadsController leadsCtrl) {
              return RefreshIndicator(
                onRefresh: () async {
                  //await crmCtrl.callFirstOrderPage();
                },
                child: Scrollbar(
                  controller: crmScrollCtrl,
                  child: ListView.builder(
                    controller: crmScrollCtrl,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return IntrinsicHeight(
                        child: AllLifeStageTile(),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}