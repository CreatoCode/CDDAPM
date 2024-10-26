当然！以下是翻译：

#### CDDAPM
本仓库包含一个 iOS 应用程序，用于监控各种性能指标，以确保流畅的用户体验。

### 功能
1. **内存警告**
2. **网络请求错误**
3. **白屏**
4. **僵尸对象（即崩溃）**
5. **帧率**
6. **卡顿**
7. **启动时长**

### 安装

1. **克隆仓库**

```sh
git clone https://github.com/CreatoCode/CDDAPM.git
cd CDDAPM
```

### 使用

1. **启用监控**
   - 在你的应用代理或主视图控制器中初始化监控系统：

```objective-c
int main(int argc, char * argv[]) {
    [[CDDAPM sharedInstance] appDidLaunch];
    [[CDDAPM sharedInstance] startPlugins:CDDAPMProfilingAll];
    NSString * appDelegateClassName;
    @autoreleasepool {
        // 可能会创建自动释放对象的设置代码放在这里。
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
```

### 贡献

欢迎贡献！如果你发现任何问题或有改进建议，请提交问题或拉取请求。

感谢 AlexTing0 开源的僵尸对象检查 DDZombieMonitor。

### 许可证

本项目采用 MIT 许可证。详情请参见 [LICENSE](LICENSE) 文件。

### 联系方式

如有任何问题或进一步的开发需求，欢迎联系微信：CoderDreamTech