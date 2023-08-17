#import os
import re
import inspect
from typing import TYPE_CHECKING, Any, Dict
#from aft_common import aft_utils as utils
from aft_common import notifications
from aft_common.account_provisioning_framework import ProvisionRoles
from aft_common.auth import AuthClient
#from aft_common.feature_options import get_aws_regions
from aft_common.logger import customization_request_logger
import boto3
from botocore.exceptions import ClientError
if TYPE_CHECKING:
    from aws_lambda_powertools.utilities.typing import LambdaContext
else:
    LambdaContext = object
    
SEC_ALTERNATE_CONTACTS = "CONTACT_TYPE=SECURITY; EMAIL_ADDRESS=john@example.com; CONTACT_NAME=John Bob; PHONE_NUMBER=1234567890; CONTACT_TITLE=Risk Manager"
BILL_ALTERNATE_CONTACTS = "CONTACT_TYPE=BILLING; EMAIL_ADDRESS=alice@example.com; CONTACT_NAME=Alice Doe; PHONE_NUMBER=1234567890; CONTACT_TITLE=Finance Manager"
OPS_ALTERNATE_CONTACTS = "CONTACT_TYPE=OPERATIONS; EMAIL_ADDRESS=bob@example.com; CONTACT_NAME=Bob Smith; PHONE_NUMBER=1234567890; CONTACT_TITLE=Operations Manager"
CONTACTS = []

def parse_contact_types():
    CONTACT_LIST = []
    for contact in [SEC_ALTERNATE_CONTACTS, BILL_ALTERNATE_CONTACTS, OPS_ALTERNATE_CONTACTS]:
        CONTACT_LIST = re.split("=|; ", contact)
        list_to_dict = {CONTACT_LIST[i]: CONTACT_LIST[i + 1] for i in range(0, len(CONTACT_LIST), 2)}
        CONTACTS.append(list_to_dict)

def put_alternate_contacts(account_id: str, account_client: Any) -> None:
    for contact in CONTACTS:
        try:
            account_client.put_alternate_contact(
                AccountId=account_id,
                AlternateContactType=contact["CONTACT_TYPE"],
                EmailAddress=contact["EMAIL_ADDRESS"],
                Name=contact["CONTACT_NAME"],
                PhoneNumber=contact["PHONE_NUMBER"],
                Title=contact["CONTACT_TITLE"],
            )

        except ClientError as error:
            print(error)
            raise

def lambda_handler(event: Dict[str, Any], context: LambdaContext) -> None:
    #request_id = event["customization_request_id"]
    #target_account_id = event["account_info"]["account"]["id"]
#
    #logger = customization_request_logger(
    #    aws_account_id=target_account_id, customization_request_id=request_id
    #)
#
    #auth = AuthClient()
    #aft_session = boto3.session.Session()
    #try:
    #    target_account_session = auth.get_target_account_session(
    #        account_id=target_account_id, role_name=ProvisionRoles.SERVICE_ROLE_NAME
    #    )
    #    account_client = target_account_session.client("account")
    #    parse_contact_types()
    #    put_alternate_contacts(account_id=target_account_id, account_client=account_client)
#
    #except Exception as error:
    #    notifications.send_lambda_failure_sns_message(
    #        session=aft_session,
    #        message=str(error),
    #        context=context,
    #        subject="AFT: Failed to add alternative contacts",
    #    )
    #    message = {
    #        "FILE": __file__.split("/")[-1],
    #        "METHOD": inspect.stack()[0][3],
    #        "EXCEPTION": str(error),
    #    }
    #    logger.exception(message)
    #    raise
    print("ok")