const packageJSONTemplate = process.env.packageJSONTemplate
const packageJsonContent = JSON.parse(packageJSONTemplate);
// update package json
packageJsonContent.dependencies['@hkube/nodejs-wrapper'] = `^${process.env.version}`;
console.log(packageJsonContent);