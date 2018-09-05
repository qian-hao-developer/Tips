Android Framework の AudioService に追加した、Drawin音量設定用の
@hide API や元々 @hide 設定されているクラス(SystemProperties, 等) を
Android Studio 上でシンボル解決するには、上記の API や クラスの
シンボル情報が含まれたクラスファイルを動的リンクさせる必要がある。

■対応するjar
framework.jar
 - AudioService     (DarwinAccessControllerが使用)
 - SystemProperties (DarwinAccessControllerが使用)

以上
