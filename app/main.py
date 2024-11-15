from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
from fastapi.templating import Jinja2Templates

# Initialization of the FastAPI app - used to define routes for handling
app = FastAPI()

# Templates directory
templates = Jinja2Templates(directory="templates")

# HTTP endpoint "/"
@app.get("/")
async def root(request: Request):
    try:
        return templates.TemplateResponse(
            "index.html", {"request": request, "message": "Hello Yarowa AG!"}
        )
    except Exception as error:
        return JSONResponse(status_code=500, content={"message": f"Internal Server Error: {error}"})

# Custom 404 handler for all other routes
@app.exception_handler(HTTPException)
async def custom_404_handler(request: Request, exc: HTTPException):
    if exc.status_code == 404:
        return templates.TemplateResponse("error.html", {"request": request, "error_message": "Page not found"})
    return JSONResponse(status_code=exc.status_code, content={"message": exc.detail})

# Route to catch all undefined paths and trigger 404
@app.get("/{full_path:path}")
async def catch_all_routes(request: Request):
    raise HTTPException(status_code=404, detail="Page not found")
