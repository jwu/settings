# Terminal Settings

开发环境配置方案 (Windows, Mac, Linux)。包含了 Alacritty, WezTerm, Neovim, Starship, Zsh/Fish 等工具的配置。

## Windows 配置方案

### 自动配置 (推荐)

此方案会自动下载便携版的工具到 `%USERPROFILE%\bin` 目录，并配置环境变量和配置文件链接。

1. 打开 CMD 或 PowerShell。
2. 克隆此仓库（建议路径）：
   ```cmd
   git clone https://github.com/jwu/settings.git %USERPROFILE%\bin\settings
   ```
3. 进入 `win` 目录：
   ```cmd
   cd %USERPROFILE%\bin\settings\win
   ```
4. 运行安装脚本（自动下载以下工具）：
   ```cmd
   install.bat
   ```

   安装的工具包括：
   - Alacritty v0.16.1 (终端模拟器)
   - Nerd Fonts (FiraMono) v3.4.0 (图标字体)
   - Clink v1.9.9 + clink-completions v0.6.7 (增强 CMD)
   - Starship v1.24.2 (终端提示符)
   - fzf 0.67.0 (模糊搜索)
   - zoxide 0.9.8 (智能目录跳转)
   - fd 10.2.0 (更快的 find)
   - bat 0.24.0 (更好的 cat)
   - ripgrep 15.1.0 (更快的 grep)
   - eza 0.21.0 (更好的 ls)
   - coreutils 0.5.0 (Unix 命令工具集)

5. 运行配置脚本（创建配置文件链接）：
   ```cmd
   config.bat
   ```

### 手动配置

如果你更喜欢手动安装工具，请参考以下步骤：

