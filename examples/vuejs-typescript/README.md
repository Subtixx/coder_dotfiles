# Vue.js + TypeScript Project Development Setup

This is an example configuration for a Vue.js project with TypeScript.

## Prerequisites

Make sure you have installed the dotfiles:
```bash
cd ~/coder_dotfiles
./install.sh
./install-dev-tools.sh
```

## Quick Start

1. Copy `.tool-versions` to your project root
2. Install required versions:
   ```bash
   asdf install
   ```

3. Create a new Vue.js project:
   ```bash
   # Using Vue CLI
   vue create my-vue-app
   
   # Or using Vite (recommended)
   npm create vite@latest my-vue-app -- --template vue-ts
   cd my-vue-app
   ```

4. Copy `.tool-versions` to your project
5. Install dependencies:
   ```bash
   npm install
   # or
   yarn install
   ```

6. Start development server:
   ```bash
   npm run dev
   # or
   yarn dev
   ```

## Useful Aliases

The dotfiles include these Node.js/npm aliases:

- `ni` - npm install
- `nr` - npm run
- `nrd` - npm run dev
- `nrb` - npm run build
- `yi` - yarn install
- `yr` - yarn run
- `yrd` - yarn run dev
- `yrb` - yarn run build

## Project Structure (Typical Vite + Vue 3)

```
my-vue-app/
├── src/
│   ├── assets/         # Static assets
│   ├── components/     # Vue components
│   ├── views/          # Page views
│   ├── router/         # Vue Router config
│   ├── stores/         # Pinia stores
│   ├── types/          # TypeScript types
│   ├── App.vue         # Root component
│   └── main.ts         # Entry point
├── public/             # Public static files
├── .tool-versions      # asdf version config
├── package.json
├── tsconfig.json       # TypeScript config
├── vite.config.ts      # Vite config
└── index.html
```

## Development Workflow

1. Start tmux session:
   ```bash
   tmux new -s vue
   ```

2. Split panes (prefix + |):
   - Pane 1: Dev server (`nrd`)
   - Pane 2: Tests in watch mode (`nr test:watch`)
   - Pane 3: Git/commands

3. Save tmux session (prefix + Ctrl+s)

## TypeScript Configuration

Example `tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "module": "ESNext",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "preserve",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src/**/*.ts", "src/**/*.d.ts", "src/**/*.tsx", "src/**/*.vue"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```

## Recommended VS Code Extensions

- Volar (Vue Language Features)
- TypeScript Vue Plugin
- ESLint
- Prettier
- Auto Rename Tag
- Path Intellisense

## Useful Commands

```bash
# Install dependencies
npm install
# or
yarn install

# Run development server
npm run dev
yarn dev

# Build for production
npm run build
yarn build

# Preview production build
npm run preview
yarn preview

# Run linting
npm run lint
yarn lint

# Run type checking
npm run type-check
yarn type-check

# Run tests
npm run test
yarn test
```

## Code Quality

### ESLint Configuration

The dotfiles include ESLint. Add to `package.json`:
```json
{
  "scripts": {
    "lint": "eslint . --ext .vue,.js,.jsx,.cjs,.mjs,.ts,.tsx,.cts,.mts --fix"
  }
}
```

### Prettier Configuration

Create `.prettierrc`:
```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

## State Management with Pinia

Install Pinia:
```bash
npm install pinia
yarn add pinia
```

Example store:
```typescript
// src/stores/counter.ts
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', {
  state: () => ({
    count: 0
  }),
  actions: {
    increment() {
      this.count++
    }
  }
})
```

## Routing with Vue Router

Install Vue Router:
```bash
npm install vue-router@4
yarn add vue-router@4
```

## Testing

### Vitest (Recommended)

Install:
```bash
npm install -D vitest @vue/test-utils jsdom
yarn add -D vitest @vue/test-utils jsdom
```

### Cypress (E2E Testing)

Install:
```bash
npm install -D cypress
yarn add -D cypress
```

## Deployment

Build for production:
```bash
npm run build
yarn build
```

The built files will be in the `dist/` directory.

## Common Issues

### Port Already in Use

Change port in `vite.config.ts`:
```typescript
export default defineConfig({
  server: {
    port: 3001
  }
})
```

### Module Resolution Issues

Check `tsconfig.json` paths configuration.
