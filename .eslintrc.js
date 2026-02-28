module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: ['eslint:recommended'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    'no-console': 'warn',
  },
  globals: {
    Stimulus: 'readonly',
    Turbo: 'readonly',
  },
  ignorePatterns: ['.eslintrc.js', '.stylelintrc.js'],
};
