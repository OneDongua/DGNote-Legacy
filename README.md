# 冬瓜便签-Legacy

一个基于 [AndroLua+](https://github.com/nirenr/AndroLua_pro) 的便签软件，支持 WebDAV 同步、 Markdown 预览，自定义主题、Markdown 工具栏等。

作为我编写的第一款“启蒙”软件，代码上存在大量不成熟的写法，包括但不限于：中文变量名与函数名、无格式化、重复冗杂代码、迷惑但能用的逻辑、不一致的代码风格等，仅存档留念，不建议参考。

后期采用 [Aide Lua](https://github.com/AideLua/AideLua) 与 AndroLua+5.0.18 开发，此处为尝试修改 Androlua 源码时基于 AndroLua+ 4.4.2 移植的版本（为解决服务通知问题，后来放弃了），因此运行稳定性未知。

Lua 源码位于[此处](./app/src/main/assets)，可使用 Android Studio 构建项目与打包。

# 开源许可证

本项目：[GPL v3](./LICENSE.txt)

AndroLua+、Androlua：[MIT](./Androlua-LICENSE.txt)

LuaJava：[MIT](./luajava-license.txt)

Lua：[MIT](./lua-license.txt)
