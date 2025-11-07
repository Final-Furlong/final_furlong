import { defineConfig, globalIgnores } from "eslint/config";
import globals from "globals";
import babelParser from "@babel/eslint-parser";
import path from "node:path";
import { fileURLToPath } from "node:url";
import js from "@eslint/js";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

export default defineConfig([globalIgnores([
    "**/test/**/*.js",
    "**/public/assets",
    "**/public/packs",
    "**/public/packs-test",
    "**/vendor/bundle",
    "**/vendor/javascript",
    "**/node_modules",
]), {
    extends: compat.extends("eslint:recommended", "plugin:prettier/recommended"),

    languageOptions: {
        globals: {
            ...globals.browser,
            ...globals.node,
            ...globals.commonjs,
            ...globals.jquery,
        },

        parser: babelParser,
        ecmaVersion: 5,
        sourceType: "module",

        parserOptions: {
            allowImportExportEverywhere: true,
            requireConfigFile: false,
        },
    },

    rules: {
        "prettier/prettier": "error",
    },
}]);