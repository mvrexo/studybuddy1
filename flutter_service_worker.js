'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"manifest.json": "1d656c7caa19661bc673438de24607e8",
"main.dart.js": "81d39bcbf52df2f725588be01bb8508b",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"index.html": "efede35ae84c676d8af4a1b3333e7430",
"/": "efede35ae84c676d8af4a1b3333e7430",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/AssetManifest.bin.json": "5931db9ad6adba8ac5c77c2f06329605",
"assets/AssetManifest.bin": "86095c73e851e536ed79ea878aa9b24e",
"assets/NOTICES": "66291800b8495fa457b60e20e2d6cac9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/triangle.jpg": "ab11ef0e19090ac12cede0362f2a2a26",
"assets/assets/comel.avif": "247400dad7b8950f162ee6fa2d5b550b",
"assets/assets/b.png": "6665adeddee79d9ba52f9fc224d82064",
"assets/assets/oxygen.jpg": "3e00ac1cbba59c835adcfc942fff15fb",
"assets/assets/plant.jpg": "875b239d6703b9478400b6508edbe8b2",
"assets/assets/logo.png": "edc742111eb352ddfdb4de0d020fb810",
"assets/assets/bg.jpg": "8de311857e2eed58a1a7da661fc785a9",
"assets/assets/hat.jpg": "1cf56ef7b5914694b87d1c8617974023",
"assets/assets/putih.jpg": "dd68b562639372fa003ee816153a5c33",
"assets/assets/bird.jpg": "5238ea42d3c655a969514584c04f87ef",
"assets/assets/suhu.jpg": "ef71f4327cc6de25533cde19ccd90aef",
"assets/assets/mammal.jpg": "62f298214843c7ecdb689eb6d309c4ba",
"assets/assets/read.jpg": "9043dbfc8f4dde95608daff76167cbfe",
"assets/assets/good.jpg": "685019b4e08bf3c8fb9a1e7bb3e76896",
"assets/assets/guess.jpg": "5e932ae5509ee8b427dd3e1fcd2f7a18",
"assets/assets/20.png": "a4a9f816055f4a2ad6a79c6ccd634875",
"assets/assets/rabbit.png": "762e0bf44d0a44a5026bc215a83b1411",
"assets/assets/slide1.jpg": "41aa0810913f5b516b6c28968585bf12",
"assets/assets/budak.jpg": "4cec0c8c39294cb8d5e963e2264d0e28",
"assets/assets/comel.gif": "ad61300531e780876e02a78340d39c68",
"assets/assets/c2.jpg": "0e8cfae959dff14c2a91d92ffe8f75fb",
"assets/assets/putih1.jpg": "c5148b27371d442db6652ebf4d2d884a",
"assets/assets/12.png": "33924062fdf3bbbbede4135c8d954134",
"assets/assets/earth.jpg": "4dd62f229345e2d89278dd96a17e44a6",
"assets/assets/reptiles.jpg": "23cb3749cdf47ce132098bd6842d346a",
"assets/assets/fish.jpg": "9a4084b3213c7f9cb5af4a4a4a97fb8b",
"assets/assets/bee.gif": "48542dc2bb30002f47795005a8d4c675",
"assets/assets/c5.jpg": "06609d7ef304b1833ce3c192c81c27e2",
"assets/assets/logobee.png": "63ed7adf0b758fb548bb16388f59199d",
"assets/assets/pencil.png": "406198379d5169b5888a5a9dc0545b72",
"assets/assets/c1.jpg": "a0364d8b9937a1baa973d627567e182f",
"assets/assets/woof.jpg": "90c62c951ecfc9062f8aad4c661f771a",
"assets/assets/5.jpg": "5cfba8d0c49765a69a3872b6f48730ef",
"assets/assets/huruf.mp4": "cdf1e1d14f4179d778547b10b7befc46",
"assets/assets/gajah.png": "d6291b87082e126b6d653b9fbfdcbf64",
"assets/assets/cute.avif": "dcdc2f5b2b1ab8b3c045dfee0485ae3c",
"assets/assets/slide2.jpg": "768647f3853d620f9e4d5fef6bce1cbb",
"assets/assets/bluesky.jpg": "54744516590555f9f9f799cf52d31d7c",
"assets/assets/correct.mp3": "9c103ef30e0de7f28cbe48a9a6950052",
"assets/assets/frog.jpg": "59f221679c14ef014335c3476d728497",
"assets/assets/sunlight.jpg": "ecec75582418e98b970f15c3334af1ae",
"assets/assets/logobee.gif": "623c30132c35a58ea3b3666430b27d46",
"assets/assets/paperbg.jpg": "a442c39f8d92e2dd3820b91b650c9652",
"assets/assets/plant_diagram.jpg": "1008af07c8a19c90c946505704b7db8d",
"assets/assets/studybuddylogo.gif": "086b0aeb65996287366be0fc8d0c0145",
"assets/assets/logo1.png": "7c06d7e0812681546386d2636a64c70e",
"assets/assets/rabbit.gif": "479772e216dc055886b5d60dd6ee7812",
"assets/assets/wrong.mp3": "724c421be67d687fbd8d7c0963932f95",
"assets/assets/rocket.jpg": "193a308496a8c4a6fa7da812e2a5ddaa",
"assets/assets/c4.jpg": "64ff57a708d0f77872687e0961210157",
"assets/assets/bee1.gif": "71874c53a186d0de6c63a89ae3e5a360",
"assets/assets/super.jpg": "22447df19b375a5b1f89e158e4c7a981",
"assets/assets/insect.jpg": "d047a35913d13d7dc653b96873394900",
"assets/assets/slide3.jpg": "1e8d1a363e00f06d95ae86ee6bac483a",
"assets/assets/number.mp4": "3fdce15bfed1ead8a58f041db7007f8b",
"assets/assets/water.jpg": "7961e9d9e842e2239d8b2354c691941f",
"assets/assets/13.jpg": "7f18ded6f130979f925360bc1221bbb6",
"assets/assets/cartoonbg.jpg": "ba54c0a6da070feb1c9b22b9f1805be6",
"assets/assets/banana.jpg": "0bab914eb7bc26426aee76a5bc7dfe37",
"assets/assets/c3.jpg": "f570e5ba84b09f72b537e2a7e3a07e05",
"assets/assets/awan.jpg": "507d2eb7272bb0ff49529a3bb58b9057",
"assets/assets/animal.jpg": "1e6892f9f62a5b6eeabe6637fb543d7e",
"assets/AssetManifest.json": "76cd12acd7cfc208a5d75875013b66ab",
"assets/fonts/MaterialIcons-Regular.otf": "63d21e17b81ba04818883909994a47bd",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"flutter_bootstrap.js": "6e3b3257d5f22a33eaab14d2b3324f32",
"version.json": "38ed98e67ca2a2026e2a4c975e5cbdec"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
