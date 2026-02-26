import logging
import azure.functions as func
from azure.ai.vision import VisionClient
import os
import json

def main(blob: func.InputStream):

    logging.info(f"Processing blob: {blob.name}")

    endpoint = os.environ["VISION_ENDPOINT"]
    key = os.environ["VISION_KEY"]

    client = VisionClient(endpoint, key)

    result = client.read_in_stream(blob.read())

    extracted_text = result.content

    return extracted_text