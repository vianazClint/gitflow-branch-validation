/** @type {import('next').NextConfig} */
module.exports = {
  transpilePackages: ["@repo/ui"],
  distDir: "build",
  output: "export",
  images: {
    unoptimized: true,
  }
};
