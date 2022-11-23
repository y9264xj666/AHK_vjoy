# 描述
虚拟/模拟手柄，利用AHK([AutoHotkey](https://www.autohotkey.com))实现的键盘操作vjoy输出手柄按键的脚本程序，能够实现全局的手柄按键输出并且不影响键盘的操作。
目前功能：
+ 仅支持全键盘方式，不支持鼠标（后续有可能加入），使用鼠标的话可参考相关项目的其他仓库，不过非AHK的需要安装[Interception](https://github.com/oblitum/Interception)，需要自行斟酌（我是不想装额外的软件，不然为啥有这个项目）
+ 有功能键的镜像键
+ 已对原神（Genshin）适配，符合键盘操作的基本逻辑，并且有额外的扩展功能：一键大招
+ 通用的手柄模拟


关键字：vjoy, ahk, AutoHotkey, vXbox, vDualSense, vDualDhock4

# 特点
## 优点
- 不需要安装AHK即可运行
- 不需要安装额外软件即可运行
- 可以自定义按键
- 会AHK([AutoHotkey](https://www.autohotkey.com))的可以再编程
- 有占用键盘和不占键盘两种形式，都可对单独的按键设置
- 文件体积小占用低
- 安全无毒
- 可扩展性强，可编辑脚本实现按键连发，按键“宏”等
  
## 缺点：
- 不支持力回馈模拟
- 没有细腻的摇杆模拟
  
# 使用
## 要求
- win10 64位（必须是64位系统，7，8.1，11未测试）
- 需要安装[vjoy](https://github.com/njz3/vJoy)
  
## 使用
1. 去[Releases](https://github.com/y9264xj666/AHK_vjoy/releases)下载编译后的包体,国内连接：[蓝奏](https://9264xj.lanzoue.com/b0d4wt5ba)密码:3rrt|[123pan](https://www.123pan.com/s/2DDrVv-bZDHH)提取码:kc6J
2. 解压到任意目录（最好不要有中文）
3. 打开vjoy的“configure vjoy”，设置为24键，1pov，勾选enable feedback
   ![config](./img/vjoyconfig.png)
4. 打开mystick.exe，就可在托盘上看到 大H 图标
5. 单击图标进入按键设置，设置自己操作顺手的按键
   ![MyStiick Setting](./img/mystick.png)
6. 软件可以正常使用了，可以用vjoy的“monitor vjoy”查看按键情况
7. 打开游戏开玩

## 说明
1. Ctrl + Alt + R 或者 F6 键可以重置vjoy手柄为0状态
2. 二次开发请clone本项目并安装AHK进行本地编辑编译
3. 可以玩原神，不过需要改键位，会有ps的包的，并且需要管理员权限，不然输入不到原神
4. 游戏内按Pause功能键或者F7键，挂起脚本，可以打字
# FAQ
+ Q: 为什么选AHK([AutoHotkey](https://www.autohotkey.com))
  - A: vj有自带的sdk（c/c++，c#）但是按键捕获可能需要额外的辅助软件，并且，用sdk写了明明可以直接写一套（scpvbus），但是已经有完整的项目了。
+ Q:为什么开发
  + A:全局有效，不影响键盘使用，占用低，文件小，可随时二次开发并且二次开发简单，总之特点就是我的需求
+ Q:按键效率方面
  + A:不建议玩对灵敏度要求高的游戏
+ Q:游戏兼容性相关
  + A:通用配置已适配莱莎2，并且对原神有自定的适配


# 相关项目
+ vjoy 驱动[njz3/vjoy](https://github.com/njz3/vJoy)
+ 另一个作者的B0XX游戏控制AHK脚本[FuranHoshi/B0XX-vJoy](https://github.com/FuranHoshi/B0XX-vJoy)，实现了20xx的vjoy版，并且带按键宏
+ 大佬的AHK-vjoy接口[evilC/AHK-CvJoyInterface](https://github.com/evilC/AHK-CvJoyInterface)
+ 大佬的AHK的UCR程序[evilC/UCR](https://github.com/evilC/UCR)，可惜已停止维护
+ 上个项目的C#版[Snoothy/UCR](https://github.com/Snoothy/UCR)
+ vXbox 驱动[shauleiz/vGen](https://github.com/shauleiz/vGen)
+ vBox成品[djlastnight/KeyboardSplitterXbox](https://github.com/djlastnight/KeyboardSplitterXbox)
+ 用于非AHK的使用键盘的Interception[oblitum/Interception](https://github.com/oblitum/Interception)