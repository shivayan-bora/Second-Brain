---
id: Mastering pnpm Workspaces
aliases: []
tags:
  - article
creation date: 2026-05-31 19:52
modification date: Sunday 31st May 2026 19:52:33
source: https://blog.glen-thomas.com/software%20engineering/2025/10/02/mastering-pnpm-workspaces-complete-guide-to-monorepo-management.html
status:
  - completed
---

## What are pnpm Workspaces?

- [[pnpm Workspaces]] is a [[Monorepo]] solution that allows us to manage multiple packages within a single repository while sharing dependencies efficiently.
- Unlike [[npm]] or [[Yarn]], [[pnpm]] uses a unique content-addressable store that creates hard-links to shared dependencies, dramatically reducing disk usage and installation time.

### Key Benefits of pnpm Workspaces

- **Disk Efficiency**: Shared dependencies are stored once and linked across projects
- **Fast Installations**: Hard linking eliminates duplicate downloads and extractions
- **Strict Dependency Management**: Prevents phantom dependencies and version conflicts
- **Seamless Hoisting**: Intelligent dependency hoisting without the pitfalls
- **Built-in Monorepo Support**: No additional tools needed for workspace management

## Setting up our monorepo

```
my-workspace/
├── apps/
│   ├── web-app/          # React frontend
│   ├── api-server/       # Node.js backend
│   └── mobile-app/       # React Native app
├── packages/
│   ├── ui-components/    # Shared React components
│   ├── utils/           # Shared utilities
│   └── api-client/      # API client library
├── tools/
│   └── eslint-config/   # Shared ESLint configuration
├── package.json
└── pnpm-workspace.yaml
```

### Step 1: Initialize the Workspace

```bash
mkdir my-workspace
cd my-workspace
pnpm init
```

### Step 2: Configure your Workspace

- Create the configuration file and update the root `package.json` file as follows:

```yaml
packages:
  - "apps/*" # Registers app package
  - "packages/*" # Registers packages package
  - "tools/*" # Registers tools package
```

```json
{
  "name": "pnpm-monorepo",
  "version": "1.0.0",
  "description": "",
  "private": true,
  "scripts": {
    "build": "pnpm -r build",
    "test": "pnpm -r test",
    "dev": "pnpm -r --parallel dev",
    "lint": "pnpm -r lint",
    "clean": "pnpm -r clean",
    "type-check": "pnpm -r type-check"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "tsup": "^7.0.0",
    "vitest": "^0.34.0"
  },
  "packageManager": "pnpm@10.34.1"
}
```

- Run `pnpm install`.

### Step 3: Create Shared Packages

#### Shared Utilities Package

```bash
mkdir -p packages/utils
cd packages/utils
pnpm init
```

```json
{
  "name": "@workspace/utils",
  "version": "1.0.0",
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.js",
      "types": "./dist/index.d.ts"
    }
  },
  "scripts": {
    "build": "tsup src/index.ts --format cjs,esm --dts",
    "dev": "tsup src/index.ts --format cjs,esm --dts --watch",
    "test": "vitest",
    "clean": "rm -rf dist"
  },
  "devDependencies": {
    "typescript": "workspace:*",
    "tsup": "workspace:*",
    "vitest": "workspace:*"
  }
}
```

- Create the utility functions:

```ts
// packages/utils/src/index.ts
export function formatCurrency(amount: number, currency = "USD"): string {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency,
  }).format(amount);
}

export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number,
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout;
  return (...args: Parameters<T>) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => func.apply(this, args), wait);
  };
}

export function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .replace(/[\s_-]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

export interface ApiResponse<T = any> {
  data: T;
  success: boolean;
  message?: string;
}

export class Logger {
  private context: string;

  constructor(context: string) {
    this.context = context;
  }

  info(message: string, ...args: any[]): void {
    console.log(`[${this.context}] ${message}`, ...args);
  }

  error(message: string, error?: Error): void {
    console.error(`[${this.context}] ${message}`, error);
  }

  warn(message: string, ...args: any[]): void {
    console.warn(`[${this.context}] ${message}`, ...args);
  }
}
```

- Add [[TypeScript]] configuration:

```json
// packages/utils/tsconfig.json
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["dist", "node_modules"]
}
```

#### UI Components Package

```bash
mkdir -p packages/ui-components
cd packages/ui-components
pnpm init
```

```json
{
  "name": "@workspace/ui-components",
  "version": "1.0.0",
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.js",
      "types": "./dist/index.d.ts"
    },
    "./styles": "./dist/styles.css"
  },
  "scripts": {
    "build": "tsup src/index.ts --format cjs,esm --dts --external react",
    "dev": "tsup src/index.ts --format cjs,esm --dts --external react --watch",
    "test": "vitest",
    "clean": "rm -rf dist"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "dependencies": {
    "@workspace/utils": "workspace:*"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "workspace:*",
    "tsup": "workspace:*",
    "vitest": "workspace:*"
  }
}
```

