from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import google.generativeai as genai
from typing import Dict
import edge_tts
import base64
import json
import os

app = FastAPI()
active_connections: Dict[str, WebSocket] = {}
chat_history: Dict[str, list] = {}

# Configure Gemini API
genai.configure(api_key="AIzaSyAVLuOKk33bOW5Gl_nasVvItEvhffHgZu8")
model = genai.GenerativeModel('gemini-pro')

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    client_id = str(id(websocket))
    active_connections[client_id] = websocket
    
    try:
        while True:
            data = await websocket.receive_json()
            
            if data['type'] == 'text':
                user_id = data['user_id']
                text = data['text']
                
                # Initialize chat history if needed
                if user_id not in chat_history:
                    chat_history[user_id] = []
                
                # Add user message to history
                chat_history[user_id].append(f"User: {text}")
                
                # Get response from Gemini
                context = "\n".join(chat_history[user_id])
                response = model.generate_content(f"{context}\nBot:")
                bot_response = response.text
                
                # Add bot response to history
                chat_history[user_id].append(f"Bot: {bot_response}")
                
                # Send text response
                await websocket.send_json({
                    'type': 'response',
                    'text': bot_response
                })
                
                try:
                    # Generate speech using edge-tts
                    communicate = edge_tts.Communicate(bot_response)
                    audio_path = f"temp_{client_id}.mp3"
                    await communicate.save(audio_path)
                    
                    # Read and encode audio file
                    with open(audio_path, 'rb') as f:
                        audio_bytes = f.read()
                        audio_base64 = base64.b64encode(audio_bytes).decode('utf-8')
                    
                    # Send audio data
                    await websocket.send_json({
                        'type': 'audio',
                        'audio_url': f'data:audio/mp3;base64,{audio_base64}'
                    })
                    
                    # Clean up audio file
                    os.remove(audio_path)
                except Exception as e:
                    print(f"TTS Error: {str(e)}")
                    
    except WebSocketDisconnect:
        if client_id in active_connections:
            del active_connections[client_id]

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)