#!/bin/sh
# Copies the images from render_brand_test.dart into the iOS and Android projects.
#   flutter test tool/brand/render_brand_test.dart && sh tool/brand/install.sh
set -e
cd "$(dirname "$0")/../.."
src=build/brand
tmp=$(mktemp -d)

# The App Store rejects icons with an alpha channel: flatten through JPEG.
sips -s format jpeg -s formatOptions best "$src/icon.png" --out "$tmp/icon.jpg" >/dev/null
sips -s format png "$tmp/icon.jpg" --out "$tmp/icon.png" >/dev/null

ios=ios/Runner/Assets.xcassets/AppIcon.appiconset
for file in "$ios"/*.png; do
  size=$(sips -g pixelWidth "$file" | awk '/pixelWidth/ {print $2}')
  sips -z "$size" "$size" "$tmp/icon.png" --out "$file" >/dev/null
done

for pair in mdpi:48 hdpi:72 xhdpi:96 xxhdpi:144 xxxhdpi:192; do
  density=${pair%%:*}
  size=${pair##*:}
  sips -z "$size" "$size" "$tmp/icon.png" \
    --out "android/app/src/main/res/mipmap-$density/ic_launcher.png" >/dev/null
  mkdir -p "android/app/src/main/res/drawable-$density"
  cp "$src/launch_image_$density.png" \
    "android/app/src/main/res/drawable-$density/launch_image.png"
done

cp "$src"/LaunchImage*.png ios/Runner/Assets.xcassets/LaunchImage.imageset/
rm -r "$tmp"
