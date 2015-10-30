var sha1 = require("crypto").createHash("sha1"),
  decipher = require("crypto").createDecipher("aes-256-cbc", "r9qignYPa3d2glAbdMV963UDy7KqpZsv");

console.log(
  sha1.update(
    `${decipher.update(process.argv[2], "hex", "utf8")}${decipher.final("utf8")}`,
    "utf8"
  ).digest("hex")
);
