from flask import Flask, request, jsonify
import os

app = Flask(__name__)

FILE_PATH = "data.txt"

@app.put("/replace")
def replace():
    data = request.get_json()

    if not data or "source" not in data or "id" not in data or "payload" not in data:
        return jsonify({"error": "invalid json"}), 400

    with open(FILE_PATH, "w", encoding="utf-8") as f:
        f.write(data["payload"])

    return jsonify({"status": "ok"}), 200


@app.get("/get")
def get():
    if not os.path.exists(FILE_PATH):
        return jsonify({"payload": ""}), 200

    with open(FILE_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    return jsonify({"payload": content}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)