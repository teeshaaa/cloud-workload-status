from datetime import datetime, timezone
import logging
import os
import socket

from flask import Flask, jsonify, request


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
logger = logging.getLogger(__name__)

APP_VERSION = os.getenv("APP_VERSION", "2.0.0")

app = Flask(__name__)


@app.route("/")
def index():
    logger.info("GET / from %s", request.remote_addr)
    return "App is running"


@app.route("/health")
def health():
    logger.info("GET /health from %s", request.remote_addr)
    return jsonify({"status": "ok"})


@app.route("/metadata")
def metadata():
    logger.info("GET /metadata from %s", request.remote_addr)
    return jsonify(
        {
            "hostname": socket.gethostname(),
            "current_time": datetime.now(timezone.utc).isoformat(),
            "app_version": APP_VERSION,
        }
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
