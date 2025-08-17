from flask import Flask, request, jsonify
import util

app = Flask(__name__)

@app.route('/classify_image', methods=['GET', 'POST'])
def classify_image():
    image_data = request.form['image_data']

    result = util.classify_image(image_data)  # ✅ Correct function call
    response = jsonify(result)
    response.headers.add('Access-Control-Allow-Origin', '*')

    return response

if __name__ == '__main__':
    print("Starting Python Flask Server for Celebrity Face Recognition")
    util.load_saved_artifacts()
    app.run(port=5000)