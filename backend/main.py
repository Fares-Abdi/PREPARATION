from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import google.generativeai as genai
from typing import List, Dict

# Initialize FastAPI app
app = FastAPI()

# Configure Gemini API
genai.configure(api_key="AIzaSyApmKwDRSf_A5Pp1ZjM1NXUN1aRfCJUXos")

# Define the model (Gemini)
model = genai.GenerativeModel('gemini-pro')

# In-memory storage for chat history
chat_history: Dict[str, List[str]] = {}

# Define the request body model
class ChatRequest(BaseModel):
    user_id: str  # Unique identifier for the user
    query: str

# Define the response body model
class ChatResponse(BaseModel):
    response: str
    history: List[str]  # Include chat history in the response

# Define the chat endpoint
@app.post("/chat", response_model=ChatResponse)
async def chat(chat_request: ChatRequest):
    try:
        user_id = chat_request.user_id
        user_query = chat_request.query

        # Initialize chat history for the user if it doesn't exist
        if user_id not in chat_history:
            chat_history[user_id] = []

        # Add the user's query to the history
        chat_history[user_id].append(f"User: {user_query}")

        # Prepare the context for the model
        context = "\n".join(chat_history[user_id])  # Combine history into a single string
        full_prompt = f"{context}\nBot:"  # Add "Bot:" to indicate the model's turn

        # Generate a response using Gemini with the full context
        response = model.generate_content(full_prompt)

        # Add the bot's response to the history
        chat_history[user_id].append(f"Bot: {response.text}")

        # Return the response and the chat history
        return ChatResponse(
            response=response.text,
            history=chat_history[user_id]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Run the server
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)