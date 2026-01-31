module.exports = {
  ignores: ["node_modules/", "dist/", ".git/", ".direnv/"],
  languageOptions: {
    ecmaVersion: "latest",
    sourceType: "module",
    globals: {
      console: "readonly",
      process: "readonly",
      Buffer: "readonly",
    },
  },
  rules: {
    indent: ["error", 2],
    "linebreak-style": ["error", "unix"],
    quotes: ["error", "double"],
    semi: ["error", "always"],
    "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
    "no-console": "off",
    eqeqeq: ["warn", "always"],
  },
};
