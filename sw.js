const CACHE = "ph-a-la-vista-fase1-v0.3.1-pilot";
const ASSETS = [
  "./", "./index.html", "./manifest.webmanifest", "./assets/css/app.css",
  "./assets/js/app.js?v=0.3.1", "./assets/js/core/db.js", "./assets/js/core/seed.js",
  "./assets/js/modules/stats.js", "./assets/js/modules/agronomy.js", "./assets/js/modules/sync.js",
  "./assets/js/modules/geolocation.js", "./assets/js/modules/bluetooth.js", "./assets/js/modules/charts.js",
  "./assets/js/modules/csv.js", "./assets/js/modules/auth.js", "./assets/js/modules/remote.js",
  "./config/app.js", "./config/demo-data.json", "./config/agronomy.json",
  "./assets/js/modules/lots.js",
  "./icons/icon.svg", "./icons/icon-192.png", "./icons/icon-512.png"
];
const allowed = new Set(ASSETS.map(path => new URL(path, self.registration.scope).href));

self.addEventListener("install", event => event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(ASSETS)).then(() => self.skipWaiting())));
self.addEventListener("activate", event => event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key !== CACHE).map(key => caches.delete(key)))).then(() => self.clients.claim())));
self.addEventListener("fetch", event => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== "GET" || url.origin !== self.location.origin) return;
  if (request.mode === "navigate") {
    event.respondWith(fetch(request).catch(() => caches.match(new URL("./index.html", self.registration.scope))));
    return;
  }
  if (!allowed.has(url.href)) return;
  event.respondWith(caches.match(request).then(cached => cached || fetch(request).then(response => {
    if (response.ok) caches.open(CACHE).then(cache => cache.put(request, response.clone()));
    return response;
  })));
});
