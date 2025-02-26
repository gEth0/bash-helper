import requests

api_key = input("Enter your API key=> ")

base_url = "https://api.deepinfra.com/v1/openai/chat/completions"
headers = {"Authorization": f"Bearer {api_key}"}

messages = [
    {"role": "system", "content": "Devi rispondermi solo con codice bash che poi devo inserire in un file sh, massimo due linee di testo per spiegarlo"}
]

while True:
    message = input("User: ")
    if message.lower() in ["exit", "quit"]:
        print("Uscita...")
        break

    messages.append({"role": "user", "content": message})

    data = {
        "model": "meta-llama/Meta-Llama-3-8B-Instruct",
        "messages": messages
    }

    response = requests.post(base_url, headers=headers, json=data)
    
    if response.status_code == 200:
        reply = response.json()["choices"][0]["message"]["content"]
        print(f"bash-helper: {reply}")
        messages.append({"role": "assistant", "content": reply})
    else:
        print("Errore nella richiesta:", response.json())
