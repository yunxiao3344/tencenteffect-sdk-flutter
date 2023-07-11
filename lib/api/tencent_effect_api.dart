import 'dart:io';
import 'dart:typed_data';
import 'package:tencent_effect_flutter/api/android/tencent_effect_api_android.dart';
import 'package:tencent_effect_flutter/api/ios/tencent_effct_api_ios.dart';
import 'package:tencent_effect_flutter/model/xmagic_property.dart';

abstract class TencentEffectApi {
  static TencentEffectApi? _api;

  TencentEffectApi._internal();

  static TencentEffectApi? getApi() {
    if (_api != null) {
      return _api;
    }
    if (Platform.isAndroid) {
      _api = TencentEffectApiAndroid();
    } else if (Platform.isIOS) {
      _api = TencentEffectApiIOS();
    } else {}
    return _api;
  }

  ///初始化美颜数据，使用美颜前必须先调用此方法。
  void initXmagic(String xmagicResDir, InitXmagicCallBack callBack);

  ///美颜进行鉴权处理
  void setLicense(
      String licenseKey, String licenseUrl, LicenseCheckListener checkListener);

  ///设置 SDK 的 log 等级，建议开发调试时设为 `Log.DEBUG`，正式发布时设置为 `Log.WARN`，如果正式发布设置为 `Log.DEBUG`，大量的日志会影响性能。
  void setXmagicLogLevel(int logLevel);

  ///恢复渲染，页面可见时调用
  void onResume();

  ///暂停渲染，页面不可见时调用
  void onPause();

  ///开启美颜增强模式
  void enableEnhancedMode();

  ///更新美颜属性， 可在任意线程调用。
  void updateProperty(XmagicProperty xmagicProperty);

  ///设置创建美颜对象时的回调接口（如果出错会回调此接口）
  void setOnCreateXmagicApiErrorListener(
      OnCreateXmagicApiErrorListener? errorListener);

  ///设置动效提示语回调函数，用于将提示语展示到前端页面上。
  void setTipsListener(XmagicTipsListener? xmagicTipsListener);

  ///设置人脸点位信息等数据回调（S1-05 和 S1-06 套餐才会有回调）
  void setYTDataListener(XmagicYTDataListener? xmagicYTDataListener);

  ///设置人脸、手势、身体检测状态回调。
  void setAIDataListener(XmagicAIDataListener? aiDataListener);

  ///判断当前的 lic 授权支持哪些美颜。 仅支持 BEAUTY 和 BODY_BEAUTY 类型的美颜项检测。检测后的结果会赋值到各个美颜对象 XmagicProperty.isAuth 字段中。
  Future<List<XmagicProperty>> isBeautyAuthorized(
      List<XmagicProperty> properties);

  ///判断当前机型是否支持美颜（OpenGL3.0）。
  Future<bool> isSupportBeauty();

  ///返回当前设备支持的原子能力表（iOS无实现）
  Future<Map<String, bool>> getDeviceAbilities();

  ///将动效资源列表传入 SDK 中做检测，执行后 XmagicProperty.isSupport 字段标识该原子能力是否可用。 根据 XmagicProperty.isSupport 可 UI 层控制单击限制，或者直接从资源列表删除。
  Future<Map<XmagicProperty, List<String>?>> getPropertyRequiredAbilities(
      List<XmagicProperty> assetsList);

  ///传入一个动效资源列表，返回每一个资源所使用到的 SDK 原子能力列表。（iOS无实现）
  Future<List<XmagicProperty>> isDeviceSupport(List<XmagicProperty> assetsList);
}

///授权校验的结果回调方法
typedef LicenseCheckListener = void Function(int errorCode, String msg);

///创建美颜实例时的错误回调方法
typedef OnCreateXmagicApiErrorListener = void Function(
    String errorMsg, int code);

typedef XmagicYTDataListener = void Function(String data);

typedef InitXmagicCallBack = void Function(bool reslut);

typedef ProcessImgCallBack = void Function(
    Uint8List uint8list, int width, int height);

abstract class XmagicTipsListener {
  /// 显示tips。Show the tip.
  /// @param tips tips字符串。Tip's content
  /// @param tipsIcon tips的icon。Tip's icon
  /// @param type tips类别，0表示字符串和icon都展示，1表示是pag素材只展示icon。tips category, 0 means that both strings and icons are displayed, 1 means that only the icon is displayed for the pag material
  /// @param duration tips显示时长, 毫秒。Tips display duration, milliseconds
  void tipsNeedShow(String tips, String tipsIcon, int type, int duration);

  /// *
  /// 隐藏tips。Hide the tip.
  /// @param tips tips字符串。Tip's content
  /// @param tipsIcon tips的icon。Tip's icon
  /// @param type tips类别，0表示字符串和icon都展示，1表示是pag素材只展示icon。tips category, 0 means that both strings and icons are displayed, 1 means that only the icon is displayed for the pag material
  void tipsNeedHide(String tips, String tipsIcon, int type);
}

abstract class XmagicAIDataListener {
  void onFaceDataUpdated(String faceDataList);

  void onHandDataUpdated(String handDataList);

  void onBodyDataUpdated(String bodyDataList);
}

class LogLevel {
  static const int VERBOSE = 2;
  static const int DEBUG = 3;
  static const int INFO = 4;
  static const int WARN = 5;
  static const int ERROR = 6;
  static const int ASSERT = 7;
}
