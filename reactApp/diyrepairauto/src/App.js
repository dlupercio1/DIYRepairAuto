import React, { useState, useEffect } from 'react';

function App() {
  const [carData, setCarData] = useState([]);
  const [make, setMake] = useState('');
  const [model, setModel] = useState('');
  const [year, setYear] = useState('');
  const [trim, setTrim] = useState('');
  const [engine, setEngine] = useState('');
  const [selectedCar, setSelectedCar] = useState(null);

  useEffect(() => {
    fetch('http://127.0.0.1:5000/api/cars')
      .then((response) => response.json())
      .then((data) => {
        setCarData(data);
      })
  }, []);

  const handleFormSubmit = async (e) => {
    e.preventDefault();

      const response = await fetch('http://127.0.0.1:5000/api/selected-car', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          Make: make,
          Model: model,
          Year: year,
          Trim: trim,
          Engine: engine,
        }),
      });
      const data = await response.json();
      setSelectedCar(data);
  };

  const handleMakeChange = (e) => {
    const selectedMake = e.target.value;
    setMake(selectedMake);
    setModel('');
    setYear('');
    setTrim('');
    setEngine('');
  };

  const uniqueMakes = [...new Set(carData.map((car) => car.Make))];

  return (
    <div>
      <h1>Select Your Car</h1>
      <form onSubmit={handleFormSubmit}>
        <label htmlFor="make">Make:</label>
        <select
          id="make"
          value={make}
          onChange={handleMakeChange}
          required
        >
          <option value="">Select Make</option>
          {uniqueMakes.map((make, index) => (
            <option key={index} value={make}>
              {make}
            </option>
          ))}
        </select>
        <br />

        <label htmlFor="model">Model:</label>
        <select
          id="model"
          value={model}
          onChange={(e) => setModel(e.target.value)}
          required
        >
          <option value="">Select Model</option>
          {carData
            .filter((car) => car.Make === make)
            .map((car, index) => (
              <option key={index} value={car.Model}>
                {car.Model}
              </option>
            ))}
        </select>
        <br />

        <label htmlFor="year">Year:</label>
        <select
          id="year"
          value={year}
          onChange={(e) => setYear(e.target.value)}
          required
        >
          <option value="">Select Year</option>
          {carData
            .filter((car) => car.Make === make && car.Model === model)
            .map((car, index) => (
              <option key={index} value={car.Year}>
                {car.Year}
              </option>
            ))}
        </select>
        <br />

        <label htmlFor="trim">Trim:</label>
        <select
          id="trim"
          value={trim}
          onChange={(e) => setTrim(e.target.value)}
          required
        >
          <option value="">Select Trim</option>
          {carData
            .filter(
              (car) =>
                car.Make === make && car.Model === model && car.Year === Number(year)
            )
            .map((car, index) => (
              <option key={index} value={car.Trim}>
                {car.Trim}
              </option>
            ))}
        </select>
        <br />

        <label htmlFor="engine">Engine:</label>
        <select
          id="engine"
          value={engine}
          onChange={(e) => setEngine(e.target.value)}
            required
          >
            <option value="">Select Engine</option>
            {carData
              .filter(
                (car) =>
                  car.Make === make &&
                  car.Model === model &&
                  car.Year === Number(year) &&
                  car.Trim === trim
              )
              .map((car, index) => (
                <option key={index} value={car.Engine}>
                  {car.Engine}
                </option>
              ))}
          </select>
          <br />
  
          <button type="submit">Submit</button>
        </form>
  
        {selectedCar ? (
          <div>
            <h2>Selected Car</h2>
            <p>Make: {selectedCar.Make}</p>
            <p>Model: {selectedCar.Model}</p>
            <p>Year: {selectedCar.Year}</p>
            <p>Trim: {selectedCar.Trim}</p>
            <p>Engine: {selectedCar.Engine}</p>
          </div>
        ) : (
          <p>No car matching the selected parameters found.</p>
        )}
      </div>
    );
  }
  
  export default App;
  