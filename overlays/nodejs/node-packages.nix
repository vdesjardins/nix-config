# This file has been generated by node2nix 1.9.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "core-js-3.20.2" = {
      name = "core-js";
      packageName = "core-js";
      version = "3.20.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/core-js/-/core-js-3.20.2.tgz";
        sha512 = "nuqhq11DcOAbFBV4zCbKeGbKQsUDRqTX0oqx7AttUBuqe3h20ixsE039QHelbL6P4h+9kytVqyEtyZ6gsiwEYw==";
      };
    };
    "jsonc-parser-3.0.0" = {
      name = "jsonc-parser";
      packageName = "jsonc-parser";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.0.0.tgz";
        sha512 = "fQzRfAbIBnR0IQvftw9FJveWiHp72Fg20giDrHz6TdfB12UH/uue0D3hm57UB5KgAVuniLMCaS8P1IMj9NR7cA==";
      };
    };
    "regenerator-runtime-0.13.9" = {
      name = "regenerator-runtime";
      packageName = "regenerator-runtime";
      version = "0.13.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.9.tgz";
        sha512 = "p3VT+cOEgxFsRRA9X4lkI1E+k2/CtnKtU4gcxyaCUreilL/vqI6CdZ3wxVUx3UOUg+gnUOQQcRI7BmSI656MYA==";
      };
    };
    "request-light-0.5.6" = {
      name = "request-light";
      packageName = "request-light";
      version = "0.5.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/request-light/-/request-light-0.5.6.tgz";
        sha512 = "mIfRkYujBF6qQQi+uJGHFzYD2P7WwfIMyJ3/DcTtOFB3iypwIVOXmsr3RMnFwTJRVcYLLZdjkIx43E8Zn2hRng==";
      };
    };
    "typescript-4.5.4" = {
      name = "typescript";
      packageName = "typescript";
      version = "4.5.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/typescript/-/typescript-4.5.4.tgz";
        sha512 = "VgYs2A2QIRuGphtzFV7aQJduJ2gyfTljngLzjpfW9FoYZF6xuw1W0vW9ghCKLfcWrCFxK81CSGRAvS1pn4fIUg==";
      };
    };
    "vscode-css-languageservice-5.1.9" = {
      name = "vscode-css-languageservice";
      packageName = "vscode-css-languageservice";
      version = "5.1.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-css-languageservice/-/vscode-css-languageservice-5.1.9.tgz";
        sha512 = "/tFOWeZBL3Oc9Zc+2MAi3rEwiXJTSZsvjB+M7nSjWLbGPUIjukUA7YzLgsBoUfR35sPJYnXWUkL56PdfIYM8GA==";
      };
    };
    "vscode-html-languageservice-4.2.1" = {
      name = "vscode-html-languageservice";
      packageName = "vscode-html-languageservice";
      version = "4.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-html-languageservice/-/vscode-html-languageservice-4.2.1.tgz";
        sha512 = "PgaToZVXJ44nFWEBuSINdDgVV6EnpC3MnXBsysR3O5TKcAfywbYeRGRy+Y4dVR7YeUgDvtb+JkJoSkaYC0mxXQ==";
      };
    };
    "vscode-json-languageservice-4.2.0-next.2" = {
      name = "vscode-json-languageservice";
      packageName = "vscode-json-languageservice";
      version = "4.2.0-next.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-json-languageservice/-/vscode-json-languageservice-4.2.0-next.2.tgz";
        sha512 = "P0sdiZS7bM8+bxrkpL7XPwwhmZj94pcJIAZUh/QeessvYtXFnRmOEybe20rC+CS7b7DfwFcVt0p4p93hGZQ5gg==";
      };
    };
    "vscode-jsonrpc-8.0.0-next.4" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "8.0.0-next.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-8.0.0-next.4.tgz";
        sha512 = "i+wvza5Wd0YV/t9qhnS8I+dJdhJ1fHIhRW4f262rXXM9Mgts5VZhYrRZufGcai4y99RlbZvwaZhplQ6diRXkaA==";
      };
    };
    "vscode-languageserver-8.0.0-next.5" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "8.0.0-next.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-8.0.0-next.5.tgz";
        sha512 = "3E2W0eWtGKb6QAJqspOnD0thrBRRo8IGUMV5jpDNMcMKvmtkcxMwsBh0VxdvuWaZ51PiNyR4L+B+GUvkYsyFEg==";
      };
    };
    "vscode-languageserver-protocol-3.17.0-next.11" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.17.0-next.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.0-next.11.tgz";
        sha512 = "9FqHT7XvM6tWFsnLvRfuQA7Zh7wZZYAwA9dK85lYthA8M1aXpXEP9drXVvO/Fe03MUeJpKVf2e4/NvDaFUnttg==";
      };
    };
    "vscode-languageserver-textdocument-1.0.3" = {
      name = "vscode-languageserver-textdocument";
      packageName = "vscode-languageserver-textdocument";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.3.tgz";
        sha512 = "ynEGytvgTb6HVSUwPJIAZgiHQmPCx8bZ8w5um5Lz+q5DjP0Zj8wTFhQpyg8xaMvefDytw2+HH5yzqS+FhsR28A==";
      };
    };
    "vscode-languageserver-types-3.16.0" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0.tgz";
        sha512 = "k8luDIWJWyenLc5ToFQQMaSrqCHiLwyKPHKPQZ5zz21vM+vIVUSvsRpcbiECH4WR88K2XZqc4ScRcZ7nk/jbeA==";
      };
    };
    "vscode-languageserver-types-3.17.0-next.5" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.17.0-next.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.0-next.5.tgz";
        sha512 = "Zcfaw8BznhlJWB09LDR0dscXyxn9+liREqJnPF4pigeUCHwKxYapYqizwuCpMHQ/oLYiAvKwU+f28hPleYu7pA==";
      };
    };
    "vscode-nls-5.0.0" = {
      name = "vscode-nls";
      packageName = "vscode-nls";
      version = "5.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-nls/-/vscode-nls-5.0.0.tgz";
        sha512 = "u0Lw+IYlgbEJFF6/qAqG2d1jQmJl0eyAGJHoAJqr2HT4M2BNuQYSEiSE75f52pXHSJm8AlTjnLLbBFPrdz2hpA==";
      };
    };
    "vscode-uri-3.0.3" = {
      name = "vscode-uri";
      packageName = "vscode-uri";
      version = "3.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.3.tgz";
        sha512 = "EcswR2S8bpR7fD0YPeS7r2xXExrScVMxg4MedACaWHEtx9ftCF/qHG1xGkolzTPcEmjTavCQgbVzHUIdTMzFGA==";
      };
    };
    "yarn-1.22.17" = {
      name = "yarn";
      packageName = "yarn";
      version = "1.22.17";
      src = fetchurl {
        url = "https://registry.npmjs.org/yarn/-/yarn-1.22.17.tgz";
        sha512 = "H0p241BXaH0UN9IeH//RT82tl5PfNraVpSpEoW+ET7lmopNC61eZ+A+IDvU8FM6Go5vx162SncDL8J1ZjRBriQ==";
      };
    };
  };
