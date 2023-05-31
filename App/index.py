from flask import Flask, jsonify, request
from flask_cors import CORS
import json

app = Flask(__name__)
CORS(app)

# Load car data from the JSON file
with open(r'C:\Users\danlu\OneDrive\Documents\AppBuilds\DIYRepairAuto\App\Data\sampleData.json') as json_file:
    carData = json.load(json_file)


@app.route('/api/cars', methods=['GET'])
def get_cars():
    return jsonify(carData['results'])

@app.route('/api/selected-car', methods=['POST'])
def get_selected_car():
    selected_car = {}
    make = request.json['Make']
    model = request.json['Model']
    year = request.json['Year']
    trim = request.json['Trim']
    engine = request.json['Engine']

    # Find the selected car in the car data
    for car in carData['results']:
        if (make == car['Make'] and model == car['Model'] and
            year == str(car['Year']) and trim == car['Trim'] and
            engine == car['Engine']):
            selected_car = car
            break

    return jsonify(selected_car)

if __name__ == '__main__':
    app.run()




#results = data["results"]
#cars = results[0]
#year = cars.keys()
#print(type(cars))