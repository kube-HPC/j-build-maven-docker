versions="python:2.7 python:3.5 python:3.6 python:3.7"
for v in $versions
do
  echo downloading for $v
  docker run --rm  $v pip  install --trusted-host cicd.hkube.org --index-url http://cicd.hkube.org/hkube/artifacts-registry/repository/pyrep/simple -r  /wrapper/requirements.txt
done
