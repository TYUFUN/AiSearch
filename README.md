# 🚀 aisearch (`ai`)

A lightweight, fast Python CLI tool that uses the Gemini API (via the OpenAI-compatible SDK) to turn your natural language queries into URLs and opens them in your default web browser (or prints them to the terminal).

Works on **Linux** and **Windows**.

---

## ✨ Features

* **Instant Link Generation**: Pass any query in natural language, and the AI resolves it to a direct URL and opens it in your browser.
* **CLI Options & Flags**:
  * `--print` / `-p`: Print the generated URL directly to the terminal without opening a browser tab.
  * `--config` / `-c`: Open or initialize your custom prompt configuration file.
  * `--version` / `-v`: Show current application version.
* **Custom AI Instructions**: Configure custom system prompts (in `CONFIG.cfg`) that are sent alongside every search query.
* **Cross-Platform & Easy Config**: Stores configuration (`.env` and `CONFIG.cfg`) automatically in standard directories (`~/.config/ai` on Linux, `%APPDATA%\ai` on Windows).
* **Automated Setup with Progress Bar**: Includes `setup.sh` (Linux) with download progress indicators and `setup.ps1` (Windows) for quick installation and updates.
* **Standalone Binary**: Ready to run as a single portable executable compiled with PyInstaller.

---

## 🔑 Getting a Gemini API Key

This tool requires a free Google Gemini API key:

1. Go to [Google AI Studio](https://aistudio.google.com/).
2. Sign in with your Google account.
3. Click **Get API key** (or **Create API key in new project**).
4. Copy the generated key.

> The setup script will prompt you to enter this token during installation.

---

## 🛠️ Installation

The setup scripts automatically create the required directories, ask for your API token, and download the latest release binary.

### 🐧 Linux

```bash
curl -LO https://raw.githubusercontent.com/TYUFUN/AiSearch/main/setup.sh
chmod +x setup.sh
./setup.sh
```

* Shows a live download progress bar while downloading the binary.
* Installs the binary to `/usr/local/bin/ai` (requires `sudo`).

### 🪟 Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/TYUFUN/AiSearch/main/setup.ps1 -OutFile setup.ps1
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

* Installs to `%LOCALAPPDATA%\Programs\ai` and adds it to your user `PATH`.
* **Restart your terminal** after installation so the updated `PATH` takes effect.

> Re-running either setup script in the future allows you to automatically check for and update to newer releases.

---

## 🚀 Usage

### 1. Search and Open in Browser
Type `ai` followed by your query:

```bash
ai github user tyufun
```

```bash
ai python typer documentation
```

### 2. Print Link Only (Do Not Open)
Use the `--print` or `-p` flag to output the URL directly to stdout (useful for scripts, piping, or terminal-only workflows):

```bash
ai -p arch linux wiki installation
```

```bash
ai --print latest rust release notes
```

### 3. Custom Config
Use the `--config` or `-c` flag to edit your custom AI instructions:

```bash
ai --config
```

or:

```bash
ai -c
```

This creates (if missing) and opens `CONFIG.cfg` in your default text editor (or Notepad on Windows). You can put custom instructions here (such as preferred documentation languages, search sites, or constraints). If the file starts with `NOT INCLUDED` (the default placeholder), it is ignored.

### 4. Check Version & Help

```bash
ai --version
# or
ai -v
```

```bash
ai --help
```

---

## 🧱 Building from Source

Requirements: **Python 3.11+** and [**`uv`**](https://github.com/astral-sh/uv).

> **Note:** PyInstaller cannot cross-compile. Build Linux binaries on Linux and Windows binaries on Windows.

### Install `uv`

```bash
# Linux
curl -LsSf https://astral.sh/uv/install.sh | sh
```

```powershell
# Windows (PowerShell)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Build Steps

#### 🐧 Linux
```bash
git clone https://github.com/TYUFUN/AiSearch.git
cd AiSearch
uv sync
uv run pyinstaller -F -n ai --clean -y main.py
sudo install -m 755 dist/ai /usr/local/bin/ai
```

#### 🪟 Windows
```powershell
git clone https://github.com/TYUFUN/AiSearch.git
cd AiSearch
uv sync
uv run pyinstaller -F -n ai --clean -y main.py
copy dist\ai.exe .
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

---

## 🧪 Running Without Building

You can run the script directly using `uv` without compiling:

```bash
uv run main.py github user tyufun
```

```bash
uv run main.py -p python official tutorial
```

Make sure your token exists in `~/.config/ai/.env` (Linux) or `%APPDATA%\ai\.env` (Windows):

```env
TOKEN=your_token
```

---

## 📦 Publishing a Release

The setup scripts download from `releases/latest/download/<file>`, so release asset names must match:

| System  | Asset Name |
| :------ | :--------- |
| Linux   | `ai`       |
| Windows | `ai.exe`   |

---

## ❓ Troubleshooting

* **`ai` is not recognized (Windows)**: Open a new terminal after running `setup.ps1`, or verify that `%LOCALAPPDATA%\Programs\ai` is present in your user `PATH`.
* **PowerShell execution policy error**: Run `powershell -ExecutionPolicy Bypass -File .\setup.ps1` or run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once.
* **`Failed to download binary from GitHub Releases`**: Ensure you are online and that the latest release on GitHub has an asset named `ai` or `ai.exe`.
* **`you need to create .env file with TOKEN variable`**: The `.env` file was not created or lacks the `TOKEN=` entry. Re-run `setup.sh` / `setup.ps1` or create it manually.
