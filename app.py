from flask import Flask
from flask_cors import CORS
from flask_session import Session

from api.subject import subject_api
from api.group import group_api

# The main initializer for the Flask application
app = Flask(__name__)

# The app's secret key, which is used for encoding sensitive data such as cookies
app.secret_key = (
    "8]c(G#*!u--hqdl[gi~RW;Z*S5Fwe-"  # You should change this to something random
)
app.config["SESSION_TYPE"] = "filesystem"

# Initialize the session manager and the CORS manager for the app
Session(app)
CORS(app, supports_credentials=True)

################################################
### ↓↓↓↓↓ Register your API endpoints here ↓↓↓↓↓

app.register_blueprint(subject_api, url_prefix="/v1")
app.register_blueprint(group_api, url_prefix="/v2")

### ↑↑↑↑↑ Register your API endpoints here ↑↑↑↑↑
################################################

# Finally, if we're running this file, start the app
if __name__ == "__main__":
    app.run(port=8080, debug=True)
