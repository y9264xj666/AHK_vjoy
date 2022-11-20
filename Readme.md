# 描述
莱莎1steam版，官方接入了模拟手柄并且可以使用鼠标，但是没有手柄的话，进游戏会一卡一卡的，有了vjoy即使不用，也视为接入了手柄不再卡顿了。到了莱莎2官方实现了自动识别操作方式，手柄优先级最高，有了vjoy就会自动变成手柄操作模式，键鼠完全失效。也就是说，有了vjoy，流畅玩莱莎1，却不能玩莱莎2，在不影响vjoy的情况下，畅玩两代只能把vjoy用起来了。

利用AHK([AutoHotkey](https://www.autohotkey.com))实现的键盘对vjoy输出的脚本程序，能够实现全局的手柄按键输出并且不影响键盘的操作，目前仅支持全键盘方式，不支持鼠标，使用鼠标的话可参考相关项目的UCR程序，不过需要安装[Interception](https://github.com/oblitum/Interception)

# 环境要求
- win10 64位（必须是64系统，7，8，11未测试）
- 需要安装[vjoy](https://github.com/njz3/vJoy)

# 特点
- 不需要安装AHK即可运行
- 不需要安装额外软件即可运行
- 可以自定义按键
- 会AHK([AutoHotkey](https://www.autohotkey.com))的可以再编程
- 有占用键盘和不占键盘两种形式，都可对单独的按键设置
- 文件体积小占用低
- 安全无毒

# 相关项目
+ vjoy 驱动[njz3/vjoy](https://github.com/njz3/vJoy)
+ 另一个作者的B0XX游戏控制AHK脚本[FuranHoshi/B0XX-vJoy](https://github.com/FuranHoshi/B0XX-vJoy)
+ 大佬的AHK-vjoy接口[evilC/AHK-CvJoyInterface](https://github.com/evilC/AHK-CvJoyInterface)
+ 更高级自定义按键的ahk-UCR程序的C#版[Snoothy/UCR](https://github.com/Snoothy/UCR)