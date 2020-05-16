import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/stamp_detail_components/stamp_details_card_component.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_details_constructure.dart';

class StampDetailScreen extends StatelessWidget {
  final StampIdInfomation stampIdInfomation;
  final PsmAtStampUser psmAtStampUser;
  const StampDetailScreen({
    Key key,
    @required this.stampIdInfomation,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(90, 90, 90, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1),
        title: Row(
          children: <Widget>[
            stampIdInfomation.categoriesIconUrl != null
                ? FadeInImage.assetNetwork(
                    imageScale: 16,
                    placeholderScale: 16,
                    fadeInCurve: Curves.decelerate,
                    fadeOutCurve: Curves.decelerate,
                    placeholder: "assets/images/icons/icon_gray.png",
                    image: stampIdInfomation.categoriesIconUrl,
                  )
                : Image.asset(
                    "assets/images/icons/icon_gray.png",
                    scale: 16,
                  ),
            Flexible(
              child: Text(
                stampIdInfomation.categories,
                style: TextStyle(
                  fontFamily: "Sukhumwit",
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      body: StampDetailCardComponent(
        psmAtStampUser: psmAtStampUser,
        stampIdInfomation: stampIdInfomation,
      ),
    );
  }
}