1. **安装工具**:
   - [Alacritty](https://github.com/alacritty/alacritty/releases) v0.16.1 (终端模拟器)
   - [Nerd Fonts (FiraMono)](https://www.nerdfonts.com/font-downloads) v3.4.0 (图标字体)
   - [Clink](https://github.com/chrisant996/clink) v1.9.9 (增强 CMD 体验)
   - [clink-completions](https://github.com/vladimir-kotikov/clink-completions) v0.6.7 (Clink 自动补全)
   - [Starship](https://starship.rs/) v1.24.2 (终端提示符)
   - [fzf](https://github.com/junegunn/fzf) 0.67.0 (模糊搜索)
   - [zoxide](https://github.com/ajeetdsouza/zoxide) 0.9.8 (智能目录跳转)
   - [fd](https://github.com/sharkdp/fd) 10.2.0 (更快的 find)
   - [bat](https://github.com/sharkdp/bat) 0.24.0 (更好的 cat)
   - [ripgrep](https://github.com/BurntSushi/ripgrep) 15.1.0 (更快的 grep)
   - [eza](https://github.com/eza-community/eza) 0.21.0 (更好的 ls)
   - [coreutils](https://github.com/uutils/coreutils) 0.5.0 (Unix 命令工具集)

2. **配置文件映射**:
   - **Alacritty**: 创建 `%APPDATA%\alacritty\alacritty.toml` 并引用 `win/alacritty.toml`。
   - **WezTerm**: 复制或链接 `common/wezterm.lua` 到 `%USERPROFILE%\.wezterm.lua`。
   - **EZA**: 创建目录 `%USERPROFILE%\.config\eza`。
   - **Neovim**: 复制或链接 `common/neovim.init.lua` 到 `%LOCALAPPDATA%\nvim\init.lua`。
   - **NeoVide**: 复制或链接 `common/neovide.config.toml` 到 `%APPDATA%\neovide\config.toml`。
   - **Clink**: 配置 Clink 加载 `win/clink_scripts` 中的脚本。

---

## Mac 配置方案

### 自动配置 (推荐)

脚本会自动安装 Homebrew 包，配置 Oh My Zsh，并链接配置文件。

1. 打开终端。
2. 克隆此仓库：
   ```bash
   git clone https://github.com/jwu/settings.git ~/bin/settings
   ```
3. 运行安装脚本：
   ```bash
   cd ~/bin/settings/mac
   ./install.sh
   ```

### 手动配置

1. **安装 Homebrew** (如果尚未安装):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **安装软件包**:
   ```bash
   # 命令行工具
   brew install starship zoxide neovim fzf eza fd bat
   # GUI 应用
   brew install --cask wezterm alacritty neovide zed
   ```

3. **配置 Shell (Zsh)**:
   - 安装 [Oh My Zsh](https://ohmyz.sh/)。
   - 安装插件 `zsh-autosuggestions`。
   - 参考或直接使用 `mac/zsh.zshrc` 的内容替换 `~/.zshrc`。

4. **复制/链接配置文件**:
   - `common/wezterm.lua` -> `~/.wezterm.lua`
   - `common/neovim.init.lua` -> `~/.config/nvim/init.lua`
   - `common/neovide.config.toml` -> `~/.config/neovide/config.toml`
   - `mac/starship.toml` -> `~/.config/starship.toml`
   - `mac/alacritty.toml` -> `~/.config/alacritty/alacritty.toml`

---

## Linux 配置方案

### 自动配置
*开发中 (WIP)...*

### 手动配置

1. **安装工具**:
   使用你的发行版包管理器 (apt, pacman, yum 等) 或参考官方文档安装：
   - `alacritty` 或 `wezterm` (终端模拟器)
   - `fish` (推荐 Shell), `starship`, `git`, `neovim`, `fzf`, `eza`, `fd`, `bat`

2. **配置文件映射**:
   - **Fish Shell**: 编辑 `~/.config/fish/config.fish`，添加环境变量初始化。
   - **Alacritty**: 复制 `linux/alacritty.toml` 到 `~/.config/alacritty/alacritty.toml`。
   - **Starship**: 复制 `linux/starship.toml` 到 `~/.config/starship.toml`。
   - **Neovim**: 复制 `common/neovim.init.lua` 到 `~/.config/nvim/init.lua`。

---

## Neovim + NeoVide 手动安装手册

### Windows

1. 安装 [nvim](https://neovim.io/)
1. 安装 [neovide](https://neovide.dev/)
  1. 先运行一下
1. 复制 `init.lua` 到 `c:\Users\${YOUR_NAME}\AppData\Local\nvim\init.lua`
1. 复制 `config.toml` 到 `c:\Users\${YOUR_NAME}\AppData\Roaming\neovide\config.toml`
1. 安装 [lazy.nvim](https://github.com/folke/lazy.nvim)
1. 安装 [rg](https://github.com/BurntSushi/ripgrep)
1. 安装 `fonts`
1. 编译 `nvim-treesitter` parsers
  1. 阅读 [MSVC](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#msvc) session
  1. 安装 [Visual Studio Build Tools](https://visualstudio.microsoft.com/zh-hans/downloads/?q=build+tools+for+visual+studio)
  1. 打开 `x64 Native Tools Command Prompt`
  1. 打开 `neovide`
  1. 输入 `:TSUpdate`
  1. 等待安装结束

### Linux

1. 安装 [nvim](https://neovim.io/)
  1. `sudo cp -r nvim-linux64/bin/ /usr/`
  1. `sudo cp -r nvim-linux64/lib/ /usr/`
  1. `sudo cp -r nvim-linux64/share/ /usr/`
1. 安装 [neovide](https://neovide.dev/)
  1. `sudo cp neovide-linux-x86_64/neovide /usr/bin/`
  1. 更新 ubuntu desktop
    1. `sudo desktop-file-install neovide.desktop`
    1. `sudo update-desktop-database`
1. 复制 `init.lua` 到 `~/.config/nvim`
1. 复制 `config.toml` 到 `~/.config/neovide`
1. 安装 [lazy.nvim](https://github.com/folke/lazy.nvim)
1. 安装 [rg](https://github.com/BurntSushi/ripgrep)
1. 安装 `fonts`
1. 编译 `nvim-treesitter` parsers

---

## Reference

- Terminal
  - [WezTerm](https://wezterm.org/)
  - [alacritty](https://github.com/alacritty/alacritty)
  - [warp](https://www.warp.dev/)
  - Windows
    - [cmder](https://github.com/cmderdev/cmder)
    - [ConEmu](https://github.com/Maximus5/ConEmu)
    - [clink](https://github.com/chrisant996/clink)
      - [clink-completions](https://github.com/vladimir-kotikov/clink-completions)
      - [clink-fzf](https://github.com/chrisant996/clink-fzf)
      - [clink-zoxide](https://github.com/shunsambongi/clink-zoxide)
    - [git for windows](https://github.com/git-for-windows/git)
- Appearance
  - [Nerd Fonts](https://www.nerdfonts.com/)
  - [Dracula Theme](https://draculatheme.com/)
  - [starship](https://starship.rs/)
  - [tmux](https://github.com/tmux/tmux)
    - [zellij](https://zellij.dev/)
  - [vivid](https://github.com/sharkdp/vivid)
- Package Management
  - Windows
    - [winget](https://github.com/microsoft/winget-cli)
  - Mac
    - [homebrew](https://brew.sh/)
      - [zerobrew](https://github.com/lucasgelfond/zerobrew)
- utils (awesome)
  - [rg](https://github.com/BurntSushi/ripgrep)
  - [z](https://github.com/ajeetdsouza/zoxide)
  - [fzf](https://github.com/junegunn/fzf)
    - [skim](https://github.com/lotabout/skim)
  - [fd](https://github.com/sharkdp/fd)
  - [bat](https://github.com/sharkdp/bat)
  - [eza](https://github.com/eza-community/eza)
    - [lsd](https://github.com/Peltoche/lsd)
  - [coreutils](https://github.com/uutils/coreutils)
  - [dust](https://github.com/bootandy/dust)
  - [delta](https://github.com/dandavison/delta)
  - [sd](https://github.com/chmln/sd)
  - [procs](https://github.com/dalance/procs)
  - [glow](https://github.com/charmbracelet/glow)
  - [pass](https://www.passwordstore.org/)
    - [gopass](https://github.com/gopasspw/gopass)
- utils (tui)
  - [yazi](https://github.com/sxyazi/yazi)
  - [trippy](https://github.com/fujiapple852/trippy)
  - [bandwhich](https://github.com/imsnif/bandwhich)
  - [btm](https://github.com/ClementTsang/bottom)
    - [btop](https://github.com/aristocratos/btop)
    - [mactop](https://github.com/metaspartan/mactop)
  - [xplr](https://github.com/sayanarijit/xplr)
  - [impala](https://github.com/pythops/impala)
  - [clashtui](https://github.com/JohanChane/clashtui)
  - [wiremix](https://github.com/tsowell/wiremix)
- utils (network)
  - [xh](https://github.com/ducaale/xh)
  - [rustscan](https://github.com/bee-san/RustScan)
- utils (media)
  - [yt-dlp](https://github.com/yt-dlp/yt-dlp)
  - [mpv](https://github.com/mpv-player/mpv)
  - [ffmpeg](https://www.ffmpeg.org/)
  - [chafa](https://github.com/hpjansson/chafa)
    - [viu](https://github.com/atanunq/viu)
  - [pngpaste](https://github.com/jcsalterego/pngpaste)
- utils (okay)
  - [s](https://github.com/zquestz/s)
  - [fanyi](https://github.com/afc163/fanyi)
- utils (shell)
  - zsh
    - [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
    - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - [nushell](https://github.com/nushell/nushell)
  - [fish](https://fishshell.com/)
