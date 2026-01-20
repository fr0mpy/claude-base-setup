#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const TEMPLATES_DIR = path.join(__dirname, '..', 'templates');
const TARGET_DIR = path.join(process.cwd(), '.claude');
const ENV_FILE = path.join(process.cwd(), '.env');
const args = process.argv.slice(2);

// Parse flags
const hasFlag = (...flags) => flags.some((f) => args.includes(f));
const skipApiKey = hasFlag('--skip-api-key', '--no-api-key', '-s');
const forceMode = hasFlag('--force', '-f');
const removeMode = hasFlag('--remove', '--uninstall', '-r');
const helpMode = hasFlag('--help', '-h');
const updateHooks = hasFlag('--update-hooks');
const updateAgents = hasFlag('--update-agents');
const updateRules = hasFlag('--update-rules');
const updateCommands = hasFlag('--update-commands');
const updateMode = updateHooks || updateAgents || updateRules || updateCommands;

function copyDir(src, dest) {
  fs.mkdirSync(dest, { recursive: true });

  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

function copySubdir(subdir) {
  const src = path.join(TEMPLATES_DIR, subdir);
  const dest = path.join(TARGET_DIR, subdir);

  if (!fs.existsSync(src)) {
    console.error(`❌ Source directory not found: ${subdir}`);
    return false;
  }

  if (fs.existsSync(dest)) {
    fs.rmSync(dest, { recursive: true });
  }

  copyDir(src, dest);
  return true;
}

function makeExecutable(dir) {
  const hooksDir = path.join(dir, 'hooks');
  if (fs.existsSync(hooksDir)) {
    const files = fs.readdirSync(hooksDir);
    for (const file of files) {
      if (file.endsWith('.sh')) {
        const filePath = path.join(hooksDir, file);
        fs.chmodSync(filePath, 0o755);
      }
    }
  }
}

function prompt(question) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.trim());
    });
  });
}

const DEFAULT_MODEL = 'claude-3-5-haiku-latest';

function saveEnvVar(name, value) {
  let envContent = '';

  if (fs.existsSync(ENV_FILE)) {
    envContent = fs.readFileSync(ENV_FILE, 'utf8');
    const regex = new RegExp(`^${name}=.*$`, 'gm');
    if (regex.test(envContent)) {
      envContent = envContent.replace(regex, `${name}=${value}`);
    } else {
      envContent += `${envContent.endsWith('\n') ? '' : '\n'}${name}=${value}\n`;
    }
  } else {
    envContent = `${name}=${value}\n`;
  }

  fs.writeFileSync(ENV_FILE, envContent);
}

function saveApiKey(apiKey) {
  saveEnvVar('ANTHROPIC_API_KEY', apiKey);
}

function saveModel(model) {
  saveEnvVar('ANTHROPIC_MODEL', model);
}

function updateSettingsForLLM(useLLM) {
  const settingsPath = path.join(TARGET_DIR, 'settings.json');
  if (!fs.existsSync(settingsPath)) return;

  let settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));

  const hookScript = useLLM
    ? '.claude/hooks/smart-inject-llm.sh'
    : '.claude/hooks/smart-inject-rules.sh';

  if (settings.hooks?.UserPromptSubmit?.[0]?.hooks?.[0]) {
    settings.hooks.UserPromptSubmit[0].hooks[0].command = hookScript;
  }

  fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + '\n');
}

