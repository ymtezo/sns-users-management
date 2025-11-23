# アプリアイコンについて

このディレクトリにはAndroid APK用のアプリアイコンを配置します。

## 必要なアイコンサイズ

以下のサイズのPNG画像を用意してください:

- `ldpi.png` - 36x36 pixels (低解像度)
- `mdpi.png` - 48x48 pixels (中解像度)
- `hdpi.png` - 72x72 pixels (高解像度)
- `xhdpi.png` - 96x96 pixels (超高解像度)
- `xxhdpi.png` - 144x144 pixels (超超高解像度)
- `xxxhdpi.png` - 192x192 pixels (超超超高解像度)

## デフォルトアイコン

アイコンを配置しない場合、Cordovaのデフォルトアイコンが使用されます。

## アイコンの作成

1. 512x512のマスター画像を作成
2. オンラインツールでリサイズ:
   - https://icon.kitchen/
   - https://romannurik.github.io/AndroidAssetStudio/
3. 生成されたアイコンをこのディレクトリに配置

## 注意事項

- PNG形式を使用
- 透明背景は避ける（Android 12+では丸く切り抜かれます）
- シンプルで認識しやすいデザインを推奨
