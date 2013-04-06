#Daily Nexus Maintainer's Guide#

This document provides background information about the structure and design of the Daily Nexus app, and is intended for future developers. You should familiarize yourself with this document before making changes to the app.

##About the app##
The Daily Nexus app:

* Is built against the iOS 6.1 SDK and requires iOS 6.1 or newer to run
* Is a universal app
* Supports iPhone 3GS, 4, 4S and 5, iPad 2, 3, 4 and mini, and iPod touches from that same time frame
* Uses Automatic Reference Counting

##Runtime flow##
This section describes how the various objects interact during a typical usage scenario.

When the app is launched, [`TDNAppDelegate`](TDNAppDelegate.md) `application:didFinishLaunchingWithOptions:` method is automatically called. This method creates a [`TDNSlidingDrawerViewController`](TDNSlidingDrawerViewController.md) with three child view controllers: [`TDNSectionViewController`](TDNSectionViewController.md) (in the left drawer) [`TDNFrontPageViewController`](TDNFrontPageViewController.md) (the main view controller) and [`TDNCommentsViewController`](TDNCommentsViewController.md) (in the right drawer). Each of these view controllers is embedded in a `UINavigationController` before being added so that it will have a navigation bar and title. The [`TDNSlidingDrawerViewController`](TDNSlidingDrawerViewController.md) is then set as the window's root view controller.

As execution continues, the [`TDNFrontPageViewController`](TDNFrontPageViewController.md)'s `viewDidLoad` method is called by the system. The view controller configures its views and requests that the singleton object [`TDNArticleManager`](TDNArticleManager.md) load the articles in the Most Recent (ie, today's stories, the default RSS feed) section and sets itself as the [`TDNArticleManager`](TDNArticleManager.md)'s delegate. It also creates and displays a [`TDNLoadingView`](TDNLoadingView.md) while this process is ongoing.

The [`TDNArticleManager`](TDNArticleManager.md)'s `loadArticles` method notifies its delegate ([`TDNFrontPageViewController`](TDNFrontPageViewController.md)) that it has started loading, asynchronously downloads the contents of the RSS feed, then parses them using a [`TDNFeedParser`](TDNFeedParser.md) created when it was initialized.

The [`TDNFeedParser`](TDNFeedParser.md)'s `articlesWithFeedData:` method is called by [`TDNArticleManager`](TDNArticleManager.md). It creates an instance of NSXMLParser, and uses it to create an array of [`TDNArticle`](TDNArticle.md) model objects from the contents of the RSS feed. While doing so, it uses an instance of [`TDNMultimediaParser`](TDNMultimediaParser.md) to extract image URLs from the HTML source of each article, and stores the resulting URLs in the [`TDNArticle`](TDNArticle.md) objects. Before storing values in the [`TDNArticle`](TDNArticle.md) objects, it uses the `strippedString` method in the [`NSString+TDNAdditions`](NSString+TDNAdditions.md) category to clean up and sanitize string values. After finishing parsing, it returns the array of [`TDNArticle`](TDNArticle.md) objects to its caller, the [`TDNArticleManager`](TDNArticleManager.md), which stores the array in an instance variable. The [`TDNArticleManager`](TDNArticleManager.md) then notifies its delegate ([`TDNFrontPageViewController`](TDNFrontPageViewController.md)) that is has finished loading.

When its `articleManagerDidFinishLoading` delegate method is called by the [`TDNArticleManager`](TDNArticleManager.md), the [`TDNFrontPageViewController`](TDNFrontPageViewController.md) updates its view to display the articles and calls its own `loadImages` method, then removes the [`TDNLoadingView`](TDNLoadingView.md). The `loadImages` method iterates through the [`TDNArticle`](TDNArticle.md) objects in the [`TDNArticleManager`](TDNArticleManager.md)'s `articles` property, and asynchronously loads any image URLs they contain. The resulting images are resized using the [`UIImage+TDNAdditions`](UIImage+TDNAdditions.md) category and stored in an instance variable in the [`TDNFrontPageViewController`](TDNFrontPageViewController.md), which again reloads its view to display the images.

**At this point, the app is fully initialized and ready for the user to interact with.**

When the user selects an article, the [`TDNFrontPageViewController`](TDNFrontPageViewController.md) is notified by a `UITableView` or `UICollectionView` delegate method. In either case, it determines which [`TDNArticle`](TDNArticle.md) was selected, sets it as the [`TDNArticleManager`](TDNArticleManager.md)'s `currentArticle`, and creates and presents a [`TDNArticleViewController`](TDNArticleViewController.md).

The [`TDNArticleViewController`](TDNArticleViewController.md)'s `viewWillAppear:` method configures its view (a `UIWebView`) and loads the [`TDNArticleManager`](TDNArticleManager.md)'s `currentArticle`'s `htmlRepresentationWithHeight:andColumns:` HTML string in it. It also tells the [`TDNSlidingDrawerViewController`](TDNSlidingDrawerViewController.md) that it may display the right drawer ([`TDNCommentsViewController`](TDNCommentsViewController.md)) in response to swipes to the left (on the iPad, this behavior is only enabled once the story has been read in its entirety, to avoid contacts between the swipe and scroll gestures).

If the [`TDNCommentsViewController`](TDNCommentsViewController.md) is presented, it asynchronously loads the [`TDNArticleManager`](TDNArticleManager.md)'s `currentArticle`'s URL, then creates an instance of [`TDNCommentsParser`](TDNCommentsParser.md) and uses it to extract comments.

