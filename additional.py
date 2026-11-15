import os
import sys
from pathlib import Path


def check_system():
    if sys.platform == "win32":
        return "Windows"
    return "Linux"


def get_config_dir() -> Path:
    # Windows: %APPDATA%\ai   |   Linux: ~/.config/ai
    if check_system() == "Windows":
        base = os.getenv("APPDATA")
        return (Path(base) if base else Path.home() / "AppData" / "Roaming") / "ai"
    return Path.home() / ".config" / "ai"


cfg_path = get_config_dir() / "CONFIG.cfg"

def check_config_file() -> str:
    if not cfg_path.exists():
        return ""
    with open(cfg_path, "r", encoding="utf-8") as f:
        config = f.read()
    if config.startswith("NOT INCLUDED") or not config:
        return ""
    return config
ENV_PATH = get_config_dir() / ".env"


