# Fast96 - 96-Hour Fasting App
> Auto-generated: 2026-01-16

## Quick Stats
- **Type**: React Native + Expo mobile app (iOS/Android/Web)
- **Size**: 73 source files, 4,596 lines of TypeScript/TSX
- **Status**: Foundational setup complete, 5 TODOs for Supabase integration
- **Tech**: Expo 54, React 19, React Navigation 7, Zustand, Supabase

## Stack
- **Runtime**: React Native 0.81, Expo SDK 54
- **Language**: TypeScript 5.9
- **State Management**: Zustand (auth, fasts, settings)
- **Navigation**: React Navigation (bottom tabs + native stack)
- **Backend**: Supabase (PostgreSQL)
- **Styling**: Theme-based (night/day), design tokens
- **Fonts**: Expo Google Fonts (Inter)
- **Storage**: Async Storage, Expo Secure Store

## Project Structure
```
fast96-app/
├── App.tsx                          # Root app wrapper
├── index.ts                         # Expo entry point
├── app.json                         # Expo config
├── package.json                     # Dependencies
├── src/
│   ├── components/                  # 4 UI primitives (Button, Card, Input, Text)
│   ├── config/                      # App, Supabase config
│   ├── constants/                   # Messages, prompts, education data
│   ├── hooks/                       # Custom React hooks (empty)
│   ├── navigation/                  # 8 navigators (auth, main, tabs, screens)
│   ├── screens/                     # 20 screens across 6 domains
│   │   ├── auth/                    # SignIn, SignUp, Welcome
│   │   ├── fast/                    # Active, BreakFast, Completed, StartFast, DayInfo
│   │   ├── tracking/                # Journal, JournalEntry, WaterTracker
│   │   ├── refeed/                  # RefeedPlanner, RefeedMeal
│   │   ├── ai/                      # AIPrompts
│   │   └── community/               # ChatRoom, Profile (empty files)
│   ├── services/                    # Supabase integration (auth, client, fasts)
│   ├── store/                       # Zustand stores (auth, fasts, settings)
│   ├── theme/                       # Design system (night/day themes, fonts)
│   ├── types/                       # Models, navigation, database types
│   └── utils/                       # Validation, mappers, time, helpers
└── assets/                          # Icons, splash, favicons
```

## Key Directories

### Screens (20 files)
- **Authentication** (3): SignInScreen, SignUpScreen, WelcomeScreen
- **Fasting** (5): ActiveFastScreen, BreakFastScreen, CompletedScreen, StartFastScreen, DayInfoScreen
- **Tracking** (3): JournalScreen, JournalEntryScreen, WaterTrackerScreen
- **Refeed** (2): RefeedPlannerScreen, RefeedMealScreen
- **AI** (1): AIPromptsScreen
- **Community** (2): ChatRoomScreen, ProfileScreen (stubs)

### Navigation (8 files)
RootNavigator → AuthNavigator (pre-login) | MainNavigator (post-login) → Bottom tabs:
- FastNavigator (fasting flow)
- TrackNavigator (tracking flow)
- RefeedNavigator (meal planning)
- ChatNavigator (AI & community)
- SettingsNavigator (account, notifications, privacy)

### State Management (Zustand)
- **authStore**: User session, login/logout
- **fastStore**: Active fasts, history, CRUD operations
- **settingsStore**: User preferences, notifications

### Styling Approach
- Theme-based design tokens (spacing, colors, typography, shadows)
- Night mode default (dark UI with surgical precision)
- Day mode fallback (light UI)
- Colors: Primary blue (#4A90E2), status green/orange/red
- Spacing scale: xs(4) → sm(8) → md(16) → lg(24) → xl(32) → xxl(48)
- Typography: 3 weights (400, 500, 600), 6 sizes (12-32px)

### Services
- **Supabase client**: Auth, session management, CRUD
- **Auth service**: Sign up, sign in, password reset
- **Fasts service**: Create, update, list, complete fasts

## Needs Work
5 TODOs identified:

| File | Issue |
|------|-------|
| `screens/fast/ActiveFastScreen.tsx:16` | Replace with actual fast data from store |
| `screens/fast/StartFastScreen.tsx:20` | Implement with Supabase |
| `screens/fast/BreakFastScreen.tsx:17` | Implement with Supabase |
| `screens/tracking/JournalEntryScreen.tsx:18` | Save to storage |
| `screens/refeed/RefeedMealScreen.tsx:21` | Save to storage |

Additionally:
- `src/screens/community/` screens are stubs (empty files)
- `src/hooks/index.ts` is empty (no custom hooks yet)

## Detected Patterns

### Data Models
- User: ID, email, displayName, completedFasts count, timezone
- Fast: ID, userId, startTime, endTime, targetHours (96), motivation, status (active/completed/broken), isPublic
- Message: ID, userId, content, reactions (for community chat)
- PublicFast: Stripped-down fast info for feed visibility

### Navigation Pattern
Modular navigators per feature, composed in RootNavigator. Auth/main split at top level.

### Theme Integration
All colors/spacing/typography centralized in `theme/themes.ts`. Components reference `theme` via context.

### Constants
Centralized in `constants/` → messages (UI text), prompts (AI), education (fasting knowledge)

## Git Status
- Main: fast96-app (Expo project)
- Recent commits: Initial setup, removed root package-lock.json
- No pending changes (fresh checkout)
