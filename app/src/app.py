import requests
from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/", methods=["GET"])
def get_jokes():
    """Fetch the latest jokes from bash.org.pl
    Returns:
        JSON: A JSON object containing the jokes
    """
    url = "http://bash.org.pl/text"
    response = requests.get(url)
    jokes = parse_jokes(response.text)

    # Return the jokes in JSON format
    return jsonify(jokes)


def parse_jokes(text: str) -> list(dict()):
    """Parse the jokes from the HTML response.
    Args:
        text (str): The HTML response from bash.org.pl
    Returns:
        list(dict()): A list of dictionaries containing the jokes
    """
    lines = text.split("\n")
    jokes = []
    joke = {"id": "", "text": []}
    for line in lines:
        line = line.strip()
        if line.startswith("#"):
            joke["id"] = (line.split(" ")[0])[1:]
        elif line.startswith("<"):
            joke["text"].append(line)
        elif line.startswith("%"):
            jokes.append(joke.copy())

    # Return the latest 100 jokes from the list
    return jokes[:100]


if __name__ == "__main__":
    app.run()
