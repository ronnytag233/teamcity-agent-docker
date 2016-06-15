#!/bin/bash
if [ -z "$TEAMCITY_SERVER" ]; then
    echo "TEAMCITY_SERVER variable not set, launch with -e TEAMCITY_SERVER=http://teamcity-server:8111"
    exit 1
fi

if [ ! -d "$AGENT_DIR/bin" ]; then
    echo "$AGENT_DIR doesn't exist pulling build-agent from server $TEAMCITY_SERVER";
    wget $TEAMCITY_SERVER/update/buildAgent.zip && unzip -d $AGENT_DIR buildAgent.zip && rm buildAgent.zip
    chmod +x $AGENT_DIR/bin/agent.sh
    printf '\n%s\n%s\n' "serverUrl=${TEAMCITY_SERVER}" "name=${HOSTNAME}" > $AGENT_DIR/conf/buildAgent.properties
fi

echo "Starting buildagent..."
chown -R teamcity:teamcity /opt/buildAgent

exec /sbin/setuser teamcity /opt/buildAgent/bin/agent.sh run
