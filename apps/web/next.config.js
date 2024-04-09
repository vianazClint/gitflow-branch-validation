/** @type {import('next').NextConfig} */
module.exports = {
  transpilePackages: ["@repo/ui"],
  distDir: "build",
  output: process.env.NODE_ENV === "production" ? "export" : undefined,
};
