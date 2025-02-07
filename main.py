from fastapi import FastAPI
import socket


app = FastAPI()
@app.get("/")


def hello():
    return "Hello World"


@app.get("/hostname")
def get_hostname():
    return {"hostname": socket.gethostname()}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=80)
