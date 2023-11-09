import 'package:bizmodo_emenu/Controllers/CRMControllers/CampaignsController/campaignsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AddCampaignWidgets/viewCampaign.dart';
import 'addCampaigns.dart';
import 'allCampaignsTiles.dart';

class AllCampaigns extends StatefulWidget {
  const AllCampaigns({super.key});

  @override
  State<AllCampaigns> createState() => _AllCampaignsState();
}

class _AllCampaignsState extends State<AllCampaigns> {
  ScrollController? compaignsScroll;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaigns'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
          child: Icon(Icons.add),
          backgroundColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.5),
          onPressed: () {
            Get.to(AddCampaigns());
          }),
      body: Stack(
        children: [
          GetBuilder(
            builder: (CampaignsController campaignCtrl) {
              return RefreshIndicator(
                onRefresh: () async {
                  //await crmCtrl.callFirstOrderPage();
                },
                child: Scrollbar(
                  controller: compaignsScroll,
                  child: ListView.builder(
                    controller: compaignsScroll,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return IntrinsicHeight(
                        child: GestureDetector(
                            onTap: () {
                              Get.to(ViewCampaign());
                            },
                            child: AllCampaignsTiles(
                            )),
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
