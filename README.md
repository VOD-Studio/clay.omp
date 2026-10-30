# clay.omp

灰阶为底，陶土色点睛的 [Oh My Pi](https://github.com/can1357/oh-my-pi) 主题，提供暗色 `clay` 与亮色 `clay-light` 两个变体。移植自 [clay.nvim](https://github.com/DefectingCat/clay.nvim)，不是 Neovim 插件，也不会修改终端配色。

主画布沿用终端背景；正文、语法、诊断、Diff 和 Git 状态以灰阶区分。`#d97757` Clay 用于活动焦点、模型名称和模式提示，而不是铺满整个界面。

![Clay 主题：陶土色输入框、模式提示与灰阶 Diff](assets/overview.png)

*交互焦点保留 Clay，增删内容以灰阶和符号区分。图中为 omp gallery 演示数据，使用更新前的暗色色板，仅示意布局与层级。*

## 安装

需要支持真彩色的终端和具有自定义 JSON 主题功能的 omp。已在 **omp 18.14.0** 验证；不声称更早版本兼容。

在项目根目录运行：

```bash
mkdir -p ~/.omp/agent/themes
ln -s "$PWD/themes/clay.json" ~/.omp/agent/themes/clay.json
ln -s "$PWD/themes/clay-light.json" ~/.omp/agent/themes/clay-light.json
```

不加 `-f`：目标已存在时停止，避免覆盖其他主题。链接安装会实时使用项目文件，项目所在磁盘必须保持挂载。也可以用 `cp themes/clay.json themes/clay-light.json ~/.omp/agent/themes/` 安装独立副本；此后需要手动同步更新。只用一个变体时，只安装对应文件即可。

在 omp 中输入 `/settings`，选择 **Appearance → Dark Theme → clay** 和 **Light Theme → clay-light**。或从 shell 设置后重新启动 omp：

```bash
omp config set theme.dark clay
omp config set theme.light clay-light
```

omp 按终端背景明暗选择槽位：暗色终端使用 `clay`，亮色终端使用 `clay-light`。两个槽可以分别设置，只设置其中一个时另一个保持原样。

命名 profile 的目录为 `~/.omp/profiles/<name>/agent/themes/`；默认 profile 设置了 `PI_CODING_AGENT_DIR` 时，使用 `$PI_CODING_AGENT_DIR/themes/`。需要按实际 profile 安装和选择主题。

恢复本机原先的主题（以下为示例，换成你原来的主题名）：

```bash
omp config set theme.dark titanium
omp config set theme.light light
```

## 配色与映射

[`themes/clay.json`](themes/clay.json)（暗色）和 [`themes/clay-light.json`](themes/clay-light.json)（亮色）是主题源文件。两者的 `vars` 保留 clay.nvim 色板的完整键名，`colors` 与 `export` 完全相同，只有 `name` 和色值不同。色值与语义以 clay.nvim 的 [Clay 设计规范](https://github.com/DefectingCat/clay.nvim/blob/master/design/clay-design-system.md)（`design/clay-design-system.md`）和 `lua/clay/palette.lua` 为准。

亮色变体是暗色的镜像而不是反相：每档文字与底色的对比度相同，表面向深处叠加。键名按角色命名，`bright` 在亮色中是最深的字。

| Clay 色板 | 暗色 | 亮色 | omp 中的用途 |
| --- | --- | --- | --- |
| `bg` | `#121212` | `#f6f6f6` | HTML 导出画布；终端主画布不强制使用它 |
| `float` | `#1a1a1a` | `#ebebeb` | 工具块、自定义消息底色、导出卡片 |
| `cursorline` | `#1e1e1e` | `#e5e5e5` | 用户消息底色、导出信息块 |
| `diff_delete` | `#181818` | `#eeeeee` | 失败工具块底色 |
| `statusline` | `#242424` | `#dddddd` | 非透明状态栏 |
| `selection` | `#363636` | `#c6c6c6` | 选中项 |
| `border` / `float_border` | `#2a2a2a` / `#444444` | `#d5d5d5` / `#b5b5b5` | 静态分隔、工具框线与引用边框 |
| `bright` | `#e6e6e6` | `#202020` | 标题、工具标题、错误、Diff 新增、已暂存 |
| `fg` | `#cccccc` | `#333333` | 正文、变量、成功、路径 |
| `secondary` | `#aaaaaa` | `#4b4b4b` | 工具输出、类型与数字、警告、工作区有改动 |
| `string` | `#b0978e` | `#665048` | 字符串、行内代码与代码块 |
| `muted` | `#8e8e8e` | `#616161` | 关键字、函数、Diff 删除、未跟踪文件 |
| `comment` | `#7a7a7a` | `#737373` | 注释、思考文字、Diff 上下文、链接地址 |
| `subtle` | `#686868` | `#868686` | 标点、运算符、列表符号 |
| `gutter` | `#555555` | `#9d9d9d` | 关闭思考时的边框 |
| `clay` | `#d97757` | `#d97757` | 活动焦点、模型名称、模式与高档思考边框 |

`sidebar`、`search`、`reference`、`diff_add`、`diff_change`、`shadow` 也保留在 `vars` 中以便与上游逐键对照，但 omp 主题没有对应角色的字段（没有搜索匹配、引用高亮、整行 Diff 背景或阴影槽位），因此未被引用。

正文同时设置 `text` 和 `assistantMessageText`：前者不控制助手的普通段落。状态按设计规范的亮度阶梯区分：错误亮灰、警告次级灰、成功正文灰；Diff 新增亮灰、删除 `muted`、上下文注释灰，通过 `+` / `-` 及状态文字辨别，不使用红绿编码。状态栏的 Git 状态沿用同一阶梯：已暂存亮灰、工作区改动与“有改动”标记次级灰、未跟踪 `muted`、干净为注释灰。

Markdown 标题为亮灰，链接为次级灰，行内代码和代码块正文为 `string` 暖灰（与 clay.nvim 的 `@markup.raw` 一致）；代码块高亮采用与 clay.nvim 相同的灰阶语法。所有思考档位、Bash/Python 模式和状态栏字段均提供配色，不更换用户的图标、旋转动画或输入框布局。

### 与 clay.nvim 的区别和限制

- **函数定义与调用**：omp 主题只提供一个 `syntaxFunction`，因此统一使用 `muted`（暗色 `#8e8e8e`，亮色 `#616161`），即 `restrained` 模式中函数调用的颜色，但不复制其“定义陶土色、调用灰色”的细分。
- **亮色 Clay 对比度**：亮色变体沿用品牌色 `#d97757`，作为文字与底色的对比度只有 2.9。这是设计规范接受的品牌取舍；Clay 只出现在焦点、模型名称和模式提示上。
- **透明背景**：指主画布沿用终端默认背景，不代表开启窗口透明度；消息、工具、选区仍有实色背景。`statusLine.transparent` 是独立的 omp 设置，开启时覆盖本主题的状态栏底色。
- **语义辨识**：灰阶错误、警告和 Diff 是有意的设计取舍，需要结合图标、标签和增删符号阅读。
- **主题边界**：品牌图标、终端 emoji、会话强调色、扩展自带 ANSI 颜色等可能不使用主题 token；JSON 不能保证界面所有像素都只有灰色和 Clay。实际 gallery 中两个变体都仍可见少量固定的非主题色，例如 Python 图标的 `#3776ab` 和状态栏上下文容量数字（如 `200K`）的 `#a36f5f`。`statusLine.sessionAccent` 可能覆盖编辑框／状态栏的主题强调色。
- **终端调色板**：omp 18.14.0 的主题格式还支持可选的 `terminal` 字段（终端前景、背景与 16 色 ANSI）。本主题不设置它，终端配色仍由终端自身决定。
- **Neovim 特性**：斜体注释、Tree-sitter/LSP 定义标记、下划线等并非 omp 颜色 JSON 可独立配置的属性。

## 修改

修改 `vars` 中的色值即可同步调整引用它的颜色。两个变体的 `colors` 与 `export` 应保持完全相同，只在 `vars` 中区分明暗。自定义主题必须包含 omp 所需的完整字段；不要把文件精简为只含覆盖项的片段。

omp 交互模式会监听当前自定义主题文件并重载；新增文件后先在设置中选择一次。加载失败时检查 omp 的错误提示，不要把内置回退配色误认成 Clay。主题名称与内置主题冲突时，omp 优先加载内置版本。

## 预览与验证

![Clay 主题：Read 工具中的灰阶代码、行号与输出边框](assets/code.png)

截图来自 **omp 18.13.3 gallery** 的真实 ANSI 输出，使用 xterm.js 6.0.0、JetBrainsMono Nerd Font 和 Chromium 以 2× 分辨率捕获。仅裁剪 gallery 分节标题、组合 Edit 与输入框预览并添加展示外框；工具内容和配色未重绘，不含私人会话或凭据。截图使用更新前的暗色色板（主画布 `#111315`、字符串与删除行颜色已变化），尚未重新捕获，也没有亮色截图；实际使用时主画布沿用终端背景。

需要 Bash、Make 和已安装的 omp，不需要 Node/Bun 依赖或模型请求：

```bash
make preview
make preview ARGS='--tool edit --width 100'
make preview ARGS='--tool read --state done --width 92'
make preview ARGS='--tool edit --state done --width 92'
make preview ARGS='--composer claude --width 92'
make preview ARGS='--surface composer'
make preview ARGS='--surface segment'
CLAY_VARIANT=light make preview
CLAY_VARIANT=light make preview ARGS='--tool edit --width 100'
```

`CLAY_VARIANT` 选择变体：默认 `dark` 预览 `clay`，`light` 预览 `clay-light`，其他值报错退出。`scripts/preview.sh` 创建临时 agent 目录，只链接所选变体的主题文件并将明暗槽都设为它，然后运行真实的 `omp gallery`。脚本退出时删除临时目录，不安装主题、不改全局设置、不保存会话，也不读取用户模型凭据。两个槽设为同一主题是为了不受当前终端明暗影响；gallery 不绘制主画布，预览亮色时应在亮色终端中查看。

如果 `omp` 是会联网更新的启动包装器，可显式指定已安装的二进制：

```bash
OMP=/path/to/installed/omp make preview ARGS='--tool edit'
```

默认 gallery 覆盖工具状态、八种输入框布局和状态栏组件。预览只是实际 renderer 的视觉检查，不是自动测试：omp 18.14.0 遇到缺少字段的自定义主题仍会回退到内置配色并以 0 退出，不能只凭退出码判断加载成功。应确认出现 `#d97757` 陶土强调色和灰阶 Diff，再在实际会话检查 Markdown 与正文可读性。

两个变体均已在 omp 18.14.0 检查完整的 66 个必需颜色字段（另含可选的 `assistantMessageText`、`thinkingMax`）及变量引用，运行全部 gallery，并捕获真实 ANSI 验证 Clay、正文、字符串和 Diff 增删颜色。没有修改 omp 的品牌色、会话强调色或其他独立设置。

## 来源

色板与设计语义来自同级 clay.nvim 的 `design/clay-design-system.md`、`lua/clay/palette.lua` 和 `highlights.lua`。此项目维护独立的 JSON 映射，不在运行时读取 Neovim 仓库；上游色板变化后应显式同步两个变体并检查预览。
