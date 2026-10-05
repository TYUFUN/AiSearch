# 🚀 aisearch (`ai`)

A lightweight, fast Python CLI tool that uses the Gemini API (via the OpenAI-compatible SDK) to convert your natural language queries into URLs and automatically opens them in your default web browser.

Works on **Linux** and **Windows**.

## ✨ Features

* **Instant Link Generation**: Pass any prompt, and the AI returns a direct URL that opens automatically in a new browser tab.
* **Cross-platform**: Runs on Linux and Windows.
* **Simple Configuration**: Your API token is stored in `~/.config/ai/.env` on Linux and in `%APPDATA%\ai\.env` on Windows (usually `C:\Users\<you>\AppData\Roaming\ai\.env`).
* **Standalone Binary**: Packaged into a single portable executable using PyInstaller.
* **Automated Setup**: `setup.sh` (Linux) and `setup.ps1` (Windows) handle directory creation, token prompting, and installation.

## 🔑 Getting a Gemini API Key

This tool requires a free Google Gemini API key:

1. Go to [Google AI Studio](https://aistudio.google.com/).
2. Sign in with your Google account.
3. Click on **Get API key** (or **Create API key in new project**).
4. Copy the generated API key.

> **Note:** The setup script will automatically prompt you to paste this token during installation.

## 🛠️ Installation

### Quick Install (Pre-compiled Binary)

Download the latest binary and the setup script for your system from the [Releases](https://github.com/tyufun/aisearch/releases) page, and put both files in one directory.

#### 🐧 Linux

Files: `ai` + `setup.sh`

```bash
chmod +x setup.sh
./setup.sh
```

The script installs the binary to `/usr/local/bin` (requires `sudo`).

#### 🪟 Windows

Files: `ai.exe` + `setup.ps1`

Open PowerShell in that directory and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

The script installs `ai.exe` to `%LOCALAPPDATA%\Programs\ai` and adds that folder to your user `PATH` (no administrator rights needed). **Open a new terminal window afterwards** so the updated `PATH` is picked up.

In both cases, enter your Gemini API token when prompted.

---

## 🚀 Usage

Run `ai` from anywhere in your terminal followed by your query:

```bash
ai github user tyufun
```

```bash
ai python typer documentation
```

---

## 🛠️ Building from Source

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

### 🐧 Linux

```bash
git clone https://github.com/tyufun/aisearch.git
cd aisearch
uv sync
uv run pyinstaller -F -n ai --clean -y main.py
cp dist/ai .
chmod +x setup.sh
./setup.sh
```

### 🪟 Windows

```powershell
git clone https://github.com/tyufun/aisearch.git
cd aisearch
uv sync
uv run pyinstaller -F -n ai --clean -y main.py
copy dist\ai.exe .
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

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

## ❓ Troubleshooting

* **`ai` is not recognized (Windows)**: open a *new* terminal after running `setup.ps1`, or check that `%LOCALAPPDATA%\Programs\ai` is in your `PATH`.
* **PowerShell blocks the script**: use the `-ExecutionPolicy Bypass` command shown above, or run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once.
* **`you need to create .env file with TOKEN variable`**: the config file is missing. Re-run the setup script or create the file manually as shown above.
