# Project Examples

This directory contains example configurations and guides for different types of projects using the dotfiles.

## Available Examples

### [PHP/Laravel](php-laravel/)
Complete setup guide for Laravel projects including:
- PHP and Composer configuration
- Database setup
- Development workflow with tmux
- Code quality tools
- Common Laravel commands

### [Vue.js/TypeScript](vuejs-typescript/)
Modern frontend development setup with:
- Vue 3 + TypeScript configuration
- Vite development server
- State management with Pinia
- Routing with Vue Router
- Testing setup
- Code quality tools (ESLint, Prettier)

### [Golang](golang/)
Go development environment with:
- Project structure examples
- Hot reload with Air
- Testing and debugging with Delve
- Popular packages and frameworks
- Deployment configurations
- Performance profiling

## How to Use These Examples

1. Navigate to the example directory for your project type
2. Read the README.md for specific setup instructions
3. Copy the `.tool-versions` file to your project root
4. Follow the quick start guide in each example

## General Workflow

All examples follow a similar pattern:

1. **Setup Environment**
   ```bash
   cd your-project
   cp ~/coder_dotfiles/examples/[type]/.tool-versions .
   asdf install
   ```

2. **Start Development Session**
   ```bash
   tmux new -s project-name
   ```

3. **Split Panes for Multi-tasking**
   - Development server
   - Testing/Linting
   - Git/Terminal commands

4. **Save Session**
   Press `prefix + Ctrl+s` to save tmux session

## Creating Your Own Project Template

You can create a custom template based on these examples:

1. Create a new directory in `examples/`
2. Add `.tool-versions` with required language versions
3. Create README.md with setup instructions
4. Include any project-specific configuration files

## Tips for Multi-Language Projects

For projects using multiple languages (e.g., Laravel + Vue.js):

Create a combined `.tool-versions`:
```
php 8.3.0
nodejs 20.10.0
composer 2.6.5
yarn 1.22.19
golang 1.21.5
```

## Additional Resources

- [asdf Documentation](https://asdf-vm.com/)
- [tmux Documentation](https://github.com/tmux/tmux/wiki)
- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)

## Contributing

Have a project setup you'd like to share? See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on adding new examples.