async function init() {
  console.log('🔧 Initializing Claude Code base setup...\n');

  if (fs.existsSync(TARGET_DIR) && !forceMode) {
    console.log('⚠️  .claude directory already exists.');
    console.log('   Use --force to overwrite, or use selective updates:');
    console.log('   --update-hooks, --update-agents, --update-rules, --update-commands\n');
    process.exit(1);
  }

  if (!fs.existsSync(TEMPLATES_DIR)) {
    console.error('❌ Templates directory not found. Package may be corrupted.');
    process.exit(1);
  }

  if (forceMode && fs.existsSync(TARGET_DIR)) {
    fs.rmSync(TARGET_DIR, { recursive: true });
    console.log('🗑️  Removed existing .claude directory.\n');
  }

  copyDir(TEMPLATES_DIR, TARGET_DIR);
  makeExecutable(TARGET_DIR);

  console.log('✅ Created .claude/ directory with:');
  console.log('   📁 hooks/     - Smart context injection');
  console.log('   📁 rules/     - Behavioral guidelines');
  console.log('   📁 agents/    - Task workers');
  console.log('   📁 commands/  - Slash commands (/review, /test, /commit)');
  console.log('   📄 settings.json');
  console.log('   📄 CLAUDE.md\n');

  // Handle API key
  if (skipApiKey) {
    console.log('⏭️  Skipped API key prompt (--skip-api-key).');
    console.log('   Using keyword-based injection.\n');
    updateSettingsForLLM(false);
  } else {
    console.log('🔑 Smart injection uses Claude Haiku for semantic rule matching.');
    console.log('   This requires an Anthropic API key.\n');

    const apiKey = await prompt(
      '   Enter your ANTHROPIC_API_KEY (or press Enter to skip): '
    );

    if (apiKey) {
      saveApiKey(apiKey);
      saveModel(DEFAULT_MODEL);
      updateSettingsForLLM(true);
      console.log('\n   ✅ API key saved to .env');
      console.log(`   ✅ Model set to ${DEFAULT_MODEL}`);
      console.log('   ✅ Enabled LLM-powered smart injection');
      console.log('   💡 Add .env to your .gitignore if not already there.');
      console.log('   💡 Change ANTHROPIC_MODEL in .env to use a different model.\n');
    } else {
      console.log('\n   ⏭️  Skipped. Using keyword-based injection.');
      console.log(
        '   💡 Set ANTHROPIC_API_KEY env var later to enable LLM-powered injection.\n'
      );
      updateSettingsForLLM(false);
    }
  }

  console.log('🚀 Ready! Claude Code will now use these rules and agents.\n');
}

async function update() {
  if (!fs.existsSync(TARGET_DIR)) {
    console.error('❌ .claude directory not found. Run without flags to initialize first.');
    process.exit(1);
  }

  console.log('🔄 Updating selected components...\n');

  const updates = [];

  if (updateHooks) {
    if (copySubdir('hooks')) {
      makeExecutable(TARGET_DIR);
      updates.push('hooks');
    }
  }
  if (updateAgents && copySubdir('agents')) updates.push('agents');
  if (updateRules && copySubdir('rules')) updates.push('rules');
  if (updateCommands && copySubdir('commands')) updates.push('commands');

  if (updates.length > 0) {
    console.log(`✅ Updated: ${updates.join(', ')}\n`);
    console.log('💡 Your settings.json and CLAUDE.md were preserved.\n');
  } else {
    console.log('⚠️  No components updated.\n');
  }
}

function remove() {
  if (!fs.existsSync(TARGET_DIR)) {
    console.log('ℹ️  .claude directory does not exist. Nothing to remove.\n');
    return;
  }

  fs.rmSync(TARGET_DIR, { recursive: true });
  console.log('✅ Removed .claude directory.\n');
  console.log('💡 Note: .env file (if created) was not removed.\n');
}

function showHelp() {
  console.log(`
claude-base-setup - Initialize .claude configuration for Claude Code

Usage:
  npx claude-base-setup              Initialize .claude in current directory
  npx claude-base-setup --force      Overwrite existing .claude directory
  npx claude-base-setup --remove     Remove .claude directory
  npx claude-base-setup --skip-api-key  Skip API key prompt (CI/automation)

Selective updates (preserves settings.json and CLAUDE.md):
  npx claude-base-setup --update-hooks     Update only hooks/
  npx claude-base-setup --update-agents    Update only agents/
  npx claude-base-setup --update-rules     Update only rules/
  npx claude-base-setup --update-commands  Update only commands/

Options:
  -h, --help          Show this help message
  -f, --force         Overwrite existing .claude directory
  -r, --remove        Remove .claude directory (alias: --uninstall)
  -s, --skip-api-key  Skip API key prompt (alias: --no-api-key)

What's included:
  • hooks/     Smart context injection on every prompt
  • rules/     Behavioral guidelines (code standards, etc.)
  • agents/    Task workers (pre-code-check, package-checker, etc.)
  • commands/  Slash commands (/review, /test, /commit)
  • CLAUDE.md  Project context (auto-loaded by Claude)

Learn more: https://github.com/fr0mpy/claude-base-setup
`);
}

async function main() {
  if (helpMode) {
    showHelp();
  } else if (removeMode) {
    remove();
  } else if (updateMode) {
    await update();
  } else {
    await init();
  }
}

main();
