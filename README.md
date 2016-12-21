# embedded-experiments
assignments for the course _Embedded System and the Software Tools_

_34100344：计算机与网络体系结构（2）之嵌入式系统及其软件工具_
* 2016-2017学年秋季学期
* 樊海宁，清华大学软件学院

### 51单片机大作业
> 了解小嵌入式系统的开发流程。

> 在试验板上实现包含中断服务程序的汇编小程序，程序内容自己依据板上资源自定，要求有保护现场的代码。

> 例如：主程序对数码管循环加1实现两位计数。中断服务程序响应外部按键，触发后对另外一个数码管计数，中断服务程序在人看来不影响主程序的计数。

> 实验要求

> * 编写汇编程序，通过按键实现中断功能。
> * 按键激活中断，执行中断代码。
> * 要求要在开发板已有资源体现出主程序与中断程序同时运行。
 
> 一种参考实现方案：主程序中运行不断控制“数码管亮灭”，同时，按键激活中断，使“发光二极管”亮灭切换。

### ARM大作业
> 了解大点的、需要嵌入式OS的系统的开发流程。

> 阅读eCos相关文献，了解其中断服务程序编程模式，在试验板上每人实现包含中断服务程序的汇编或C小程序，程序内容自己依据板上资源自定。 

* [eCos Interrupt Model](http://ecos.sourceware.org/docs-1.3.1/ref/ecos-ref.c.html)
* [Interrupt Handling](http://ecos.sourceware.org/docs-2.0/ref/kernel-interrupts.html)