- Create reusable components:

```tsx
// packages/ui-components/src/Button.tsx
import React from "react";

export interface ButtonProps {
  variant?: "primary" | "secondary" | "danger";
  size?: "sm" | "md" | "lg";
  disabled?: boolean;
  loading?: boolean;
  children: React.ReactNode;
  onClick?: (event: React.MouseEvent<HTMLButtonElement>) => void;
}

export function Button({
  variant = "primary",
  size = "md",
  disabled = false,
  loading = false,
  children,
  onClick,
}: ButtonProps) {
  const baseClasses =
    "inline-flex items-center justify-center font-medium rounded-md transition-colors";
  const variantClasses = {
    primary: "bg-blue-600 text-white hover:bg-blue-700 disabled:bg-blue-300",
    secondary:
      "bg-gray-200 text-gray-900 hover:bg-gray-300 disabled:bg-gray-100",
    danger: "bg-red-600 text-white hover:bg-red-700 disabled:bg-red-300",
  };
  const sizeClasses = {
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-base",
    lg: "px-6 py-3 text-lg",
  };

  return (
    <button
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]}`}
      disabled={disabled || loading}
      onClick={onClick}
    >
      {loading && (
        <div className="animate-spin mr-2 h-4 w-4 border-2 border-white border-t-transparent rounded-full" />
      )}
      {children}
    </button>
  );
}
```

```tsx
//packages/ui-components/src/Card.tsx
import React from "react";

export interface CardProps {
  title?: string;
  children: React.ReactNode;
  className?: string;
}

export function Card({ title, children, className = "" }: CardProps) {
  return (
    <div
      className={`bg-white rounded-lg shadow-md border border-gray-200 ${className}`}
    >
      {title && (
        <div className="px-6 py-4 border-b border-gray-200">
          <h3 className="text-lg font-semibold text-gray-900">{title}</h3>
        </div>
      )}
      <div className="p-6">{children}</div>
    </div>
  );
}
```

```tsx
// packages/ui-components/src/index.ts
export { Button, type ButtonProps } from "./Button";
export { Card, type CardProps } from "./Card";
```

#### API Client Package

```bash
mkdir -p packages/api-client
cd packages/api-client
pnpm init
```

```json
{
  "name": "@workspace/api-client",
  "version": "1.0.0",
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "scripts": {
    "build": "tsup src/index.ts --format cjs,esm --dts",
    "dev": "tsup src/index.ts --format cjs,esm --dts --watch",
    "test": "vitest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "@workspace/utils": "workspace:*"
  },
  "devDependencies": {
    "typescript": "workspace:*",
    "tsup": "workspace:*",
    "vitest": "workspace:*"
  }
}
```

- Add the API Client:

```ts
// packages/api-client/src/index.ts
import { ApiResponse, Logger } from "@workspace/utils";

export class ApiClient {
  private baseUrl: string;
  private logger: Logger;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
    this.logger = new Logger("ApiClient");
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {},
  ): Promise<ApiResponse<T>> {
    const url = `${this.baseUrl}${endpoint}`;

    try {
      const response = await fetch(url, {
        headers: {
          "Content-Type": "application/json",
          ...options.headers,
        },
        ...options,
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      this.logger.info(`${options.method || "GET"} ${endpoint} - Success`);

      return {
        data,
        success: true,
      };
    } catch (error) {
      this.logger.error(
        `${options.method || "GET"} ${endpoint} - Error`,
        error as Error,
      );
      return {
        data: null,
        success: false,
        message: error instanceof Error ? error.message : "Unknown error",
      };
    }
  }

  async get<T>(endpoint: string): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint);
  }

  async post<T>(endpoint: string, data: any): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, {
      method: "POST",
      body: JSON.stringify(data),
    });
  }

  async put<T>(endpoint: string, data: any): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, {
      method: "PUT",
      body: JSON.stringify(data),
    });
  }

  async delete<T>(endpoint: string): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, {
      method: "DELETE",
    });
  }
}

export interface User {
  id: string;
  name: string;
  email: string;
  createdAt: string;
}

export interface Product {
  id: string;
  name: string;
  price: number;
  description: string;
}

export class UserService {
  constructor(private client: ApiClient) {}

  async getUsers(): Promise<ApiResponse<User[]>> {
    return this.client.get<User[]>("/users");
  }

  async getUser(id: string): Promise<ApiResponse<User>> {
    return this.client.get<User>(`/users/${id}`);
  }

