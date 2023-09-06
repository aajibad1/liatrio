from flask import Flask, jsonify
import time

app = Flask(__name__)

@app.route('/')
def get_message():
    message = "Automate all the things for testing!"
    timestamp = int(time.time())
    return jsonify(message=message, timestamp=timestamp)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
