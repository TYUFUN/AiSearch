import os
import sys
import dotenv
from openai import OpenAI
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


admin_info = """
you a CLI helper for looking for links
your task is to answer only the link https based on what user said
most important rule is answer only the link without any other text"""
def prompt(prompt: str) -> str:
    dotenv.load_dotenv(ENV_PATH)
    client = OpenAI(
        base_url="https://generativelanguage.googleapis.com/v1beta/openai/",
        api_key=dotenv.dotenv_values(ENV_PATH).get("TOKEN")
    )
    
    
    response = client.chat.completions.create(
        model="models/gemini-3.6-flash",
        messages=[
            {"role": "system", "content": admin_info + "user config: " + check_config_file()},
            {"role": "user", "content": prompt}],
        temperature=0.4,
    )
    if not response.choices[0].message.content:
        return "error: no answer"
    return response.choices[0].message.content