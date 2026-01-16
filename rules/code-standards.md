<!-- SUMMARY: Dynamic, scalable code - no hardcoding, discover don't assume -->
<!-- TRIGGER: code -->
# RULE: Code Standards - Dynamic & Scalable

⚠️ **ALWAYS-ACTIVE RULE** - Applies to every code generation.

## 🔐 Enforcement

**For EVERY piece of code, you MUST:**
1. No hardcoded values - use constants/config/theme
2. Discover structure dynamically - never assume paths exist
3. Single responsibility per file
4. Code must work regardless of project size

---

## Dynamic Patterns

| ❌ Hardcoded/Assumed | ✅ Dynamic/Discovered |
|----------------------|----------------------|
| `src/components/*.tsx` | Glob for `**/*.tsx`, group by directory |
| `if (items.length === 3)` | `if (items.length === expectedCount)` |
| `users[0], users[1]` | `users.map()` or `users.forEach()` |
| `case 'admin': case 'user':` | `ROLES.includes(role)` |
| Fixed array indices | Iterate or find by property |

---

## Value Mapping

| ❌ Hardcoded | ✅ Use Instead |
|--------------|----------------|
| `'#007AFF'` | `theme.colors.primary` |
| `padding: 16` | `theme.spacing.md` |
| `'https://api...'` | `config.API_BASE_URL` |
| `'Invalid email'` | `MESSAGES.INVALID_EMAIL` |
| `if (x > 50)` | `if (x > CONFIG.THRESHOLD)` |

---

## Scalability Principles

1. **Discover, don't assume** - Scan for what exists, don't hardcode paths
2. **Iterate, don't index** - Use `.map()`, `.filter()`, `.find()` not `[0]`, `[1]`
3. **Configure, don't embed** - Values that might change go in config
4. **Categorize by pattern** - Group by naming convention, not explicit list

---

## Quick Examples

**File Discovery:**
```typescript
// ❌ const screens = ['Home', 'Settings', 'Profile']
// ✅ const screens = await glob('**/screens/**/*.tsx')
```

**Iteration:**
```typescript
// ❌ processItem(items[0]); processItem(items[1]);
// ✅ items.forEach(item => processItem(item))
```

**Role Checks:**
```typescript
// ❌ if (role === 'admin' || role === 'superadmin')
// ✅ if (ELEVATED_ROLES.includes(role))
```

**Path Building:**
```typescript
// ❌ const path = 'src/components/' + name + '.tsx'
// ✅ const path = join(SRC_DIR, 'components', `${name}.tsx`)
```
