const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const assert = require('assert');

const CLI_PATH = path.join(__dirname, '..', 'bin', 'cli.js');
const TEST_DIR = path.join(__dirname, 'test-project');
const CLAUDE_DIR = path.join(TEST_DIR, '.claude');

function setup() {
  if (fs.existsSync(TEST_DIR)) {
    fs.rmSync(TEST_DIR, { recursive: true });
  }
  fs.mkdirSync(TEST_DIR, { recursive: true });
}

function cleanup() {
  if (fs.existsSync(TEST_DIR)) {
    fs.rmSync(TEST_DIR, { recursive: true });
  }
}

function run(args = '', options = {}) {
  const cmd = `node "${CLI_PATH}" ${args}`;
  return execSync(cmd, {
    cwd: TEST_DIR,
    encoding: 'utf8',
    env: { ...process.env, ...options.env },
    input: options.input || '\n', // Default: press Enter to skip API key
  });
}

// Test: --help flag
console.log('Test: --help shows usage information');
setup();
try {
  const output = run('--help');
  assert(output.includes('claude-base-setup'), 'Should include package name');
  assert(output.includes('--force'), 'Should mention --force flag');
  assert(output.includes('--remove'), 'Should mention --remove flag');
  assert(output.includes('--skip-api-key'), 'Should mention --skip-api-key flag');
  assert(output.includes('--update-hooks'), 'Should mention --update-hooks flag');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: Basic initialization with --skip-api-key
console.log('Test: Basic initialization creates .claude directory');
setup();
try {
  const output = run('--skip-api-key');
  assert(fs.existsSync(CLAUDE_DIR), '.claude directory should exist');
  assert(fs.existsSync(path.join(CLAUDE_DIR, 'hooks')), 'hooks/ should exist');
  assert(fs.existsSync(path.join(CLAUDE_DIR, 'rules')), 'rules/ should exist');
  assert(fs.existsSync(path.join(CLAUDE_DIR, 'agents')), 'agents/ should exist');
  assert(fs.existsSync(path.join(CLAUDE_DIR, 'commands')), 'commands/ should exist');
  assert(fs.existsSync(path.join(CLAUDE_DIR, 'settings.json')), 'settings.json should exist');
  assert(fs.existsSync(path.join(CLAUDE_DIR, 'CLAUDE.md')), 'CLAUDE.md should exist');
  assert(output.includes('Created .claude/'), 'Should confirm creation');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: Fails when .claude already exists (without --force)
console.log('Test: Fails when .claude already exists');
setup();
try {
  run('--skip-api-key'); // First init
  try {
    run('--skip-api-key'); // Second init should fail
    assert.fail('Should have thrown an error');
  } catch (e) {
    assert(e.message.includes('already exists') || e.status === 1, 'Should fail with exit code 1');
  }
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: --force overwrites existing directory
console.log('Test: --force overwrites existing directory');
setup();
try {
  run('--skip-api-key');
  // Add a custom file
  fs.writeFileSync(path.join(CLAUDE_DIR, 'custom.txt'), 'test');
  assert(fs.existsSync(path.join(CLAUDE_DIR, 'custom.txt')), 'Custom file should exist');

  run('--force --skip-api-key');
  assert(fs.existsSync(CLAUDE_DIR), '.claude should still exist');
  assert(!fs.existsSync(path.join(CLAUDE_DIR, 'custom.txt')), 'Custom file should be removed');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: --remove deletes .claude directory
console.log('Test: --remove deletes .claude directory');
setup();
try {
  run('--skip-api-key');
  assert(fs.existsSync(CLAUDE_DIR), '.claude should exist');

  run('--remove');
  assert(!fs.existsSync(CLAUDE_DIR), '.claude should be removed');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: --update-agents only updates agents directory
console.log('Test: --update-agents only updates agents/');
setup();
try {
  run('--skip-api-key');

  // Modify settings.json (should be preserved)
  const settingsPath = path.join(CLAUDE_DIR, 'settings.json');
  const customSettings = { custom: true };
  fs.writeFileSync(settingsPath, JSON.stringify(customSettings));

  // Modify an agent (should be replaced)
  const agentPath = path.join(CLAUDE_DIR, 'agents', 'package-checker.md');
  fs.writeFileSync(agentPath, 'custom content');

  run('--update-agents');

  // settings.json should be preserved
  const settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
  assert(settings.custom === true, 'settings.json should be preserved');

  // agent should be restored
  const agentContent = fs.readFileSync(agentPath, 'utf8');
  assert(agentContent.includes('package-checker'), 'Agent should be restored');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: settings.json uses keyword matching by default (--skip-api-key)
console.log('Test: --skip-api-key sets keyword-based hook in settings.json');
setup();
try {
  run('--skip-api-key');
  const settingsPath = path.join(CLAUDE_DIR, 'settings.json');
  const settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
  const hookCommand = settings.hooks?.UserPromptSubmit?.[0]?.hooks?.[0]?.command;
  assert(
    hookCommand === '.claude/hooks/smart-inject-rules.sh',
    `Should use keyword hook, got: ${hookCommand}`
  );
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: Shell scripts are executable
console.log('Test: Shell scripts have executable permissions');
setup();
try {
  run('--skip-api-key');
  const hooksDir = path.join(CLAUDE_DIR, 'hooks');
  const files = fs.readdirSync(hooksDir).filter((f) => f.endsWith('.sh'));

  for (const file of files) {
    const filePath = path.join(hooksDir, file);
    const stats = fs.statSync(filePath);
    const isExecutable = (stats.mode & 0o111) !== 0;
    assert(isExecutable, `${file} should be executable`);
  }
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: Permissions in settings.json are generic (not Expo-specific)
console.log('Test: settings.json has generic permissions (not Expo-specific)');
setup();
try {
  run('--skip-api-key');
  const settingsPath = path.join(CLAUDE_DIR, 'settings.json');
  const settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
  const permissions = settings.permissions?.allow || [];

  const hasExpo = permissions.some((p) => p.includes('expo'));
  assert(!hasExpo, 'Should not have Expo-specific permissions');

  const hasGit = permissions.some((p) => p.includes('git'));
  assert(hasGit, 'Should have git permissions');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: Skills directory is created with styling skill
console.log('Test: skills/ directory is created with styling.md');
setup();
try {
  run('--skip-api-key');
  const skillsDir = path.join(CLAUDE_DIR, 'skills');
  assert(fs.existsSync(skillsDir), 'skills/ directory should exist');

  const stylingSkill = path.join(skillsDir, 'styling.md');
  assert(fs.existsSync(stylingSkill), 'skills/styling.md should exist');

  const content = fs.readFileSync(stylingSkill, 'utf8');
  assert(content.includes('Styling System'), 'Should contain Styling System header');
  assert(content.includes('styling-config.json'), 'Should reference config file');
  assert(content.includes('component-recipes'), 'Should reference component recipes');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: Component recipes directory exists
console.log('Test: component-recipes/ directory exists with recipes');
setup();
try {
  run('--skip-api-key');
  const recipesDir = path.join(CLAUDE_DIR, 'component-recipes');
  assert(fs.existsSync(recipesDir), 'component-recipes/ directory should exist');

  const recipes = fs.readdirSync(recipesDir).filter(f => f.endsWith('.md'));
  assert(recipes.length > 0, 'Should have at least one recipe');
  assert(recipes.includes('button.md'), 'Should include button.md');
  assert(recipes.includes('card.md'), 'Should include card.md');
  assert(recipes.includes('input.md'), 'Should include input.md');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Test: Styling rule no longer exists (migrated to skill)
console.log('Test: styling-system.md rule does not exist (migrated to skill)');
setup();
try {
  run('--skip-api-key');
  const oldRulePath = path.join(CLAUDE_DIR, 'rules', 'styling-system.md');
  assert(!fs.existsSync(oldRulePath), 'styling-system.md rule should not exist');
  console.log('  ✅ PASSED\n');
} catch (e) {
  console.log('  ❌ FAILED:', e.message, '\n');
  process.exitCode = 1;
}

// Cleanup
cleanup();

console.log('All tests completed!');
