import inspect
from typing import TYPE_CHECKING, Any, Dict
from aft_common import notifications
from aft_common.account_provisioning_framework import ProvisionRoles
from aft_common.auth import AuthClient
from aft_common.logger import customization_request_logger
import boto3
if TYPE_CHECKING:
    from aws_lambda_powertools.utilities.typing import LambdaContext
else:
    LambdaContext = object
    
def add_account_alias(account_name: str, account_client: Any) -> None:
    existing_aliases = account_client.list_account_aliases()['AccountAliases']
    
    for existing_alias in existing_aliases:
        account_client.delete_account_alias(AccountAlias=existing_alias)

    account_client.create_account_alias(AccountAlias=account_name)

def lambda_handler(event: Dict[str, Any], context: LambdaContext) -> None:
    request_id = event["customization_request_id"]
    target_account_id = event["account_info"]["account"]["id"]
    account_name = event["account_info"]["account"]["name"]

    logger = customization_request_logger(
        aws_account_id=target_account_id, customization_request_id=request_id
    )

    auth = AuthClient()
    aft_session = boto3.session.Session()
    try:
        target_account_session = auth.get_target_account_session(
            account_id=target_account_id, role_name=ProvisionRoles.SERVICE_ROLE_NAME
        )
        account_client = target_account_session.client("iam")
        logger.info("Connecting to account to add alias")
        add_account_alias(account_name, account_client)
        logger.info("Alias added to account")
        
    except Exception as error:
        notifications.send_lambda_failure_sns_message(
            session=aft_session,
            message=str(error),
            context=context,
            subject="AFT: Failed to add alias to account",
        )
        message = {
            "FILE": __file__.split("/")[-1],
            "METHOD": inspect.stack()[0][3],
            "EXCEPTION": str(error),
        }
        logger.exception(message)
        raise