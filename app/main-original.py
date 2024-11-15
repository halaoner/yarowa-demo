from fastapi import FastAPI, Request
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
        print(f"Error: {error}")