  async createUser(
    userData: Omit<User, "id" | "createdAt">,
  ): Promise<ApiResponse<User>> {
    return this.client.post<User>("/users", userData);
  }
}
```

### Step 4: Create Application Packages

#### React Web Application

- This will be a [[React]] application.

```bash
mkdir -p apps/web-app
cd apps/web-app
pnpm init
```

```json
{
  "name": "@workspace/web-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "test": "vitest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@workspace/ui-components": "workspace:*",
    "@workspace/api-client": "workspace:*",
    "@workspace/utils": "workspace:*"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.0.0",
    "typescript": "workspace:*",
    "vite": "^4.4.0",
    "vitest": "workspace:*",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "tailwindcss": "^3.3.0"
  }
}
```

- Create the root [[React Components|component]]:

```tsx
// apps/web-app/src/main.tsx
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
```

- Create a simple component:

```tsx
// apps/web-app/src/App.tsx
import React, { useState, useEffect } from "react";
import { Button, Card } from "@workspace/ui-components";
import { ApiClient, UserService, User } from "@workspace/api-client";
import { formatCurrency, debounce } from "@workspace/utils";

const apiClient = new ApiClient("https://jsonplaceholder.typicode.com");
const userService = new UserService(apiClient);

function App() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");

  const debouncedSearch = debounce((term: string) => {
    console.log("Searching for:", term);
    // Implement search logic here
  }, 300);

  useEffect(() => {
    const loadUsers = async () => {
      setLoading(true);
      const response = await userService.getUsers();
      if (response.success) {
        setUsers(response.data.slice(0, 6)); // Limit to 6 users for demo
      }
      setLoading(false);
    };

    loadUsers();
  }, []);

  useEffect(() => {
    if (searchTerm) {
      debouncedSearch(searchTerm);
    }
  }, [searchTerm, debouncedSearch]);

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-6xl mx-auto px-4">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">
          pnpm Workspace Demo App
        </h1>

        <div className="mb-6">
          <input
            type="text"
            placeholder="Search users..."
            className="w-full max-w-md px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        {loading ? (
          <div className="text-center py-8">
            <div className="animate-spin h-8 w-8 border-4 border-blue-500 border-t-transparent rounded-full mx-auto"></div>
            <p className="mt-2 text-gray-600">Loading users...</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {users.map((user) => (
              <Card key={user.id} title={user.name}>
                <div className="space-y-3">
                  <p className="text-gray-600">{user.email}</p>
                  <p className="text-sm text-gray-500">
                    Joined:{" "}
                    {new Date(
                      user.createdAt || Date.now(),
                    ).toLocaleDateString()}
                  </p>
                  <p className="text-lg font-semibold text-green-600">
                    Value: {formatCurrency(Math.random() * 1000 + 100)}
                  </p>
                  <div className="flex space-x-2">
                    <Button size="sm" variant="primary">
                      View Profile
                    </Button>
                    <Button size="sm" variant="secondary">
                      Send Message
                    </Button>
                  </div>
                </div>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
```

#### Node.js API Server

```bash
mkdir -p apps/api-server
cd apps/api-server
pnpm init
```

```json
{
  "name": "@workspace/api-server",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsup src/index.ts --format cjs",
    "start": "node dist/index.js",
    "test": "vitest",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "express": "^4.18.0",
    "cors": "^2.8.0",
    "@workspace/utils": "workspace:*",
    "@workspace/api-client": "workspace:*"
  },
  "devDependencies": {
    "@types/express": "^4.17.0",
    "@types/cors": "^2.8.0",
    "typescript": "workspace:*",
    "tsup": "workspace:*",
    "tsx": "^3.12.0",
    "vitest": "workspace:*"
  }
}
```

- Create a simple server with [[Node.js]] and [[Express.js]]:

```ts
// apps/api-server/src/index.ts
import express from "express";
import cors from "cors";
import { Logger, slugify } from "@workspace/utils";
import { User, Product } from "@workspace/api-client";

const app = express();
const logger = new Logger("ApiServer");
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// Mock data
const users: User[] = [
  {
    id: "1",
    name: "John Doe",
    email: "john@example.com",
    createdAt: "2024-01-15",
  },
  {
    id: "2",
    name: "Jane Smith",
    email: "jane@example.com",
    createdAt: "2024-01-20",
  },
  {
    id: "3",
    name: "Bob Johnson",
    email: "bob@example.com",
    createdAt: "2024-02-01",
  },
];

const products: Product[] = [
  {
    id: "1",
    name: "Laptop",
    price: 999.99,
    description: "High-performance laptop",
  },
  { id: "2", name: "Phone", price: 699.99, description: "Latest smartphone" },
  {
    id: "3",
    name: "Headphones",
    price: 199.99,
    description: "Wireless headphones",
  },
];

// Routes
app.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.get("/users", (req, res) => {
  logger.info("Fetching all users");
  res.json(users);
});

app.get("/users/:id", (req, res) => {
  const user = users.find((u) => u.id === req.params.id);
  if (!user) {
    return res.status(404).json({ error: "User not found" });
  }
  logger.info(`Fetching user ${req.params.id}`);
  res.json(user);
});

app.post("/users", (req, res) => {
  const { name, email } = req.body;
  const newUser: User = {
    id: (users.length + 1).toString(),
    name,
    email,
    createdAt: new Date().toISOString(),
  };
  users.push(newUser);
  logger.info(`Created user ${newUser.id}`);
  res.status(201).json(newUser);
});

app.get("/products", (req, res) => {
  logger.info("Fetching all products");
  res.json(products);
});

app.get("/products/search", (req, res) => {
  const query = req.query.q as string;
  if (!query) {
    return res.json(products);
  }

  const searchSlug = slugify(query);
  const filtered = products.filter(
    (p) =>
      slugify(p.name).includes(searchSlug) ||
      slugify(p.description).includes(searchSlug),
  );

  logger.info(`Searching products for: ${query}`);
  res.json(filtered);
});

app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});
```

### Step 5: Shared Tools and Configuration

#### ESLint Configuration Package

```bash
mkdir -p tools/eslint-config
cd tools/eslint-config
pnpm init
```

```json
{
  "name": "@workspace/eslint-config",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "eslint-plugin-react": "^7.33.0",
    "eslint-plugin-react-hooks": "^4.6.0"
  }
}
```

- The [[ESLint]] configuration:

```js
// tools/eslint-config/index.js
module.exports = {
  parser: "@typescript-eslint/parser",
  extends: [
    "eslint:recommended",
    "@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
  ],
  plugins: ["@typescript-eslint", "react", "react-hooks"],
  rules: {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "react/react-in-jsx-scope": "off",
    "react/prop-types": "off",
  },
  settings: {
    react: {
      version: "detect",
    },
  },
};
```

### Step 6: Root Configuration Files

- Create [[TypeScript]] configuration for the workspace:

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "baseUrl": ".",
    "paths": {
      "@workspace/*": ["./packages/*/src", "./apps/*/src"]
    }
  },
  "include": ["apps/**/*", "packages/**/*", "tools/**/*"],
  "exclude": ["node_modules", "**/dist", "**/build"]
}
```