The [`TDNCommentsParser`](TDNCommentsParser.md) object uses methods in XPathQuery to parse out comments, creates an array of [`TDNComment`](TDNComment.md) model objects, and returns that array to the [`TDNCommentsViewController`](TDNCommentsViewController.md), which stores them in the [`TDNArticleManager`](TDNArticleManager.md)'s `currentArticle`'s `comments` property, then updates its view to display the comments.

If the [`TDNCommentsParser`](TDNCommentsParser.md)'s add comment button is tapped, it creates and presents an instance of [`TDNCommentPostingViewController`](TDNCommmentPostingViewController.md).

When the [`TDNArticleViewController`](TDNArticleViewController.md)'s back button is tapped, it dismisses itself and the [`TDNFrontPageViewController`](TDNFrontPageViewController.md) again becomes visible.

If the user swipes to the right or taps the triple-line button in the navigation bar, the [`TDNSlidingDrawerViewController`](TDNSlidingDrawerViewController.md) will present the [`TDNSectionViewController`](TDNSectionViewController.md) in its left drawer. If the user taps a section, the [`TDNSectionViewController`](TDNSectionViewController.md) will set the tapped section as the [`TDNArticleManager`](TDNArticleManager.md)'s `currentSection`, remove all of its articles, and instruct it to load the articles for the new section. This will result in the execution of the same flow as when the app is launched.

If the user taps the Daily Nexus 1.0 text at the bottom of the list of sections, the [`TDNSectionViewController`](TDNSectionViewController.md) will create and present modally an instance of [`TDNAboutViewController`](TDNAboutViewController.md).

[`TDNEtchedSeparatorTableViewCell`](TDNEtchedSeparatorTableViewCell.md) is a subclass of `UITableViewCell` used in all `UITableView`s within the app. [`TDNArticleCollectionViewCell`](TDNArticleCollectionViewCell.md) is a subclass of `UICollectionViewCell` used by [`TDNFrontPageViewController`](TDNFrontPageViewController.md) for displaying articles on the iPad.

##Graphical notes##
All main views in the app have a `UIImageView` as a subview that displays the NoiseBackground image.

The color of primary text and titles is `[UIColor colorWithWhite:0.2 alpha:1.0]` (`#333333`).

The color of secondary text and titles is `[UIColor colorWithWhite:0.5 alpha:1.0]` (`#808080`).

The Original Graphics directory contains the raw versions of all icon resources with layers, layer styles, etc. They are [Acorn](http://www.flyingmeat.com/acorn/) images.

##Where to look if things go wrong##
###If articles don't load###
Look at [`TDNArticleManager`](TDNArticleManager.md). Have the URLs for the Daily Nexus RSS feed changed? Is the Daily Nexus site up? If the format of the RSS feed has changed, you'll need to update [`TDNFeedParser`](TDNFeedParser.md).
###If images don't load###
Make sure the image URLs are present in the feed's `content:encoded` element. Additionally, make sure they aren't thumbnail images, with a filename ending in -000x000.jpg, where the zeros correspond to the dimensions of the image. The app ignores thumbnail image URLs because they look bad on retina devices. This behavior can be changed in [`TDNMultimediaParser`](TDNMultimediaParser.md).
###If comments don't load###
Make sure the format of the Daily Nexus website hasn't changed. If it has, update [`TDNCommentsParser`](TDNCommentsParser.md) to reflect the new format. Also, if article IDs have exceeded 5 digits, (or the article in question has an ID less than 5 digits in length), you'll need to fix [`TDNFeedParser`](TDNFeedParser.md) to extract article IDs of the correct length when it sets the [`TDNArticle`](TDNArticle.md) object's `postID` property.
###If users can't post comments###
Changing the Askimet configuration on the Daily Nexus site (or using a different anti-spam plugin) may cause problems. You may need to modify the section of [`TDNCommentsViewController`](TDNCommentsViewController.md) where the `commentNonce` property is set, or store a different parameter/use some other technique to avoid comments being flagged as spam.
###If the formatting of articles is wrong###
Most likely, this is due to bad source formatting in the feed. Check the feed for extraneous newlines or whatever weird formatting you're seeing, and correct it on the Daily Nexus site.

##Hacks and workarounds##
The `strippedString` method in [`NSString+TDNAdditions`](NSString+TDNAdditions.md) would be more accurately named `sanitizedString`. However, this appears to conflict with something in the system, because naming it that will cause it to silently stop doing anything after some time.

In [`TDNAboutViewController`](TDNAboutViewController.md) and [`TDNArticleViewController`](TDNArticleViewController.md), we walk the view hierarchy of the `UIWebView` and hide all `UIImageView`s. This is done to hide the shadows that the `UIWebView` draws around itself. This shouldn't cause anything bad to happen, but may stop working in the future and should be replaced if/when supported API to do this becomes available.

The `layoutShadowsWithDuration` method in [`TDNSlidingDrawerViewController`](TDNSlidingDrawerViewController.md) is there to update the path of the shadow drawn atop the drawers during device orientation changes. I'm not entirely sure how it works - the workaround is from [http://blog.radi.ws/post/8348898129/calayers-shadowpath-and-uiview-autoresizing](http://blog.radi.ws/post/8348898129/calayers-shadowpath-and-uiview-autoresizing)