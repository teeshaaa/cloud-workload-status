from datetime import datetime, timezone
import json
import logging
import os
import socket
import time

from flask import Flask, jsonify, g, request


APP_VERSION = os.getenv("APP_VERSION", "2.0.0")


class JsonFormatter(logging.Formatter):
    def format(self, record):
        payload = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
        }

        for field in (
            "method",
            "path",
            "status_code",
            "remote_addr",
            "duration_ms",
        ):
            value = getattr(record, field, None)
            if value is not None:
                payload[field] = value

        return json.dumps(payload)


def configure_logging():
    handler = logging.StreamHandler()
    handler.setFormatter(JsonFormatter())

    root_logger = logging.getLogger()
    root_logger.handlers.clear()
    root_logger.addHandler(handler)
    root_logger.setLevel(logging.INFO)


def create_app():
    configure_logging()

    app = Flask(__name__)
    logger = app.logger

    @app.before_request
    def before_request():
        g.request_started_at = time.perf_counter()

    @app.after_request
    def after_request(response):
        duration_ms = round((time.perf_counter() - g.request_started_at) * 1000, 2)
        logger.info(
            "request_complete",
            extra={
                "method": request.method,
                "path": request.path,
                "status_code": response.status_code,
                "remote_addr": request.headers.get(
                    "X-Forwarded-For", request.remote_addr
                ),
                "duration_ms": duration_ms,
            },
        )
        return response

    @app.route("/")
    def index():
        return "App is running"

    @app.route("/health")
    def health():
        return jsonify({"status": "ok"})

    @app.route("/metadata")
    def metadata():
        return jsonify(
            {
                "hostname": socket.gethostname(),
                "current_time": datetime.now(timezone.utc).isoformat(),
                "app_version": APP_VERSION,
            }
        )
    @app.route("/version")
    def version():
        return jsonify({"version": APP_VERSION})

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
