#!/bin/bash
# Copyright (c) 2022 Robert Bosch GmbH and Microsoft Corporation
#
# This program and the accompanying materials are made available under the
# terms of the Apache License, Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0

echo "#######################################################"
echo "### Running FeederCan                               ###"
echo "#######################################################"

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../.." )
source $ROOT_DIRECTORY/.vscode/scripts/exec-check.sh "$@" $(basename $BASH_SOURCE .sh)
GITHUB_TOKEN="$ROOT_DIRECTORY/github_token.txt"

FEEDERCAN_VERSION=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .feedercan.version | tr -d '"')
DATABROKER_GRPC_PORT='52001'
sudo chown $(whoami) $HOME

# Downloading feedercan
FEEDERCAN_SOURCE="feedercan_source"
FEEDERCAN_EXEC_PATH="$ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION"

cred=$(cat $GITHUB_TOKEN)
API_URL=https://$cred@github.com/SoftwareDefinedVehicle/swdc-os-vehicleapi/tarball

if [[ ! -f "$FEEDERCAN_EXEC_PATH/feeder_can/dbcfeeder.py" ]]
then
  echo "Downloading FEEDERCAN:$FEEDERCAN_VERSION from $API_URL/$FEEDERCAN_VERSION"
  HTTP_STATUS_CODE=$(curl --write-out %{http_code} --create-dirs -o "$FEEDERCAN_EXEC_PATH/$FEEDERCAN_SOURCE" --location --remote-header-name --remote-name "$API_URL/$FEEDERCAN_VERSION")
  if [ $HTTP_STATUS_CODE -eq 200 ]; then
    FEEDERCAN_BASE_DIRECTORY=$(tar -tzf $FEEDERCAN_EXEC_PATH/$FEEDERCAN_SOURCE | head -1 | cut -f1 -d"/")
    tar -xf $FEEDERCAN_EXEC_PATH/$FEEDERCAN_SOURCE -C $FEEDERCAN_EXEC_PATH/
    cp -r $FEEDERCAN_EXEC_PATH/$FEEDERCAN_BASE_DIRECTORY/feeder_can $FEEDERCAN_EXEC_PATH
    rm -rf $FEEDERCAN_EXEC_PATH/$FEEDERCAN_BASE_DIRECTORY
  else
    echo -e "\e[01;31m"
    echo "Download FEEDERCAN:$FEEDERCAN_VERSION was not successful. (Http status code: $HTTP_STATUS_CODE)"
    echo "Check your Github URL and credentials."
    echo "$API_URL/$FEEDERCAN_VERSION"
    echo -e "\e[0m"
    echo ""
    exit 1
  fi
fi

cd $FEEDERCAN_EXEC_PATH/feeder_can
pip3 install -r requirements.txt

export DAPR_GRPC_PORT=$DATABROKER_GRPC_PORT
export VEHICLEDATABROKER_DAPR_APP_ID=vehicledatabroker
export LOG_LEVEL=info,databroker=info,dbcfeeder.broker_client=debug,dbcfeeder=debug
dapr run \
  --app-id feedercan \
  --app-protocol grpc \
  --components-path $ROOT_DIRECTORY/.dapr/components \
  --config $ROOT_DIRECTORY/.dapr/config.yaml & \
  ./dbcfeeder.py
