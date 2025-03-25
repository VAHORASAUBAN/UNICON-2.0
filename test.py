import requests
from datetime import datetime, timedelta

# 1️⃣ User se city name input lo
city = input("City ka naam enter karo: ")

# 2️⃣ City ka latitude & longitude find karne ke liye API call
geo_url = f"https://geocoding-api.open-meteo.com/v1/search?name={city}&count=1&language=en&format=json"
geo_response = requests.get(geo_url)

if geo_response.status_code == 200 and geo_response.json().get("results"):
    location = geo_response.json()["results"][0]
    latitude = location["latitude"]
    longitude = location["longitude"]
    print(f"\n📍 {city} ka Location: {latitude}, {longitude}\n")
else:
    print("❌ City ka location nahi mila, check karo!")
    exit()

# 3️⃣ User se Start aur End Date input lo
start_date = input("Start date enter karo (YYYY-MM-DD): ")
end_date = input("End date enter karo (YYYY-MM-DD): ")

# Date Validation
try:
    start_date_obj = datetime.strptime(start_date, "%Y-%m-%d")
    end_date_obj = datetime.strptime(end_date, "%Y-%m-%d")

    if start_date_obj > end_date_obj:
        print("❌ Start date, end date se chhoti honi chahiye!")
        exit()
except ValueError:
    print("❌ Invalid date format! (YYYY-MM-DD format use karo)")
    exit()

# 4️⃣ API se Weather Data Fetch karna
weather_url = "https://archive-api.open-meteo.com/v1/archive"
params = {
    "latitude": latitude,
    "longitude": longitude,
    "start_date": start_date,
    "end_date": end_date,
    "daily": "temperature_2m_max,temperature_2m_min",
    "timezone": "Asia/Kolkata"
}

weather_response = requests.get(weather_url, params=params)

if weather_response.status_code == 200:
    data = weather_response.json()

    if "daily" in data:
        dates = data["daily"]["time"]
        max_temp = data["daily"]["temperature_2m_max"]
        min_temp = data["daily"]["temperature_2m_min"]

        print("\n📊 *Daily Weather Report*")
        print("Date       | Max Temp (°C) | Min Temp (°C)")
        print("-" * 40)

        for i in range(len(dates)):
            print(
                f"{dates[i]}  | {max_temp[i]:.2f}°C       | {min_temp[i]:.2f}°C")
    else:
        print("❌ Data available nahi hai!")
else:
    print("❌ Error:", weather_response.status_code, weather_response.text)
