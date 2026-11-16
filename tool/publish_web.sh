#!/bin/sh
# Builds the myShine web app and puts it into drShine, which serves it at
# myshine.smilelabs.app. Each release gets its own folder (public/myshine-web/<build>/),
# so browsers never mix an old and a new build; the folder before it is removed.
#
#   tool/publish_web.sh [path to drShine]     (default: ~/code/drshine)
#
# Afterwards commit and deploy drShine. CanvasKit (the drawing engine) is kept on our own
# server (--no-web-resources-cdn): nothing is loaded from Google when a patient opens the app.
set -e

cd "$(dirname "$0")/.."
DRSHINE="${1:-$HOME/code/drshine}"
BUILD="$(date +%Y%m%d%H%M)"
TARGET="$DRSHINE/public/myshine-web"

[ -d "$DRSHINE/public" ] || { echo "No drShine at $DRSHINE"; exit 1; }
export PATH="$HOME/development/flutter/bin:$PATH"

flutter build web --release --base-href "/myshine-web/$BUILD/" --no-web-resources-cdn

rm -rf "$TARGET"
mkdir -p "$TARGET/$BUILD/canvaskit/chromium"
cd build/web
cp -R assets icons favicon.png flutter_bootstrap.js index.html main.dart.js manifest.json version.json "$TARGET/$BUILD/"
# Only the engine files a browser can ask for (dart2js build, CanvasKit renderer): no wasm-only variants, no symbol files.
cp canvaskit/canvaskit.js canvaskit/canvaskit.wasm "$TARGET/$BUILD/canvaskit/"
cp canvaskit/chromium/canvaskit.js canvaskit/chromium/canvaskit.wasm "$TARGET/$BUILD/canvaskit/chromium/"

echo "myShine web $BUILD is in $TARGET/$BUILD ($(du -sh "$TARGET/$BUILD" | cut -f1)). Commit and deploy drShine."
