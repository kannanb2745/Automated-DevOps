import pytest
from app.main import create_app

@pytest.fixture
def client():
    app = create_app()
    app.testing = True
    return app.test_client()

def test_home(client):
    response = client.get('/')
    assert response.status_code == 200
    assert response.json == {'message': 'Hello, CI/CD World Testing!'}
