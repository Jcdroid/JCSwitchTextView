# JCSwitchTextView
仿小米应用商店搜索框文字切换的View，基于UIView使用CALayer实现。


![demo gif](https://raw.githubusercontent.com/Jcdroid/JCSwitchTextView/master/demo.gif)

---


## Usage
### Creation of a JCSwitchTextView

```
JCSwitchTextView *switchTextView = [[JCSwitchTextView alloc] initWithFrame:CGRectMake(10, 40, kScreenWidth - 2 * 10, 40) iconImage:[UIImage imageNamed:@"search"] textArray:textArray timeInterval:2.0];
[self.view addSubView:switchTextView];
```



### License
 See [LICENSE](https://github.com/Jcdroid/JCImageSliderView/blob/master/LICENSE) file for details.
