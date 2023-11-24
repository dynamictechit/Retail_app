import 'package:bizmodo_emenu/Controllers/RepairController/JobSheetsControllers/JobSheetController.dart';
import 'package:bizmodo_emenu/Pages/Repair/JobSheet/pendingJobSheetTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PendingJobSheet extends StatelessWidget {
  final String? status;
  const PendingJobSheet({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton.small(
      //     child: Icon(Icons.add),
      //     backgroundColor:
      //     Theme.of(context).colorScheme.primary.withOpacity(0.5),
      //     onPressed: () {
      //       // Get.to(AddJobSheet());
      //     }),
      body: Stack(
        children: [
          GetBuilder(
            builder: (JobSheetController jobSheetCtrl) {
              return RefreshIndicator(
                onRefresh: () async {
                  //await crmCtrl.callFirstOrderPage();
                },
                child: Scrollbar(
                  controller: jobSheetCtrl.jobSheetScrollCtrl,
                  child: ListView.builder(
                    controller: jobSheetCtrl.jobSheetScrollCtrl,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return IntrinsicHeight(
                        child: GestureDetector(
                            onTap: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => AlertDialog(
                              //     //title: title != null ? Text(title) : null,
                              //     contentPadding: const EdgeInsets.symmetric(
                              //         vertical: 15, horizontal: 0),
                              //     content: ViewFollowUp(),
                              //   ),
                              // );
                            },
                            child: PendingJobSheetTile(status: status,)
                        ),
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