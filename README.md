<h1>SafexPay iOS SDK</h1>


 [![Language](https://img.shields.io/badge/Swift-5-red?style=plastic)]()
 [![Language](https://img.shields.io/badge/Objective--C-compatible-blue?style=plastic)]()
 [![License](https://img.shields.io/github/license/antinolabsdev/WddOnboarding-SDK-iOS?style=plastic)]()

## Requirements

- iOS 11.0+
- Xcode 10.2.1+
- Swift 4.2+ or Objective-C

## CocoaPods

To use the SafexPay SDK we recommend to use Cocoapods 1.7.0 or later

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ sudo gem install cocoapods
```

To integrate the SafexPay SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

pod 'Safex_Pay'
```


Then, run the following command:

```bash
$ pod install
```

## Usage
First of all, if you don't have an Xcode project yet, create one, then install the SDK following the paragraph `Cocoapods`.

**1)** Import the Safex_Pay iOS SDK module in your UIApplicationDelegate subclass:

```
import Safex_Pay
```

**2)** Configure a Safex_Pay iOS SDK shared instance, in your App Delegate, inside **application:didFinishLaunchingWithOptions:** method:

```
Safex_pay.sharedInstance.configure(MerchantId: MERCHANT_ID, MerchantKey: MERCHANT_KEY)
```
**If in doubt, you can look at the examples in the demo application.**


### Using Safex_Pay
**1)** Import the Safex_Pay iOS SDK module in your ViewController:

```
import Safex_Pay
```

**2)** To use the payment gateway call this method on ViewController:

```
Safex_pay.sharedInstance.showPaymentGateway(on: self, price: AMOUNT, orderId: ORDERID, custName: CUSTOMERNAME, custEmail: CUSTOMEREMAIL, custNumber: CUSTOMERNUMBER, country: COUNTRYCODE, currency: CURRENCYCODE)
```

- Here **self** is your current view controller
- **price** is amount to be paid
- **orderId** is transaction order id
- **custName** is customer name
- **custEmail** is customer email
- **custNumber** is customer number
- **country** is country code
- **currency** is currency code

## Contributing

- If you **need help** or you'd like to **ask a general question**
- If you **found a bug**, open a service request.
- If you **have a feature request**, open a service request.
- If you **want to contribute**, submit a pull request.



## Acknowledgements
Made with ❤️ by [Antino Labs](https://www.antino.io/).

## License
Safex_Pay is released under the MIT license. [See LICENSE](https://github.com/antinolabsdev/Safex-Pay_iOS/blob/master/LICENSE) for details.
