#📱 Xe.gr 
This is an app that create an add with an autocomplete API.

## ✨ Features
- Autocomplete search for locations
- Device-level caching to reduce API calls
- Debounced queries for smooth user experience
- Lightweight networking using URLSession

 ## 🛠 Tech Stack
 UI Framework  -> UIKit 
 Architecture  -> MVC 
 Language      -> Swift 
 Networking    -> URLSession async/await |
 Caching       -> NSCache 
 iOS Target    -> iOS 16+

## 📡 API
The app uses an autocomplete API to fetch suggested locations based on user input.  
Requests are made using 'URLComponents' with a 'GET' operation and decoded with 'Codable'.

## ✅ Caching Strategy
This app implements device-level caching (in-memory) using 'NSCache' to:
- Reduce duplicate network requests  
- Improve performance and responsiveness  
- Allow instant results when searching the same query again
