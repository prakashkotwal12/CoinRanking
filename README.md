# CoinRanking
This is the CoinRanking app! This app is made with Swift and one can explore cryptocurrency data in a simple and easy-to-use interface. It uses SwiftUI for small views and UIKit for more advanced features. The app has features like charts to see trends, marking coins as favorites, real-time filters to organize data quickly, and saving your data locally with Core Data.

**Instructions for Building and Running the Application**

Follow these steps to build and run the project locally:
- Clone the repo
    - git clone https://github.com/prakashkotwal12/CoinRanking/
    - cd CoinRanking
- Open CoinRanking.xcodeproj file in Xcode.
- Before running, need to setup dependencies. We used Swift Package Manager (SPM). Go to File > Swift Packages > Resolve Packages. After that dependencies will be downloaded.
- Note: This project was created using Xcode 16.2, with iOS 17.0 set as the minimum deployment target. To run the project, make sure you’re using Xcode 15.0 or later, as earlier versions do not support iOS 17.0. Double-check your setup to ensure compatibility and avoid any issues while building or running the app.
- Select the CoinRanking scheme and press Cmd+R to run the app. Make sure simulator or device is selected for build.

**Assumptions and Suggestions**
- Assumed user always has active internet connection because app fetch data from API.
- Core Data is used to save and fetch favorite coins. The app refreshes Core Data whenever new data is fetched from the server to ensure consistency.
- Favorite coins sync across all tabs (Home and Favorites). As a result, when a coin is marked as a favorite or removed, changes are immediately reflected across the app.
- Filters and sorting apply instantly.
- SwiftUI is used for small views and larger and complex views are made with UIKit

**Challenges Faced & Solutions**
- **SwiftUI + UIKit Integration**: In app we used both SwiftUI and UIKit. To handle this, we used UIHostingController to bridge SwiftUI with UIKit.
- **CoreData Favorites Management:** CoreData is used to save user favorite coins. It was challenging to keep data in sync across screens like Home and Favorites tab. We solve it by refreshing CoreData everytime we fetch coins.
- **Real-time Filters:** The app has live filtering and sorting. It apply filter directly when user selects, without any lag. It was implemented by binding filters with ViewModel and updating UI immediately.
- **Multiple Dependencies:** Handling Swift Packages like Alamofire and SDWebImageSwiftUI was tricky for build configuration. We added them carefully and resolve issues with version conflicts.

**Features of App**
- **HomeView:** Shows a list of coins with basic info like Name, Price, and image.
- **Favorites Tab:** Saves coins marked as favorite and shows them in separate view.
- **Filters:** Allows user to filter coins by Name, Price, or Performance with real-time application.
- **Efficient API Calls:** Uses Alamofire to fetch coins data from server efficiently.

**How App Works**
- **Home Tab:**
    - Displays a list of coins fetched from the server.
    - Users can mark coins as favorites by swipping left.
- **Favorites Tab:**
    - Displays the list of coins marked as favorites.
    - Users can remove coins from their favorites list, which dynamically updates the Home Tab.
- **Filters:** Users can filter and sort coins in real time by selecting filter categories and sort orders.
- **Charts:** The app supports interactive chart visualizations, including Line, Bar, Pie, Area, and Point charts.




**Thank you!**




