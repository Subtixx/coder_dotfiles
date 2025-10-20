# Laravel Project Development Setup

This is an example configuration for a Laravel project.

## Prerequisites

Make sure you have installed the dotfiles:
```bash
cd ~/coder_dotfiles
./install.sh
./install-dev-tools.sh
```

## Quick Start

1. Copy `.tool-versions` to your Laravel project root
2. Install required versions:
   ```bash
   asdf install
   ```

3. Create a new Laravel project:
   ```bash
   composer create-project laravel/laravel my-project
   cd my-project
   ```

4. Copy `.tool-versions` to your project
5. Install dependencies:
   ```bash
   composer install
   npm install
   ```

6. Set up environment:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

7. Start development server:
   ```bash
   php artisan serve
   ```

## Useful Aliases

The dotfiles include these Laravel-specific aliases:

- `art` - php artisan
- `tinker` - php artisan tinker
- `migrate` - php artisan migrate
- `seed` - php artisan db:seed
- `serve` - php artisan serve

## Database Setup

### PostgreSQL
```bash
sudo -u postgres createdb laravel_db
```

### MySQL
```bash
mysql -u root -p
CREATE DATABASE laravel_db;
```

Update `.env`:
```
DB_CONNECTION=pgsql # or mysql
DB_DATABASE=laravel_db
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

## Development Workflow

1. Start tmux session:
   ```bash
   tmux new -s laravel
   ```

2. Split panes (prefix + |):
   - Pane 1: Laravel server (`serve`)
   - Pane 2: Vite dev server (`npm run dev`)
   - Pane 3: Testing/commands

3. Save tmux session (prefix + Ctrl+s)

## Testing

Run tests:
```bash
php artisan test
# or
./vendor/bin/phpunit
```

## Code Quality

The dotfiles include PHP CS Fixer:
```bash
php-cs-fixer fix
```

## Common Commands

```bash
# Create controller
art make:controller UserController

# Create model with migration
art make:model User -m

# Create migration
art make:migration create_users_table

# Clear cache
art cache:clear
art config:clear
art view:clear

# Optimize
art optimize
```
