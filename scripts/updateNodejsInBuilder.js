
const { Octokit } = require("@octokit/rest");
const version = process.env.version;

const ownerRepo = {
    owner: 'kube-hpc',
    repo: 'hkube'
};

const main = async () => {
    const octokit = new Octokit({ auth: process.env.GH_TOKEN });
    const masterShaResponse = await octokit.repos.listCommits({
        ...ownerRepo,
        per_page: 1
    });
    const masterSha = masterShaResponse.data[0].sha;
    const branchName = `update_nodejs_wraper_to_${version.replace('.', '_')}`;
    await octokit.git.createRef({
        ...ownerRepo,
        ref: `refs/heads/${branchName}`,
        sha: masterSha
    });
    let fileSha;
    const files = process.env.updatedFilePath.split(";");
    await files.map(file => {
        return async () => {
            const packageJsonContentResponse = await octokit.repos.getContent({
                ...ownerRepo,
                path: file,
                ref: branchName
            });
            const packageJsonContentStr = Buffer.from(packageJsonContentResponse.data.content, 'base64').toString('utf-8');
            const packageJsonContent = JSON.parse(packageJsonContentStr);
            fileSha = packageJsonContentResponse.data.sha;
            // update package json
            packageJsonContent.dependencies['@hkube/nodejs-wrapper'] = `^${version}`;
            const newContent = Buffer.from(JSON.stringify(packageJsonContent, null, 2)).toString('base64');


            const resp = await octokit.repos.createOrUpdateFileContents({
                ...ownerRepo,
                path: file,
                message: `update ${file} to ${version}`,
                branch: branchName,
                sha: fileSha,
                content: newContent
            });
            return resp;
        }
    }).reduce((p, fn) => p.then(fn), Promise.resolve()); // a way to run Promise.all synchronously 
};


main();
