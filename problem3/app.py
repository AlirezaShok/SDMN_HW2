from flask import Flask, request, jsonify

app = Flask(__name__)

# Initial status
status = "OK"

@app.route('/api/v1/status', methods=['GET', 'POST'])
def api_status():
    global status
    if request.method == 'GET':
        return jsonify({"status": status}), 200
    elif request.method == 'POST':
        data = request.get_json()
        if 'status' in data:
            status = data['status']
            return jsonify({"status": status}), 201
        else:
            return jsonify({"error": "Bad Request"}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
