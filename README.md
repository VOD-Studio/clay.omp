# clay.omp

灰阶为底，陶土色点睛的 [Oh My Pi](https://github.com/can1357/oh-my-pi) 深色主题。移植自 [clay.nvim](https://github.com/DefectingCat/clay.nvim)，不是 Neovim 插件，也不会修改终端配色。

主画布沿用终端背景；正文、语法、诊断、Diff 和 Git 状态以灰阶区分。`#d97757` Clay 用于活动焦点、模型名称和模式提示，而不是铺满整个界面。

![Clay 主题：陶土色输入框、模式提示与灰阶 Diff](assets/overview.png)

*交互焦点保留 Clay，增删内容以灰阶和符号区分。图中为 omp gallery 演示数据。*

## 安装

需要支持真彩色的终端和具有自定义 JSON 主题功能的 omp。已在 **omp 18.13.3** 验证；不声称更早版本兼容。

在项目根目录运行：

```bash
mkdir -p ~/.omp/agent/themes
ln -s "$PWD/themes/clay.json" ~/.omp/agent/themes/clay.json
```

不加 `-f`：目标已存在时停止，避免覆盖其他主题。链接安装会实时使用项目文件，项目所在磁盘必须保持挂载。也可以用 `cp themes/clay.json ~/.omp/agent/themes/clay.json` 安装独立副本；此后需要手动同步更新。

在 omp 中输入 `/settings`，选择 **Appearance → Dark Theme → clay**。或从 shell 设置后重新启动 omp：

```bash
omp config set theme.dark clay
```

仅修改深色主题槽，浅色槽不变。omp 按终端背景明暗选择槽位，Clay 本身没有浅色变体。

命名 profile 的目录为 `~/.omp/profiles/<name>/agent/themes/`；默认 profile 设置了 `PI_CODING_AGENT_DIR` 时，使用 `$PI_CODING_AGENT_DIR/themes/`。需要按实际 profile 安装和选择主题。

恢复本机原先的深色主题：

```bash
omp config set theme.dark titanium
```

## 配色与映射

[`themes/clay.json`](themes/clay.json) 是唯一的主题源文件。`vars` 保留 clay.nvim 原始色板命名，`colors` 映射到 omp 语义字段。

| Clay 色板 | 色值 | 用途 |
| --- | --- | --- |
| `bg` | `#111315` | HTML 导出画布；终端主画布不强制使用它 |
| `float` / `cursorline` | `#1a1a1a` / `#191919` | 工具／自定义消息底色、用户消息底色 |
| `selection` / `statusline` | `#2a2a2a` / `#242424` | 选中项、非透明状态栏 |
| `border` / `float_border` | `#2a2a2a` / `#444444` | 静态分隔、工具框线 |
| `fg` / `bright` | `#cccccc` / `#dddddd` | 正文、标题与错误提示 |
| `secondary` / `muted` | `#aaaaaa` / `#8e8e8e` | 工具输出、次级信息与语法 |
| `comment` / `gutter` | `#7a7a7a` / `#555555` | 注释、弱化信息与低档思考边框 |
| `clay` | `#d97757` | 活动焦点、模型名称、模式与高档思考边框 |

正文同时设置 `text` 和 `assistantMessageText`：前者不控制助手的普通段落。成功、警告、错误分别映射为正文灰、次级灰和亮灰；Diff 新增／删除使用亮灰／次级灰，通过 `+` / `-` 及状态文字辨别，不使用红绿编码。

Markdown 标题为亮灰，链接、行内代码为次级灰；代码块采用与 clay.nvim 相同的灰阶语法。所有思考档位、Bash/Python 模式和状态栏字段均提供配色，不更换用户的图标、旋转动画或输入框布局。

### 与 clay.nvim 的区别和限制

- **函数定义与调用**：omp 主题只提供一个 `syntaxFunction`，因此统一使用灰色 `#8e8e8e`。这保留 `restrained` 的克制感，但不复制其“定义陶土色、调用灰色”的细分。
- **透明背景**：指主画布沿用终端默认背景，不代表开启窗口透明度；消息、工具、选区仍有实色背景。`statusLine.transparent` 是独立的 omp 设置，开启时覆盖本主题的状态栏底色。
- **语义辨识**：灰阶错误、警告和 Diff 是有意的设计取舍，需要结合图标、标签和增删符号阅读。
- **主题边界**：品牌图标、终端 emoji、会话强调色、扩展自带 ANSI 颜色等可能不使用主题 token；JSON 不能保证界面所有像素都只有灰色和 Clay。`statusLine.sessionAccent` 可能覆盖编辑框／状态栏的主题强调色。
- **Neovim 特性**：斜体注释、Tree-sitter/LSP 定义标记、下划线等并非 omp 颜色 JSON 可独立配置的属性。

## 修改

修改 `vars` 中的色值即可同步调整引用它的颜色。自定义主题必须包含 omp 所需的完整字段；不要把文件精简为只含覆盖项的片段。

omp 交互模式会监听当前自定义主题文件并重载；新增文件后先在设置中选择一次。加载失败时检查 omp 的错误提示，不要把内置回退配色误认成 Clay。主题名称与内置主题冲突时，omp 优先加载内置版本。

## 预览与验证

![Clay 主题：Read 工具中的灰阶代码、行号与输出边框](assets/code.png)

截图来自 **omp 18.13.3 gallery** 的真实 ANSI 输出，使用 xterm.js 6.0.0、JetBrainsMono Nerd Font 和 Chromium 以 2× 分辨率捕获。仅裁剪 gallery 分节标题、组合 Edit 与输入框预览并添加展示外框；工具内容和配色未重绘，不含私人会话或凭据。截图主画布为 `#111315`，实际使用时沿用终端背景。

需要 Bash、Make 和已安装的 omp，不需要 Node/Bun 依赖或模型请求：

```bash
make preview
make preview ARGS='--tool edit --width 100'
make preview ARGS='--tool read --state done --width 92'
make preview ARGS='--tool edit --state done --width 92'
make preview ARGS='--composer claude --width 92'
make preview ARGS='--surface composer'
make preview ARGS='--surface segment'
```

`scripts/preview.sh` 创建临时 agent 目录，链接项目主题并将明暗槽都设为 Clay，然后运行真实的 `omp gallery`。脚本退出时删除临时目录，不安装主题、不改全局设置、不保存会话，也不读取用户模型凭据。预览同时设置两个槽仅用于稳定呈现深色主题，不代表提供浅色支持。

如果 `omp` 是会联网更新的启动包装器，可显式指定已安装的二进制：

```bash
OMP=/path/to/installed/omp make preview ARGS='--tool edit'
```

默认 gallery 覆盖工具状态、八种输入框布局和状态栏组件。预览只是实际 renderer 的视觉检查，不是自动测试：omp 18.13.3 遇到缺少字段的自定义主题可能回退到内置配色且仍以 0 退出，不能只凭退出码判断加载成功。应确认出现 `#d97757` 陶土强调色和灰阶 Diff，再在实际会话检查 Markdown 与正文可读性。

首次移植已检查完整的 66 个必需颜色字段及变量引用，运行全部 gallery，并捕获真实 ANSI 验证 Clay、亮灰新增和次级灰删除。没有修改 omp 的品牌色、会话强调色或其他独立设置。

## 来源

色板与设计语义来自同级 `clay.nvim/lua/clay/palette.lua` 和 `highlights.lua`。此项目维护一份独立的 JSON 映射，不在运行时读取 Neovim 仓库；上游色板变化后应显式同步并检查预览。
