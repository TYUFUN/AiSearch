# 🚀 aisearch (`ai`)

A lightweight, fast Python CLI tool that uses the Gemini API (via the OpenAI-compatible SDK) to turn your natural language queries into URLs and opens them in your default web browser.

Works on **Linux** and **Windows**.

## ✨ Features

* **Instant link generation**: pass any prompt, and the AI returns a direct URL that opens in a new browser tab.
* **Cross-platform**: Linux and Windows.
* **Custom instructions**: `ai config` opens a file whose contents are sent to the AI along with every query.
* **Simple configuration**: your API token is stored in `~/.config/ai/.env` on Linux and in `%APPDATA%\ai\.env` on Windows (usually `C:\Users\<you>\AppData\Roaming\ai\.env`).
* **Standalone binary**: packaged into a single portable executable with PyInstaller.
* **Automated setup**: `setup.sh` (Linux) and `setup.ps1` (Windows) create the config directory, ask for your token, download the latest release and install it.

## 🔑 Getting a Gemini API Key

This tool requires a free Google Gemini API key:

1. Go to [Google AI Studio](https://aistudio.google.com/).
2. Sign in with your Google account.
3. Click **Get API key** (or **Create API key in new project**).
4. Copy the generated key.

> The setup script will prompt you to paste this token during installation.

## 🛠️ Installation

The setup scripts download the latest binary from the [Releases](https://github.com/TYUFUN/AiSearch/releases) page, so you only need the script itself.

### 🐧 Linux

```bash
curl -LO https://raw.githubusercontent.com/TYUFUN/AiSearch/main/setup.sh
chmod +x setup.sh
./setup.sh
```

The binary is installed to `/usr/local/bin/ai` (requires `sudo`).

### 🪟 Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/TYUFUN/AiSearch/main/setup.ps1 -OutFile setup.ps1
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

The binary is installed to `%LOCALAPPDATA%\Programs\ai` and that folder is added to your user `PATH` (no administrator rights needed). **Open a new terminal window afterwards** so the updated `PATH` is picked up.

In both cases, enter your Gemini API token when prompted. Running the script again later asks whether to update to the latest release.

---

## 🚀 Usage

Run `ai` from anywhere in your terminal followed by your query:

```bash
ai github user tyufun
```

```bash
ai python typer documentation
```

### Custom config

```bash
ai config
```

Creates (if missing) and opens `CONFIG.cfg` in the config directory. Whatever text you put there is sent to the AI with every query, e.g. your preferred search sites or language. Delete the placeholder text first. If the file still starts with `NOT INCLUDED`, it is ignored.

---

## 🧱 Building from Source

Requirements: Python 3.11+ and [`uv`](https://github.com/astral-sh/uv).

> **Note:** PyInstaller cannot cross-compile. Build the Linux binary on Linux and the Windows `.exe` on Windows.

Installing `uv`:

```bash
# Linux
curl -LsSf https://astral.sh/uv/install.sh | sh
```

```powershell
# Windows (PowerShell)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 🪟 Windows

```powershell
git clone https://github.com/TYUFUN/AiSearch.git
cd AiSearch
uv sync
uv run pyinstaller -F -n ai --clean -y main.py
```

The result is `dist\ai.exe`. To install your own build, copy it next to `setup.ps1` and run the script. If `ai.exe` is in the same folder as the script, it installs that file instead of downloading from Releases:

```powershell
copy dist\ai.exe .
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

### 🐧 Linux

```bash
git clone https://github.com/TYUFUN/AiSearch.git
cd AiSearch
uv sync
uv run pyinstaller -F -n ai --clean -y main.py
sudo install -m 755 dist/ai /usr/local/bin/ai
```

You still need the token file, see the next section.

---

## 🧪 Running Without Building

You don't have to build a binary. After `uv sync`, run the script directly from the project directory (same command on Linux and Windows):

```bash
uv run main.py github user tyufun
```

You still need the token file. Create `~/.config/ai/.env` (Windows: `%APPDATA%\ai\.env`) with this content:

```
TOKEN=your_token
```

---

## 📦 Publishing a Release

The setup scripts download from `releases/latest/download/<file>`, so the asset names must match exactly:

| System  | Asset name |
| ------- | ---------- |
| Linux   | `ai`       |
| Windows | `ai.exe`   |

Build each binary on its own system (see above), then attach both files to a new GitHub Release.

---

## ❓ Troubleshooting

* **`ai` is not recognized (Windows)**: open a *new* terminal after running `setup.ps1`, or check that `%LOCALAPPDATA%\Programs\ai` is in your `PATH`.
* **PowerShell blocks the script**: use the `-ExecutionPolicy Bypass` command shown above, or run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once.
* **`Failed to download binary from GitHub Releases`**: the latest release has no asset with the exact name `ai` / `ai.exe`, or you are offline.
* **`Could not write ...\ai.exe` during an update (Windows)**: the old `ai.exe` is still running. Close it and run the script again.
* **Windows SmartScreen / antivirus flags `ai.exe`**: unsigned PyInstaller executables are sometimes reported as suspicious. Choose *More info → Run anyway*, or build it yourself from source.
* **`ai config` asks which app to open the file with (Windows)**: `.cfg` has no default program. Pick a text editor (e.g. Notepad) once and tick *Always use this app*.
* **`you need to create .env file with TOKEN variable`**: the config file is missing. Re-run the setup script or create the file manually as shown above.
