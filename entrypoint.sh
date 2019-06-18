#!/bin/bash
set -e

echo "starting jnlp slave..."
# if -tunnel is not provided try env vars
if [[ "$@" != *"-tunnel "* ]]; then
    if [[ ! -z "$JENKINS_TUNNEL" ]]; then
        TUNNEL="-tunnel $JENKINS_TUNNEL"		
    fi
fi

if [[ ! -z "$JENKINS_URL" ]]; then
    URL="-url $JENKINS_URL"
fi
exec java $JAVA_OPTS -Duser.home=/home/jenkins -cp /usr/share/jenkins/slave.jar hudson.remoting.jnlp.Main -headless $TUNNEL $URL "$@"