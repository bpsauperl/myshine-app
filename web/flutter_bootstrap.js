{{flutter_js}}
{{flutter_build_config}}

// No service worker: the web app is always loaded fresh from drShine, which
// puts every release in its own folder, so nothing stale is ever served.
_flutter.loader.load();
