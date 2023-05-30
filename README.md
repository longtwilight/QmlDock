# QmlDock
纯QML实现的Dock悬浮、停靠、拖动功能

## 介绍
这是一个使用纯qml实现的Dock组件，它支持停靠、浮动、窗体分离、窗体独立、大小调整等功能。开源它的目的是为了寻求更多的功能(如侧边栏)、更好的结构设计、更通用的应用场景以及更好的稳定性和易用性。欢迎批评和指正。

## 截图
![image](https://github.com/longtwilight/QmlDock/assets/59431315/d3e4489e-acae-43b4-a266-dbd13878a879)
![image](https://github.com/longtwilight/QmlDock/assets/59431315/96c4eadc-b9b7-47ce-916b-e3fe31055650)
![image](https://github.com/longtwilight/QmlDock/assets/59431315/bf16a0d5-9190-48e4-8f37-ac9749484d0d)


## 环境
	Qt版本：Qt6.2.4
	编译器：mingw、msvc、gcc均支持

## 参数说明
关键字 | 说明 | 取值
-------- | ----- | -----
name  | Dock窗体的标题| 字符串
width / height | Dock窗体宽度 / 高度 | 整数
dockHome  | 为了实现边缘的停靠，所有Dock窗体必须声明在DockHome类中，且该字段需声明为DockHome的id | DockHome的id
closable | Dock窗体是否允许关闭 | true / false
splittable | Dock窗体是否允许从主窗体中独立出来成为单独窗体 | true / false
hide | Dock窗体默认是否显示，相当于visible属性，但visible与stacklayout视图有冲突，所以在此基础上多封装了一层 | true / false
myDockState | Dock在DockHome中的默认状态，与anchors属性相似，但使用anchors属性会存在问题 | MyDockBase.DockState: Fill、Center、Top、Left、Right、Bottom、Float、Tab
dockTo | 窗体初始化时的停靠对象 | 其他Dock窗体的id
direction | 窗体初始化时的停靠方向 | Dock.Direction: Center、Left、Top、Right、Bottom



## API说明
方法名 | 参数 | 说明
-------- | ----- | -----
focusDock() | null | 使Dock窗体获得焦点(标题栏变成金黄色渐变色)
doDockTo(target,direction) | target:待停靠的目标对象；direction：停靠方向 | 用于js代码中动态停靠窗体
releaseDock() | null | 取消停靠
splitToWindow() | null | 将Dock窗体分离成为独立窗体
returnToDockHome() | null | 将分离出去的Dock独立窗体收回到DockHome中
