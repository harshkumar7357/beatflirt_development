import urllib.request
import urllib.parse
import json
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

token = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz89580127924587413698552@#$%&*ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz89580127924587413698552@#$%&*ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz89580127924587413698552@#$%&*ABCDEFGHIJKL"

def test_post(url, payload):
    headers = {
        "Authorization": f"Bearer {token}",
        "access-token": token,
        "Content-Type": "application/json",
        "Accept": "application/json"
    }
    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers, method="POST")
    try:
        with urllib.request.urlopen(req, context=ctx) as response:
            res_body = response.read().decode()
            print(f"URL: {url}")
            print(f"Status: {response.status}")
            print(f"Response: {res_body}")
            print("-" * 50)
            return json.loads(res_body)
    except Exception as e:
        print(f"Error for {url}: {e}")
        if hasattr(e, 'read'):
            print(f"Error body: {e.read().decode()}")
        print("-" * 50)
        return None

# Test 1: Let's try upload_profile_image with the image name we just uploaded
print("--- Test 1: upload_profile_image with image name ---")
test_post("https://app.beatflirtevent.com/App/user/upload_profile_image", {"image": "6a2ab35071f43.jpg"})
test_post("https://app.beatflirtevent.com/App/user/upload_profile_image", {"profile_image": "6a2ab35071f43.jpg"})

# Test 2: Let's try edit_profile_image with the image name
print("--- Test 2: edit_profile_image with image name ---")
test_post("https://app.beatflirtevent.com/App/user/edit_profile_image", {"image": "6a2ab35071f43.jpg"})
test_post("https://app.beatflirtevent.com/App/user/edit_profile_image", {"profile_image": "6a2ab35071f43.jpg"})
