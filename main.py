import os
import random
import time
import requests

API_URL = "https://yesno.wtf/api"
POLL_INTERVAL = 10
MOCK = os.environ.get("MOCK", "false").lower() == "true"


def log(msg):
    print(msg, flush=True)


def get_answer():
    if MOCK:
        answer = random.choices(["yes", "no"], weights=[20, 80])[0]
        log(f"Mock response: {{'answer': '{answer}'}}")
        return answer
    response = requests.get(API_URL, timeout=5)
    response.raise_for_status()
    data = response.json()
    log(f"API response: {data}")
    return data.get("answer")


def poll():
    while True:
        try:
            answer = get_answer()

            if answer == "yes":
                log("Answer is 'yes' -> exiting with code 0")
                os._exit(0)
            elif answer == "no":
                log("Answer is 'no' -> exiting with code 1")
                os._exit(1)
            else:
                log(f"Unexpected answer '{answer}', retrying in {POLL_INTERVAL}s...")

        except requests.RequestException as e:
            log(f"Request failed: {e}, retrying in {POLL_INTERVAL}s...")

        time.sleep(POLL_INTERVAL)


if __name__ == "__main__":
    log(f"Starting in {'mock' if MOCK else 'live'} mode")
    poll()
