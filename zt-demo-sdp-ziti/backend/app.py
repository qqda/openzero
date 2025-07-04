from flask import Flask

app = Flask(__name__)

@app.route("/data")
def data():
    return {"message": "Access granted to protected data."}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9000)
