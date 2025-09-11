# 🏫 AutoCheckIn / 不上早八 跨平台学习通签到app

**学习通签到客户端，2025 可用**  

主要解决 **纯血鸿蒙** 设备没有原生签到软件的问题。请勿用于代签等行为。  
基于 **Flutter** 开发，可自行编译为 **Android、iOS、macOS、Windows**，甚至纯血鸿蒙版本。  
当前支持扫码签到、普通签到、位置签到，后续将支持 **任意位置签到**、**好友联动签到** 等功能。  
与学习通完全独立，不会顶号，也不显示同一设备重复签到。

---

## 🚀 软件截图

<div align="center">

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/0x676278/XXTAutoCheckIn/blob/SignProxy/image/391757573731_.pic.jpg?raw=false" width="200"><br>
      首页
    </td>
    <td align="center">
      <img src="https://github.com/0x676278/XXTAutoCheckIn/blob/SignProxy/image/401757573732_.pic.jpg?raw=true" width="200"><br>
      签到
    </td>
    <td align="center">
      <img src="https://github.com/0x676278/XXTAutoCheckIn/blob/SignProxy/image/411757573733_.pic.jpg?raw=true" width="200"><br>
      账号管理
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/0x676278/XXTAutoCheckIn/blob/SignProxy/image/421757573733_.pic.jpg?raw=true" width="200"><br>
      我的
    </td>
    <td align="center">
      <img src="https://github.com/0x676278/XXTAutoCheckIn/blob/SignProxy/image/431757573734_.pic.jpg?raw=true" width="200"><br>
      协同
    </td>
    <td></td>
  </tr>
</table>

</div>

---

## 🚀 功能特点

- ✅ 登录 / 登出  
- ✅ 课程加载  
- ✅ 扫码签到（支持滑块验证）  
- ✅ 位置签到（支持滑块验证）  
- ✅ 普通签到（支持滑块验证）  
- ✅ 帮朋友签到  

---

## 📦 版本信息

| 版本 | 日期     | 功能说明 |
|------|---------|---------|
| v0.1 | 2025-09 | 实现基础登录、登出、课程加载及扫码签到（滑块验证同样适用） |
| v0.2 | 2025-09 | 实现位置签到、普通签到 |
| v0.3 | 2025-09 | 实现帮朋友签到 |

---

## 🔗 代码来源 / Credits

- 滑块验证 `validate` 接口来自 [作者A](https://github.com/Misaka-1314) 的项目 [Chaoxing-MiniProgram](https://github.com/Misaka-1314/Chaoxing-MiniProgram?tab=readme-ov-file)  
- HTTP 接口参考自 [作者B](https://github.com/MetaQiu) 的项目 [xxtSignApi](https://github.com/MetaQiu/xxtSignApi)  

---

## ⚙️ 编译与使用

如果你使用的是学在xx，可能会提示“请使用学在xxapp签到”，需要修改 `/lib/chaoxinapi` 中的 User-Agent。  
使用学习通的用户可直接构建或使用我提供的 APK。
