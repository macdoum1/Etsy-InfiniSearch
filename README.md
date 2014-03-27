Etsy-InfiniSearch
=================

Infinite Scrolling Search application for iOS


Appliation that utilizes Etsy's search API to create an infinite scrolling interface.

<b>Features</b>
-----
1. Allows user to search for listings using Etsy Search API
2. Listings include listing title and image
3. Images are loaded and cached asynchronously
4. Displays listings in a UICollectionView with custom UICollectionViewCells 
5. UICollectionView is infinitely scrolling with a loading indicator when loading more listings
6. Sorting options include Most Recent, Highest Price, Lowest Price, and Highest Score
7. Supports both Portrait & Landscape with AutoLayout

<b>Screenshots</b>
-----
<img src="http://i58.tinypic.com/2zdn1ja.png" height="400" />
<img src="http://i61.tinypic.com/68ts2p.png" height="400"/>

<b>Performance Graph</b>
-----
Memory usage was recorded using Xcode Profiler when scrolling through search results for 2 minutes
<img src="http://i62.tinypic.com/vmrejp.png" height="400"/>

<b>TODO</b>
-----
1. Get search results from Etsy <b>Completed</b>
2. Parse search results into objects <b>Completed</b>
3. Populate UICollectionView cells with contents of objects <b>Completed</b>
4. Ensure searching and loading does not effect performance <b>Completed</b>
5. Stylize UICollectionViewCells <b>Completed</b>
6. Add loading indicator when searching <b>Completed</b>
6. Add loading indicator when loading more results <b>Completed</b>

<b>Wishlist</b>
-----
1. Search filters (Price, Color, etc.) <b>Completed</b>
2. Advanced UI to display search results <b>Completed</b>

