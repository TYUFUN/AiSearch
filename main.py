import webbrowser
from airequest import prompt
import os
if not os.path.exists(".env"):
    usr_token = str(input("Enter gemini token: "))
    with open (".env", "w", encoding="utf-8") as f:
        f.write(f"TOKEN=\"{usr_token}\"")
webbrowser.open(prompt(), 2, True) 
# url, how to open 0 - в in current tab, 1 in new window, 2 in new tab
