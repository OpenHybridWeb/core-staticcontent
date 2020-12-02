const fs = require('fs').promises;
const simpleGit = require('simple-git');
const express = require('express');

const dataDirPath = process.env.DATA_DIR;

if (dataDirPath === undefined) logAndAbort("Error: DATA_DIR env variable not defined");


const app = express();
const port = 8080;

app.get('/', (req, res) => {
    res.send('Static content REST API is working!');
});

app.get('/_api/update/:dir', (req, res) => {
    let baseDir = dataDirPath + req.params.dir;

    fs.access(baseDir).then(() =>
        gitUpdate(baseDir)
            .then(() => res.status(200).send('DONE'))
            .catch(reason => {
                console.log(`Cannot git pull ${dir}. reason=${reason}`);
                res.status(503).send(reason);
            })
    ).catch(reason => res.status(404).send("directory not found"));
});

app.listen(port, () => console.log(`Static content REST API listening on port ${port} DATA_DIR=${dataDirPath}`))


function gitUpdate(dir) {
    console.log(`update ${dir}`);
    let git = simpleGit({
        baseDir: dir,
        binary: 'git',
        maxConcurrentProcesses: 6,
    });
    return git.pull();
}


function logAndAbort(message, reason) {
    console.error(message + ((reason) ? " reason: %s" + reason : ""));
    process.abort();
}