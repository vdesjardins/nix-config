import { bundle } from "./nix-emit/mod.ts";

const { compilerOptions, imports } = JSON.parse(Deno.readTextFileSync("deno.json"));
const options = { compilerOptions, importMap: { imports } };

for (const [source, output] of [
  ["app/src/main.ts", "public/main.bundle.js"],
  ["app/src/webview.ts", "public/webview.js"],
  ["client/src/script.ts", "public/script.bundle.js"],
]) {
  Deno.writeTextFileSync(output, (await bundle(source, options)).code);
}
