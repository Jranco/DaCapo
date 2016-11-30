# DaCapo

## Description

DaCapo is an app for searching classical music Composers and playing their tracks in an asynchronous way. It utilizes the “Spotify Web API” in order to retrieve the list of classical Composers, sorted based on popularity and to search a Composer for a given name. The datasource for the Composer’s relevant tracks comes from the “Youtube Data API” and the playback is managed by the “YouTube-Player-iOS-Helper” framework.

##Features

* Show list of popular classical Composers with pagination enabled.
* Search for a specific classical Composer.
* Show relative tracks of a selected Composer with pagination enabled.
* Select and play a track while keeping User free to continue navigating through the app.

## Requirements

* Xcode (8.0)
* Swift (3.0)
* CocoaPods 

## Project Structure

The DaCapo project's architecture is following the MVVM-C design pattern.


![Alt text](/mgames/DaCapo/MVVM-C diagram.png?raw=true "Optional Title")

The following ERD diagram projects the structure of the Views’ stack.

![Alt text](/mgames/DaCapo/ERD diagram.png?raw=true "Optional Title")

## Space for improvement

* Replace current playback component based on ‘YTplayer’. ‘YTplayer’ consists of a webview to load the track from Youtube and therefore it blocks the main thread and it is not possible to separate the audio channel without a hack. In addition there is no justification to use background mode for playing audio while the app is in the background. It was a good trade-off for this prototype though, since it was also required to use Youtube API/player.
* Ability to hide the player completely.
* More control buttons inside the minimizedPlayer.
* Handle no internet connectivity. Introduce ‘Reachability’ component.
* Enable Refresh Control and fix wrong offset in the ‘Composer’ screen.
* Authentication is missing for simplicity reasons.
* Bug fixing, refactoring is needed.
* The Composer’s image in Composer’s Tracks screen doesn’t appear in simulator, although it is visible and appears correctly in the UI debugger. In a real device there is no problem.
* Unit, UI testing.
* Improve animations.
* All text localization.
* Add more constants.
* Image caching.

## Libraries and Frameworks

* Alamofire (4.0) - Alamofire is an HTTP networking library written in Swift.
* ObjectMapper (2.2) - ObjectMapper is a framework written in Swift that makes it easy for you to convert your model objects (classes and structs) to and from JSON.
* Reusable (2.5.0) - A Swift mixin for UITableViewCells and UICollectionViewCells
* youtube-ios-player-helper (0.1.6) - Helper library for iOS developers looking to add YouTube video playback in their applications via the iframe player in a UIWebView