## Advanced pnpm Workspace Commands

### Installation and Dependency Management

```bash
# Install dependencies for all packages
pnpm install

# Add a dependency to a specific package
pnpm add react --filter @workspace/web-app

# Add a dev dependency to all packages
pnpm add -D prettier --filter "*"

# Add a workspace dependency
pnpm add @workspace/utils --filter @workspace/api-server
```

### Running Scripts

```bash
# Run build script in all packages
pnpm -r build

# Run dev script in parallel for all packages
pnpm -r --parallel dev

# Run script in specific package
pnpm --filter @workspace/web-app dev

# Run script in packages matching pattern
pnpm --filter "./apps/*" build
```

### Advanced Filtering

```bash
# Run commands on packages that depend on @workspace/utils
pnpm --filter "...@workspace/utils" build

# Run commands on @workspace/utils and its dependents
pnpm --filter "@workspace/utils..." build

# Run commands on changed packages (requires git)
pnpm --filter "[HEAD^1]" build
```

## Performance Benefits in Action

### Disk Usage Comparison

```bash
# Traditional approach with separate repositories
npm install  # ~200MB per project × 6 projects = ~1.2GB

# With pnpm workspace
pnpm install  # ~250MB total (shared dependencies)
```

### Installation Speed

```bash
# Cold install
time pnpm install  # ~15 seconds

# Subsequent installs (with cache)
time pnpm install  # ~2 seconds
```

### Dependency Analysis

```bash
# Check which packages use specific dependencies
pnpm list react --depth=Infinity

# Audit dependencies across workspace
pnpm audit

# Check outdated packages
pnpm outdated
```

- Read the article further for best practices and troubleshooting. #todo

## Conclusion

- `pnpm` workspaces represent a significant evolution in JavaScript package management, offering superior performance, strict dependency management, and excellent monorepo support.
- By implementing the patterns shown in this tutorial, you’ll achieve:
  - 60-80% reduction in disk usage compared to traditional approaches
  - 3-5x faster installation times through intelligent caching and linking
  - Elimination of phantom dependencies and version conflicts
  - Streamlined development workflow across multiple related packages
