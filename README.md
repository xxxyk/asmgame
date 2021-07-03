# LosingCtrl

## 简介

该项目为“编译原理与接口设计”课程的小组作业。

使用[acllib库](https://github.com/wengkai/ACLLib)完成了简单小游戏。

游戏创意，素材，大部分关卡设计来源自GMTK Game Jam 2020参赛作品Losing CTRL

Link：[作品页面](https://itch.io/jam/gmtk-2020/rate/695591)|[游戏页面](https://indieburg.itch.io/losing-control)

## 程序结构

### 程序框架图

![程序框架图](https://i.loli.net/2021/07/03/SPYoKgMwLsQZ7hi.png)

### main.asm

主程序，负责创建窗口，初始化绘图函数，注册鼠标键盘事件等

### view.asm

绘制具体界面，包括开始界面，选关界面，游戏界面

### kbcontrol.asm

键盘输入控制。包括；上下左右移动，死亡及胜利处理，重新开始，ctrl+C，ctrl+V实现

### mscontrol.asm

鼠标输入控制。包括；框选方块，不同界面内按键位置的点击处理

### constant.inc

需要用到的常量规定

### 总体运行流程图

![总体运行流程图](https://i.loli.net/2021/07/03/FekqvfXNnymDAws.png)


