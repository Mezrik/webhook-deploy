const http = require("http");
const crypto = require("crypto");

const config = require("dotenv-extended").load({
  errorOnMissing: true,
  errorOnRegex: true,
});
const runBuild = require("./exec");

const server = http.createServer();

server.listen(config.PORT, (error) => {
  if (error) {
    return console.error(error);
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

    if (request.headers["x-hub-signature"] == signature) runBuild();
  });

  response.end();
});
