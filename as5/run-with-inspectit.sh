#!/bin/bash

CMR_ADDR=${INSPECTIT_CMR_ADDR:-cmr}
CMR_PORT=${INSPECTIT_CMR_PORT:-9070}
AGENT_NAME=${AGENT_NAME:-$HOSTNAME}
SECONDS=${INSPECTIT_CMR_WAIT:-1}

if ([ -z $INSPECTIT_CMR_ADDR ] || [ -z $INSPECTIT_CMR_PORT ]) && ([ -z $CMR_PORT_9070_TCP_ADDR ] || [ -z $CMR_PORT_9070_TCP_PORT ]); then
	echo "[ERROR] No inspectIT CMR configured! Please read our README"
	exit 1
fi

printVersionMismatch() {
	echo "[ERROR] Version of inspectIT CMR and agent do not match:"
    	echo "[ERROR] Agent: $1"
    	echo "[ERROR] CMR: $2"
    	echo "[ERROR] You have to use the same version for CMR and agent."
    	exit 1
}

# Update inspectIT options in the configuration file
CONFIGURATION_FILE=/jboss-5.1.0.GA/bin/run.conf
sed -i -- "s/_CMR_ADDRESS_/$CMR_ADDR/g" $CONFIGURATION_FILE
sed -i -- "s/_CMR_PORT_/$CMR_PORT/g" $CONFIGURATION_FILE
sed -i -- "s/_AGENT_NAME_/$AGENT_NAME/g" $CONFIGURATION_FILE

# Version check
if ([[ -n $INSPECTIT_VERSION && -n $CMR_ENV_INSPECTIT_VERSION && $INSPECTIT_VERSION != $CMR_ENV_INSPECTIT_VERSION ]]); then
	printVersionMismatch $INSPECTIT_VERSION $CMR_ENV_INSPECTIT_VERSION
fi

# Wait for CMR startup
for ((i=$SECONDS; i >= 1; i--)); do
	CMR_REST_VERSION=$(wget http://$CMR_ADDR:8182/rest/cmr/version -qO-)
	if ([ $? -eq 0 ] && [ -n $CMR_REST_VERSION ]); then
		# Trim enclosing quotes
		CMR_REST_VERSION="${CMR_REST_VERSION%\"}"
		CMR_REST_VERSION="${CMR_REST_VERSION#\"}"

        	if ([ $INSPECTIT_VERSION != $CMR_REST_VERSION ]); then
                	printVersionMismatch $INSPECTIT_VERSION $CMR_REST_VERSION
        	else
                	echo "Connected!"
        	fi
        	break
    	fi
	echo "Waiting for CMR...${i}"
	sleep 1
done

if ([ -z $CMR_REST_VERSION ]);then
	echo "[INFO] Running inspectIT with version $INSPECTIT_VERSION"
	echo "[INFO] Make sure your CMR has the same version"
fi


exec /run.sh
