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

# Add heroku creds if provided
if ! [[ -z $HEROKU_EMAIL && -z $HEROKU_API_KEY ]]; then
  echo "machine api.heroku.com login $HEROKU_EMAIL password $HEROKU_API_KEY" >> /root/.netrc
  echo "machine git.heroku.com login $HEROKU_EMAIL password $HEROKU_API_KEY" >> /root/.netrc
fi

echo "Starting buildagent..."

exec /opt/buildAgent/bin/agent.sh run
