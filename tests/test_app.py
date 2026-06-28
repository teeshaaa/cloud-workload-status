from app import APP_VERSION, create_app


def test_index_route():
    client = create_app().test_client()

    response = client.get("/")

    assert response.status_code == 200
    assert response.data.decode() == "App is running"


def test_health_route():
    client = create_app().test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_metadata_route():
    client = create_app().test_client()

    response = client.get("/metadata")

    assert response.status_code == 200
    body = response.get_json()

    assert body["app_version"] == APP_VERSION
    assert "hostname" in body
    assert "current_time" in body

def test_version_route():
    client = create_app().test_client()

    response = client.get("/version")

    assert response.status_code == 200
    body = response.get_json()

    assert body["version"] == APP_VERSION