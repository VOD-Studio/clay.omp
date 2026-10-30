# Changelog

## Unreleased

### Added

- 新增亮色变体 `themes/clay-light.json`（主题名 `clay-light`），与暗色共用完全相同的 `colors`／`export` 映射，只有 `vars` 色值不同。
- `make preview` 支持 `CLAY_VARIANT=light` 预览亮色变体，默认仍为暗色；仍使用临时 agent 目录，不修改用户配置。
- README 新增两张 2× 主题预览：Edit／输入框与 Read 灰阶代码输出。
- 注明截图使用真实 omp gallery ANSI 输出、字体与捕获方式，补充对应预览命令。

### Changed

- 按 clay.nvim 的 Clay 设计规范同步暗色色板：底色 `#121212`、当前行 `#1e1e1e`、选区 `#363636`、`bright` `#e6e6e6`、`subtle` `#686868`、Diff 背景 `#2d2d2d`／`#181818`，并补齐 `string`、`search`、`reference`、`diff_change`、`shadow` 等全部键名。
- 字符串、行内代码与代码块改用 `string` 暖灰；Diff 删除从次级灰改为 `muted`，与新增亮灰、修改次级灰形成三档。
- 状态栏 Git“有改动”标记从亮灰改为次级灰，与已暂存（亮灰）、未跟踪（`muted`）对应新增／修改／删除阶梯；Markdown 列表符号改为标点色 `subtle`。
- README 记录两个变体的安装与 `theme.dark`／`theme.light` 设置，删除“没有浅色变体”的说明，配色表改为暗色／亮色两列，并注明设计规范为来源。
- 现有截图仍为更新前的暗色色板，尚未重新捕获。

### Verified

- omp 18.14.0：两个文件均包含主题校验要求的 66 个颜色字段（另含可选的 `assistantMessageText`、`thinkingMax`），所有 `colors`／`export` 值都引用已有变量。
- 两个变体的完整 gallery 与 Edit 预览均以真实 ANSI 渲染，输出包含 Clay `#d97757` 以及各自的正文、字符串、新增与删除颜色。
- omp 18.14.0 遇到缺少字段的主题仍会回退到内置配色并以 0 退出。

## 0.1.0 — 2026-10-30

### Added

- 移植 clay.nvim 灰阶色板与 `#d97757` 陶土强调色，提供完整 omp 自定义主题。
- 覆盖正文、Markdown、语法、消息块、工具状态、Diff、思考档位、模式与状态栏配色。
- 提供深色 HTML 导出画布配色；终端主画布沿用默认背景。
- 记录链接／副本安装、profile 路径、深色槽选择、恢复方法及与 Neovim 的差异。
- 提供隔离的 `make preview` 命令，直接调用真实 omp gallery，不修改用户配置。

### Verified

- omp 18.13.3 实际 gallery 渲染：工具生命周期与 Diff、八种输入框布局、状态栏组件。
- 实际 ANSI 输出包含 Clay 强调色与灰阶新增／删除颜色。
