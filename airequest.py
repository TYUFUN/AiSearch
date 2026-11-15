
import dotenv
from openai import OpenAI
from additional import ENV_PATH, check_config_file



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
    
    
    try:
        response = client.chat.completions.create(
            model="models/gemini-3.6-flash",
            messages=[
                {"role": "system", "content": admin_info + "user config: " + check_config_file()},
                {"role": "user", "content": prompt}],
            temperature=0.4,
            max_tokens=1000
        )
        if not response.choices[0].message.content:
            return "error: no answer"
        return response.choices[0].message.content
    except Exception as e:
        return f"error: {e}"