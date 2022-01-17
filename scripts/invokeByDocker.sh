# docker run --rm  -v $SCRIPTPATH/:/scripts node:14.5.0 /bin/bash -c '/scripts/package-lock-update.sh'
export arg1=`echo $1`
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
export branch=`echo update_nodejs_wraper_to_$version|sed "s/\./_/g"`
docker run --rm --env GH_TOKEN=$GH_TOKEN --env branch=$branch -v $SCRIPTPATH/:/sc node:14.5.0 /bin/bash -c "/sc/${arg1}"