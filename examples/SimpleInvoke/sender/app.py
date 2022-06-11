# ------------------------------------------------------------
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
# ------------------------------------------------------------

import os
import requests
import time

dapr_port = os.getenv("DAPR_HTTP_PORT", 3500)
dapr_url = "http://localhost:{}/v1.0/invoke/receiver/method/neworder".format(dapr_port)  # noqa: E501

n = 0
while True:
    n += 1
    message = {"data": {"orderId": n}}

    try:
        print("Creating order '{}' with post to '{}'".format(message, dapr_url))  # noqa: E501
        response = requests.post(dapr_url, json=message, timeout=5)
        if not response.ok:
            print("HTTP %d => %s" % (response.status_code,
                                     response.content.decode("utf-8")), flush=True)  # noqa: E501
    except Exception as e:
        print(e, flush=True)

    time.sleep(1)
