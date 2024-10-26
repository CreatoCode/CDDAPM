#### CDDAPM
This repository contains an iOS application that monitors various performance metrics to ensure a smooth user experience. 

### Features
1. **Memory Warnings**
2. **Network Request Errors**
3. **White Screens**
4. **Zombie Objects (i.e., Crashes)**
5. **Frame Rate**
6. **Lag**
7. **Launch Duration**

### Installation

1. **Clone the Repository**

```sh
   git clone https://github.com/CreatoCode/CDDAPM.git
   cd CDDAPM
```

### Usage

1. **Enable Monitoring**
   - In your app delegate or main view controller, initialize the monitoring system:

```objective-c
int main(int argc, char * argv[]) {
    [[CDDAPM sharedInstance] appDidLaunch];
    [[CDDAPM sharedInstance] startPlugins:CDDAPMProfilingAll];
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
```

### Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### Contact

If you have any questions or further development requirements, please contact mail:flashgeek@qq.com or WeChat: CoderDreamTech
