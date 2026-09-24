import webbrowser
import typer
from sys import exit
from typing import List
from airequest import prompt, ENV_PATH
import os

if not os.path.exists(ENV_PATH):
    print("you need to create .env file with TOKEN variable like this: TOKEN=your_token")
    exit(1)
app = typer.Typer()
@app.callback(invoke_without_command=True)
def run(
args: List[str] | None  = typer.Argument(None)):
    if not args:
        print("you didnt provide any text")
        return
    
    final_string: str = " ".join(args) 
    ai_answer: str = prompt(final_string)
    if ai_answer.startswith("error"):
        print("ai didnt answer")
        return
    webbrowser.open(ai_answer, 2, True) # url, how to open 0 - в in current tab, 1 in new window, 2 in new tab
if __name__ == "__main__":
    app()