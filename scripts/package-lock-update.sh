git clone https://${GH_TOKEN}@github.com/kube-HPC/hkube.git
cd hkube
git checkout ${branch}
cd /hkube/core/algorithm-debug/
rm package-lock.json
npm i
git add package-lock.json
cd /hkube/core/algorithm-gateway
rm package-lock.json
npm i
git add package-lock.json
cd /hkube/core/algorithm-output
rm package-lock.json
npm i
git add package-lock.json
git config --global user.email "hkube-ci@users.noreply.github.com"
git config --global user.name "hkube-ci"
git add package-lock.json
cd /hkube
git commit  -m 'adding pakcage-lock files' core/algorithm-debug/package-lock.json core/algorithm-gateway/package-lock.json core/algorithm-output/package-lock.json
git push
