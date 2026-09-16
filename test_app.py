import subprocess 
import time 
import urllib.request
process = subprocess.Popen(["python3", "app.py"])
try: 
	time.sleep(1)
	response = urllib.request.urlopen("http://localhost:8000")

	assert response.status == 200

	body = response.read().decode("utf-8")

	assert "This is conflict test branch in merge" in body

	print("TEST PASSED")

finally:
	process.terminate()
	process.wait()
