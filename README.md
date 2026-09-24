# 🚀 aisearch (`ai`)

A lightweight, fast Python CLI tool that uses the Gemini API (via the OpenAI-compatible SDK) to convert your natural language queries into URLs and automatically opens them in your default web browser.

## ✨ Features

* **Instant Link Generation**: Pass any prompt, and the AI returns a direct URL that opens automatically in a new browser tab.
* **XDG-Compliant Configuration**: Securely stores and reads your API token from `~/.config/ai/.env`.
* **Standalone Binary**: Packaged into a single portable binary using PyInstaller.
* **Automated Setup**: Included `setup.sh` handles directory creation, token prompting, and binary installation to `/usr/local/bin`.

## 🔑 Getting a Gemini API Key

This tool requires a free Google Gemini API key:

1. Go to [Google AI Studio](https://aistudio.google.com/).
2. Sign in with your Google account.
3. Click on **Get API key** (or **Create API key in new project**).
4. Copy the generated API key.

> **Note:** The setup script will automatically prompt you to paste this token during installation.

## 🛠️ Installation

### Quick Install (Pre-compiled Binary)

1. Download the latest release `ai` binary and `setup.sh` from the [Releases](https://github.com/tyufun/aisearch/releases) page.
2. put the files in one directory.
3. Make `setup.sh` executable and run it:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
4. Enter your Gemini API token when prompted.

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

If you want to modify the code and build the binary yourself using [`uv`](https://github.com/astral-sh/uv):

1. Clone this repository and install dependencies:
   ```bash
   git clone https://github.com/tyufun/aisearch.git
   cd aisearch
   uv sync
   ```

2. Build the single-file executable with PyInstaller:
   ```bash
   uv run pyinstaller -F -n ai --clean -y main.py
   ```

3. Move the built binary alongside `setup.sh` and run the installer:
   ```bash
   cp dist/ai .
   chmod +x setup.sh
   ./setup.sh
   ```