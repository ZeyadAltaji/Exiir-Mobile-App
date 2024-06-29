import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataView(
      {Key? key, required this.statusRequest, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Center(
            child:
                Lottie.asset(AppimageUrlAsset.loading, width: 250, height: 250))
        : statusRequest == StatusRequest.offlinefailure
            ? Center(
                child: Lottie.asset(AppimageUrlAsset.offline,
                    width: 250, height: 250))
            : statusRequest == StatusRequest.serverfailure
                ? Center(
                    child: Lottie.asset(AppimageUrlAsset.server,
                        width: 250, height: 250))
                : statusRequest == StatusRequest.failure
                    ? Center(
                        child: Lottie.asset(AppimageUrlAsset.noData,
                            width: 250, height: 250, repeat: true))
                    : widget;
  }
}

class HandlingDataRequest extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataRequest(
      {Key? key, required this.statusRequest, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Center(
            child:
                Lottie.asset(AppimageUrlAsset.loading, width: 250, height: 250))
        : statusRequest == StatusRequest.offlinefailure
            ? Center(
                child: Lottie.asset(AppimageUrlAsset.offline,
                    width: 250, height: 250))
            : statusRequest == StatusRequest.serverfailure
                ? Center(
                    child: Lottie.asset(AppimageUrlAsset.server,
                        width: 250, height: 250))
                : widget;
  }
}
