import subprocess
import webbrowser
import typer
from sys import exit
from typing import List
from additional import ENV_PATH, check_system, cfg_path
from airequest import prompt
import os
version = "1.2"
if not os.path.exists(ENV_PATH):
    print("you need to create .env file with TOKEN variable like this: TOKEN=your_token")
    exit(1)
app = typer.Typer()
text = """NOT INCLUDED this file is your own config for ai. you can paste any text here and it will be sent to ai. delete this text before pasting your own"""


@app.callback(invoke_without_command=True)
def run(
    args: List[str] | None = typer.Argument(None),
    config: bool = typer.Option(False, "--config", "-c", help="Open configuration file"),
    version_flag: bool = typer.Option(False, "--version", "-v", help="Show version"),
    print_link: bool = typer.Option(False, "--print", "-p", help="print link and dont open"),
):
    if version_flag:
        print(version)
        return

    elif config:
        try:
            with open(cfg_path, "x", encoding="utf-8") as f:
                f.write(text)
        except FileExistsError:
            pass
        if check_system() == "Windows":
            # .cfg has no default app on Windows, so open it in Notepad directly
            subprocess.Popen(["notepad.exe", str(cfg_path)])
        else:
            typer.launch(str(cfg_path))
        return 
    if not args:
        print("you didnt provide any text")
        return

    final_string: str = " ".join(args) 
    ai_answer: str = prompt(final_string)
    if ai_answer.startswith("error"):
        print("ai didnt answer")
        return
    if print_link:
        print(ai_answer)
    else:
        webbrowser.open(ai_answer, 2, True) # url, how to open 0 - в in current tab, 1 in new window, 2 in new tab
if __name__ == "__main__":
    app()