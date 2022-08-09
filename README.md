# Daigo

[![CI Status](https://img.shields.io/travis/yuuki-noda/Daigo.svg?style=flat)](https://travis-ci.org/yuuki-noda/Daigo)
[![Version](https://img.shields.io/cocoapods/v/Daigo.svg?style=flat)](https://cocoapods.org/pods/Daigo)
[![License](https://img.shields.io/cocoapods/l/Daigo.svg?style=flat)](https://cocoapods.org/pods/Daigo)
[![Platform](https://img.shields.io/cocoapods/p/Daigo.svg?style=flat)](https://cocoapods.org/pods/Daigo)

Daigo is library for vertical viewer. The name comes from the Daigo hot spring.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

[example project](Example/Daigo/ViewController.swift)

Daigo is responsible for processing around user actions in the viewer.
However, Daigo does not retain data.

### Supported

* Vertical Viewer Zoom
* Scrolling with UISlider
* Toggle header footer display
* Notification of index switching
* Notification of tapped page index

### Not supported

* Vertical and horizontal switching
* Screen Rotation

### API

#### DaigoViewController

```swift
override func hiddenBar(isHidden: Bool, animated: Bool)
```

It is called when the header and footer appear and disappear.
To override, call `super.hiddenBar(isHidden: isHidden, animated: animated)`.

```swift
setSliderValue(value: CGFloat)
```

Viewer page flipping remas using UISlider
If value is 1, the first page is displayed. And if value is 0, the last page is displayed.

#### DIGViewerDelegate

```swift
func daigoCollectionView(_ collectionView: DaigoCollectionView, visibleIndex indexPath: IndexPath)
```

visibleIndex contains the index of the cell currently displayed in the center.

```swift
func daigoCollectionView(_ collectionView: DaigoCollectionView, didSelectIndex indexPath: IndexPath) -> Bool
```

didSelectIndex contains the index of the tapped Cell.
Return true if you want to toggle the header footer. hiddenBar is called

```swift
func aspectRatio(cellForItemAt indexPath: IndexPath) -> CGFloat?
```

Return the aspect ratio of the image.
If nil, the cell size will be the same as UIScreen.main.bouds.size.

## Installation

Daigo is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Daigo'
```

## Author

yuuki-noda, yuuki.noda@link-u.co.jp

## License

Daigo is available under the MIT license. See the LICENSE file for more info.
