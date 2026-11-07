#!/usr/bin/env python3

import json
import subprocess
import urllib.request
import xml.etree.ElementTree as ET
from datetime import UTC, datetime, timedelta

MAX_CLOUD_COVERAGE = 30

AURORA_URL = "https://xmlweather.vedur.is/aurora?op=xml&lang=en&type=index"
WEATHER_URL = (
    "https://api.open-meteo.com/v1/forecast"
    "?latitude=64.1458&longitude=-21.9425"
    "&hourly=cloud_cover"
    "&timezone=Atlantic%2FReykjavik"
    "&forecast_days=4"
)


def fetch(url):
    with urllib.request.urlopen(url, timeout=15) as response:
        return response.read()


def notify(title, body):
    if os.getenv("DEV_MODE") == "1":
        print(title)
        print(body)
        return

    subprocess.run(
        [
            "webhook-notifier",
            "aurora-updates",
            "-",
            "--title",
            title,
            "--notify",
        ],
        input=body,
        text=True,
        check=True,
    )


def main():
    now = datetime.now(UTC).replace(tzinfo=None)
    aurora = ET.fromstring(fetch(AURORA_URL))

    for night in aurora.findall("night_data"):
        date = night.findtext("evening_date")
        try:
            date = datetime.strptime(date, "%Y-%m-%d")
        except ValueError:
            date = datetime.strptime(date, "%y-%m-%d")

        sunset = datetime.combine(
            date.date(), datetime.strptime(night.findtext("sun/sunset"), "%H:%M").time()
        )
        sunrise = datetime.combine(
            (date + timedelta(days=1)).date(),
            datetime.strptime(night.findtext("sun/sunrise"), "%H:%M").time(),
        )

        if sunset > now:
            activity = int(night.findtext("activity_forecast") or 0)
            break
    else:
        raise RuntimeError("No upcoming sunset found")

    if activity == 0:
        notify("😢 No aurora activity tonight", "")
        return

    weather = json.loads(fetch(WEATHER_URL))
    hours = []

    for time, cloud in zip(weather["hourly"]["time"], weather["hourly"]["cloud_cover"]):
        hour = datetime.fromisoformat(time)

        if sunset < hour < sunrise and cloud is not None and cloud < MAX_CLOUD_COVERAGE:
            hours.append(f"- {hour:%a %d %H:%M} (☁️ {cloud}%)")

    if not hours:
        notify("😢 No clear skies tonight", "")
        return

    body = "You will have clear skies at:\n\n" + "\n".join(hours)

    notify(f"🌌 Activity level {activity}", body)


if __name__ == "__main__":
    main()
