import requests
import time
import zipfile
import io
import os
from dotenv import load_dotenv

load_dotenv()


# GitHub Repo Info
OWNER = "kannanb2745"        # e.g. "dineshxyz"
REPO = "testing-CI-CD"             # e.g. "ci-test"
BRANCH = "main"
WORKFLOW_FILENAME = "main.yml"  # e.g. "build-test-deploy.yml"
TOKEN = os.getenv('TOKEN')             # Replace with your token

HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Accept": "application/vnd.github+json"
}

# 1. Trigger workflow dispatch
def trigger_workflow():
    url = f"https://api.github.com/repos/{OWNER}/{REPO}/actions/workflows/{WORKFLOW_FILENAME}/dispatches"
    payload = {"ref": BRANCH}
    response = requests.post(url, headers=HEADERS, json=payload)
    if response.status_code == 204:
        print("✅ Workflow triggered.")
    else:
        print("❌ Trigger failed:", response.text)
        exit(1)

# 2. Get latest run ID
def get_latest_run_id():
    url = f"https://api.github.com/repos/{OWNER}/{REPO}/actions/runs"
    while True:
        response = requests.get(url, headers=HEADERS)
        runs = response.json().get("workflow_runs", [])
        if runs:
            return runs[0]["id"]
        time.sleep(3)

# 3. Wait for completion
def wait_for_run(run_id):
    url = f"https://api.github.com/repos/{OWNER}/{REPO}/actions/runs/{run_id}"
    while True:
        response = requests.get(url, headers=HEADERS).json()
        status = response["status"]
        print(f"🔄 Status: {status}")
        if status == "completed":
            return response["conclusion"]
        time.sleep(5)

# 4. Download logs
def download_and_extract_logs(run_id):
    url = f"https://api.github.com/repos/{OWNER}/{REPO}/actions/runs/{run_id}/logs"
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
        with zipfile.ZipFile(io.BytesIO(response.content)) as z:
            z.extractall("logs")
        print("📦 Logs downloaded to 'logs/'")
    else:
        print("❌ Failed to download logs:", response.text)
        exit(1)

# 5. Print step-by-step logs like GitHub UI
def print_logs():
    for root, dirs, files in os.walk("logs"):
        for file in sorted(files):
            path = os.path.join(root, file)
            print(f"\n📄 === {file.replace('.txt', '')} ===")
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                print(f.read())

# ==== Run it ====
trigger_workflow()
time.sleep(10)
run_id = get_latest_run_id()
wait_for_run(run_id)
download_and_extract_logs(run_id)
print_logs()
