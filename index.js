const http = require("http");
const crypto = require("crypto");
const exec = require("child_process").exec;
const config = require("dotenv-extended").load({
  errorOnMissing: true,
  errorOnRegex: true,
});

const server = http.createServer();

server.listen(config.PORT, (error) => {
  if (error) {
    throw Error(`Failed to run on port ${config.PORT}`);
  }

  console.log(`Server is listening on port ${config.PORT}`);
});

server.on("request", (request, response) => {
  request.on("data", (chunk) => {
    const signature =
      "sha1=" +
      crypto
        .createHmac("sha1", config.WEBHOOK_SECRET)
        .update(chunk.toString())
        .digest("hex");

    if (request.headers["x-hub-signature"] == signature) {
      console.log(`
        Event "${request.headers["x-github-event"]}":
          Perfrom build of "${
            config.REPOSITORY_LOCATION
          }" application and deploy it.
          Additional info:
          ========================================================================
          ${JSON.stringify(chunk, null, 4)}
      `);

      exec("bash build.sh", (error, stdout, stderr) => {
        console.log(`stdout: ${stdout}`);
        console.log(`stderr: ${stderr}`);
        if (error !== null) {
          response.writeHead(500);
          console.log(`exec error: ${error}`);
        } else {
          console.log(`Build completed successfully.`);
        }
      });
    }
  });

  response.end();
});
