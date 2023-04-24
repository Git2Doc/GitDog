import os
import logging
import jsonpickle
import boto3
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.core import patch_all

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
patch_all()

# AWS Python SDK
client = boto3.client('lambda')
client.get_account_settings()

# Lambda handler
def lambda_handler(event, context):
    logger.info('Event: {}'.format(event))
    return {
        'statusCode': 200,
        'body': jsonpickle.encode({
            'message': 'Hello World!'
        })
    }