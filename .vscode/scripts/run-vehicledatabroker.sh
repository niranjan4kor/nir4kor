
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
echo "### Running Databroker                              ###"
echo "#######################################################"

ROOT_DIRECTORY=$(git rev-parse --show-toplevel)
source $ROOT_DIRECTORY/.vscode/scripts/exec-check.sh "$@" $(basename $BASH_SOURCE .sh)
GITHUB_TOKEN="$ROOT_DIRECTORY/github_token.txt"

DATABROKER_VERSION=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .databroker.version | tr -d '"')
DATABROKER_PORT='55555'
DATABROKER_GRPC_PORT='52001'
sudo chown $(whoami) $HOME

#Detect host environment (distinguish for Mac M1 processor)
if [[ `uname -m` == 'aarch64' || `uname -m` == 'arm64' ]]; then
  echo "Detected ARM architecture"
  PROCESSOR="aarch64"
  DATABROKER_BINARY_NAME="bin_release_databroker_aarch64.tar.gz"
  DATABROKER_EXEC_PATH="$ROOT_DIRECTORY/.vscode/scripts/assets/databroker/$DATABROKER_VERSION/$PROCESSOR/target/aarch64-unknown-linux-gnu/release"
else
  echo "Detected x86_64 architecture"
  PROCESSOR="x86_64"
  DATABROKER_BINARY_NAME='bin_release_databroker_x86_64.tar.gz'
  DATABROKER_EXEC_PATH="$ROOT_DIRECTORY/.vscode/scripts/assets/databroker/$DATABROKER_VERSION/$PROCESSOR/target/release"
fi

cred=$(cat $GITHUB_TOKEN)
API_URL=https://$cred@api.github.com/repos/SoftwareDefinedVehicle/swdc-os-vehicleapi

if [[ ! -f "$DATABROKER_EXEC_PATH/vehicle-data-broker" ]]
then
  echo "Downloading databroker:$DATABROKER_VERSION"
  DATABROKER_ASSET_ID=$(curl $API_URL/releases/tags/$DATABROKER_VERSION | jq -r ".assets[] | select(.name == \"$DATABROKER_BINARY_NAME\") | .id")
  curl -o $ROOT_DIRECTORY/.vscode/scripts/assets/databroker/$DATABROKER_VERSION/$PROCESSOR/$DATABROKER_BINARY_NAME --create-dirs -L -H "Accept: application/octet-stream" "$API_URL/releases/assets/$DATABROKER_ASSET_ID"
  tar -xf $ROOT_DIRECTORY/.vscode/scripts/assets/databroker/$DATABROKER_VERSION/$PROCESSOR/$DATABROKER_BINARY_NAME -C $ROOT_DIRECTORY/.vscode/scripts/assets/databroker/$DATABROKER_VERSION/$PROCESSOR

fi

export DAPR_GRPC_PORT=$DATABROKER_GRPC_PORT
#export RUST_LOG="info,databroker=debug,vehicle_data_broker=debug"
dapr run \
  --app-id vehicledatabroker \
  --app-protocol grpc \
  --app-port $DATABROKER_PORT \
  --dapr-grpc-port $DATABROKER_GRPC_PORT \
  --components-path $ROOT_DIRECTORY/.dapr/components \
  --config $ROOT_DIRECTORY/.dapr/config.yaml & \
  $DATABROKER_EXEC_PATH/vehicle-data-broker --address 0.0.0.0 --dummy-metadata
