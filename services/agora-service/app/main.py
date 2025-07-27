from fastapi import FastAPI, HTTPException, Header, Depends
from pydantic import BaseModel
import boto3
from typing import List, Optional
from mangum import Mangum
from botocore.exceptions import ClientError
import functools
import json

app = FastAPI()

TABLE_NAME = "agoras"

def get_secret():
    secret_name = "agora/auth_token"
    region_name = "us-east-1"

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
        secret = get_secret_value_response['SecretString']

        return secret
    except ClientError as e:
        raise e
    
@functools.lru_cache()
def cached_secret():
    return get_secret()

@functools.lru_cache()
def get_table():
    dynamodb = boto3.resource("dynamodb")    
    return dynamodb.Table(TABLE_NAME)

def validate_token(authorization: Optional[str] = Header(None)):
    secret = cached_secret()
    auth_token = json.loads(secret)["agora/auth_token"]
    print("auth_token", auth_token)
    print("authorization", authorization)
    if not authorization or authorization != auth_token:
        raise HTTPException(status_code=401, detail="Invalid or missing token")

class AgoraIn(BaseModel):
    id: int
    pretty_name: str
    short_description: str
    is_vote_secret: int

class AgoraOut(AgoraIn):
    id: int

@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/agora", response_model=List[AgoraOut], dependencies=[Depends(validate_token)])
def list_agoras():
    try:
        table = get_table()
        response = table.scan()
        return response.get("Items", [])
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/agora", response_model=AgoraOut, dependencies=[Depends(validate_token)])
def save_agora(agora: AgoraIn):
    table = get_table()
    item = {
        "id": agora.id,
        "pretty_name": agora.pretty_name,
        "short_description": agora.short_description,
        "is_vote_secret": agora.is_vote_secret,
    }
    try:
        table.put_item(Item=item)
        return {**item}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/agora/{id}", response_model=AgoraOut, dependencies=[Depends(validate_token)])
def update_agora(id: int, agora: AgoraIn):
    table = get_table()
    item = {
        "id": id,
        "pretty_name": agora.pretty_name,
        "short_description": agora.short_description,
        "is_vote_secret": agora.is_vote_secret,
    }
    try:
        table.put_item(Item=item)
        return {**item}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

handler = Mangum(app)
