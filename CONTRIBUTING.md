# Contributing to Coder Dotfiles

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

If you encounter any issues or have suggestions for improvements:

1. Check if the issue already exists in the [Issues](https://github.com/Subtixx/coder_dotfiles/issues) section
2. If not, create a new issue with:
   - Clear description of the problem or suggestion
   - Steps to reproduce (for bugs)
   - Your OS and version
   - Relevant logs or error messages

### Submitting Changes

1. Fork the repository
2. Create a new branch for your feature/fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes
4. Test your changes thoroughly
5. Commit your changes with clear commit messages:
   ```bash
   git commit -m "Add feature: description of your changes"
   ```
6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
7. Create a Pull Request

## Development Guidelines

### Testing

Before submitting changes:

1. Test on both supported OSes if possible (Ubuntu/Debian and Arch Linux)
2. Verify syntax of shell scripts:
   ```bash
   bash -n install.sh
   bash -n install-dev-tools.sh
   ```
3. Test installation in a clean environment (VM or container)

### Code Style

- Use 4 spaces for indentation in shell scripts
- Use 2 spaces for YAML, JSON, and configuration files
- Follow existing code style in the repository
- Add comments for complex logic
- Use meaningful variable names

### Shell Scripts

- Use `set -e` to exit on errors
- Use functions to organize code
- Add error handling and user feedback
- Use colors for output to improve readability
- Test scripts with `shellcheck` if available

### Documentation

- Update README.md if adding new features
- Add comments in configuration files
- Include examples for new configurations
- Document any new dependencies or requirements

## Adding New Features

### New Language Support

To add support for a new programming language:

1. Add asdf plugin installation in `install.sh`:
   ```bash
   if ! asdf plugin list | grep -q newlang; then
       asdf plugin add newlang https://github.com/example/asdf-newlang.git
   fi
   ```

2. Add installation function in `install-dev-tools.sh`:
   ```bash
   install_newlang() {
       log_section "Installing NewLang"
       # Installation logic here
   }
   ```

3. Update README.md with the new language support
4. Add relevant aliases and environment variables to `.zshrc`

### New Tools

To add new development tools:

1. Add package to appropriate OS package list in `install.sh`
2. Document the tool in README.md
3. Add relevant aliases or configurations

### New Plugins

For Oh My Zsh, tmux, or asdf plugins:

1. Add plugin installation in `install.sh`
2. Add plugin configuration in respective dotfile
3. Document plugin usage in README.md

## Pull Request Guidelines

### PR Description

Include in your PR description:

- What changes were made
- Why the changes were made
- How to test the changes
- Any breaking changes
- Screenshots (for UI/terminal changes)

### PR Checklist

Before submitting a PR, ensure:

- [ ] Code follows the style guidelines
- [ ] Scripts pass syntax checks
- [ ] Changes are tested on at least one supported OS
- [ ] Documentation is updated
- [ ] Commit messages are clear and descriptive
- [ ] No unrelated changes are included

## Questions?

If you have questions about contributing, feel free to:

- Open an issue for discussion
- Check existing issues and PRs for similar discussions
- Review the README.md for project context

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).
