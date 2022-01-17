
const { Octokit } = require("@octokit/rest");
const version = process.env.version;

const ownerRepo = {
    owner: 'kube-hpc',
    repo: 'hkube'
};

const main = async () => {
    const octokit = new Octokit({ auth: process.env.GH_TOKEN });
    const branchName = `update_nodejs_wraper_to_${version.replace('.', '_')}`;
    await octokit.pulls.create({
        ...ownerRepo,
        title: `update nodejs wrapper to ${version}`,
        head: branchName,
        base: 'master'
    });

};


main();