in
{
  vscode-langservers-extracted = nodeEnv.buildNodePackage {
    name = "vscode-langservers-extracted";
    packageName = "vscode-langservers-extracted";
    version = "4.0.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/vscode-langservers-extracted/-/vscode-langservers-extracted-4.0.0.tgz";
      sha512 = "DTFhpzUhP3M5WA62WT/SVSxtq47R5rbIEznA7svxWD19/+D1iGBrrzAa8LrDCkLUMxyG3gbya99LczV4F9m6Yg==";
    };
    dependencies = [
      sources."core-js-3.20.2"
      sources."jsonc-parser-3.0.0"
      sources."regenerator-runtime-0.13.9"
      sources."request-light-0.5.6"
      sources."typescript-4.5.4"
      sources."vscode-css-languageservice-5.1.9"
      sources."vscode-html-languageservice-4.2.1"
      sources."vscode-json-languageservice-4.2.0-next.2"
      sources."vscode-jsonrpc-8.0.0-next.4"
      sources."vscode-languageserver-8.0.0-next.5"
      (sources."vscode-languageserver-protocol-3.17.0-next.11" // {
        dependencies = [
          sources."vscode-languageserver-types-3.17.0-next.5"
        ];
      })
      sources."vscode-languageserver-textdocument-1.0.3"
      sources."vscode-languageserver-types-3.16.0"
      sources."vscode-nls-5.0.0"
      sources."vscode-uri-3.0.3"
      sources."yarn-1.22.17"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "HTML/CSS/JSON language servers extracted from [vscode](https://github.com/Microsoft/vscode).";
      homepage = "https://github.com/hrsh7th/vscode-langservers-extracted#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}