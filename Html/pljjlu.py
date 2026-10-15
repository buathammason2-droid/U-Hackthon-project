import requests
from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
import io

app = FastAPI()

ELEVENLABS_API_KEY = "YOUR_ELEVENLABS_API_KEY"
# เลือก Voice ID ภาษาไทยที่คุณต้องการ (ตั้งค่าใน ElevenLabs Dashboard)
VOICE_ID = "21m00Tcm4TlvDq8ikWAM" 

@app.post("/api/v1/generate-voice")
def generate_voice(text: str):
    """
    ส่งข้อความไปแปลงเป็นเสียงผ่าน ElevenLabs
    """
    url = f"https://api.elevenlabs.io/v1/text-to-speech/{VOICE_ID}/stream"
    
    headers = {
        "Accept": "audio/mpeg",
        "Content-Type": "application/json",
        "xi-api-key": ELEVENLABS_API_KEY
    }
    
    payload = {
        "text": text,
        "model_id": "eleven_multilingual_v2",  # รองรับภาษาไทยสมบูรณ์
        "voice_settings": {
            "stability": 0.5,        # ความคงที่ของน้ำเสียง (0.5 - 0.7 เหมาะกับข่าว/เตือนภัย)
            "similarity_boost": 0.75,
            "style": 0.0,
            "use_speaker_boost": True
        }
    }

    response = requests.post(url, json=payload, headers=headers, stream=True)

    if response.status_code != 200:
        raise HTTPException(status_code=500, detail="ElevenLabs API Error")

    # ส่งคืนไฟล์เสียงแบบ Streaming ให้แอปมือถือเล่นได้ทันที
    return StreamingResponse(response.iter_content(chunk_size=1024), media_type="audio/mpeg")

