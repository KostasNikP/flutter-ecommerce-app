/// Curated Commons photo sources by exact device model.
/// #detail means a close-up crop of the same verified photograph.
class ProductGallery {
  const ProductGallery._();

  static const Map<int, List<String>> sources = {
    1: ['commons:Back view of iPhone 11 white.jpg', 'asset:photo/Iphone11.png'],
    2: ['commons:Iphone-12-product--red.png',
        'commons:Rear 3 lenses of an iPhone 12.jpg', 'asset:photo/Iphone12.png'],
    3: ['commons:IPhone 13.jpg', 'commons:IPhone 13 White 256g.jpg',
        'asset:photo/Ipone13.png'],
    4: ['commons:IPhone 14 - 3.jpg', 'commons:IPhone 14 20240225.jpg',
        'asset:photo/Ipone14.png'],
    5: ['commons:Back of iPhone 15.jpg', 'commons:Back and side of iPhone 15.jpg',
        'asset:photo/Iphone15.png'],
    6: ['commons:AirPods Pro (2nd generation).jpg',
        'commons:AirPods Pro (2nd generation).jpg#detail'],
    7: ['commons:Watch SE (2nd generation).jpg',
        'commons:Apple Watch SE 2 (GPS + Cellular, 40mm, Midnight) with Anchor Blue Sport Loop.jpg'],
    8: ['commons:IPad Air 5th Generation 2024.jpg',
        'commons:IPad Air 5th Generation 2024.jpg#detail'],
    9: ['commons:M2 Macbook Air Starlight model.jpg',
        'commons:M2 Macbook Air Midnight model - 1.jpg',
        'commons:MacBook Air (A2681) rear.jpg'],
    10: ['commons:Apple TV 4K (3rd Generation, 2022) with Siri Remote (cropped).jpg',
         'commons:Apple TV 4K (3rd Generation, 2022) with Siri Remote.jpg',
         'commons:Siri Remote (3rd Generation, 2022).jpg'],
    11: ['commons:MagSafe and USB-C Cable Charger for iPhone.jpg',
         'commons:MagSafe and USB-C Cable Charger for iPhone.jpg#detail'],
    12: ['commons:Apple Pencil Second Generation - 2.jpg',
         'commons:Apple Pencil Second Generation.jpg',
         'commons:Apple Pencil Second Generation - 5.jpg'],
  };

  static List<String> forId(int id) => sources[id] ?? const [];
}
