import os
import dotenv
from openai import OpenAI
from pathlib import Path
ENV_PATH = Path.home() / ".config" / "ai" / ".env"
dotenv.load_dotenv(ENV_PATH)
client = OpenAI(
    base_url="https://generativelanguage.googleapis.com/v1beta/openai/",
    api_key=os.getenv("TOKEN")
)
admin_info = """
you a CLI helper for looking for links
your task is to answer only the link https based on what user said
most important rule is answer only the link without any other text"""
def prompt(prompt: str) -> str:
    response = client.chat.completions.create(
        model="models/gemini-3.6-flash",
        messages=[
            {"role": "system", "content": admin_info},
            {"role": "user", "content": prompt}],
        temperature=0.4,
    )
    if not response.choices[0].message.content:
        return "error: no answer"
    return response.choices[0].message.content