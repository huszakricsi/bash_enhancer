# Bash Enhancer

Tired of typing the same super-long commands/paths over and over again, have to pay super attention wich folder are you in, recursive bash history search feels slow and tiring? Look no further and forget these problems!

<p align="center" style="font-size:1.5em;">
    <b>Without Bash Enhancer</b> &nbsp;|&nbsp;<<< Same typing speed >>>&nbsp;|&nbsp; <b>With Bash Enhancer</b>
</p>
<p align="center">
    <img src="assets/diff.gif" alt="Bash Enhancer in action: diff.gif" width="100%"/>
</p>

## Comparison Table: Traditional Bash vs. Bash Enhancer

| Task / Goal                | Traditional Bash Command                                                                 | With Bash Enhancer         |
|---------------------------|----------------------------------------------------------------------------------------|----------------------------|
| Go to a deep project dir   | `cd ~/projects/interesting_project/deep_path/folder`                                     | `lg my_route`              |
| Start Rails server         | `cd ~/projects/my_project && bundle exec rails s`                                       | `rs my_project`            |
| Open Rails console         | `cd ~/projects/my_project && bundle exec rails c`                                       | `rc my_project`            |
| Run Rake task             | `cd ~/projects/my_project && bundle exec rake db:migrate`                                 | `rk db:migrate my_project` |
| Start Node.js dev server   | `cd ~/projects/my_project && npm run dev`                                               | `nrd my_project`           |
| Commit with message        | `git commit -m "my message"`                                                            | `gcm "my message"`        |
| Git pull                   | `git pull`                                                                              | `gpl`                      |
| Git status                 | `git status`                                                                            | `gs`                       |
| Git push                   | `git push`                                                                              | `gps`                      |
| Run RSpec with Rescue      | `bundle exec rescue rspec --fail-fast`                                                  | `rsp`                      |
| Clear terminal             | `reset`                                                                                 | `c`                        |
| Refresh Node.js dependency | `cd ~/projects/dependency && npm run build && cd ~/projects/my_project/frontend && rm -rf node_modules package-lock.json && npm install && npm run dev` | `nrd-dependency-refresh my_project` |
And more..

> **Result:** Bash Enhancer reduces typing, eliminates repetitive navigation, and provides memorable, auto-completing shortcuts for common tasks.


A collection of helpful Bash aliases and functions to supercharge your terminal productivity. This script is designed to be sourced from your `.bashrc` or `.bash_profile` and provides convenient shortcuts for Git, Node.js, Rails, directory navigation, and more.

## Features

- **Let's Go: Directory Lookup Table Navigation (LUT)**: Jump to frequently used directories with auto-completion using the `lg` function.
- **Helper Functions**: Quickly list and describe all your aliases and functions.
- **System Aliases**: Common system commands for convenience.
- **Git Aliases**: Shortcuts for common Git operations, including branch management and code review.
- **Node.js/NPM Aliases**: Fast commands for building and installing Node.js projects.
- **Ruby/Rails Aliases**: Helpers for running RSpec and Rails tasks.
- **Service Aliases**: Start services like Elasticsearch and Sidekiq with a single command.
- **Project Functions**: Start Rails or Node.js servers in any project directory with a single command.

## Installation

### Simplified installation

1. **Run the following commands to clone Bash Enhancer and set it up:**
    ```bash
    git clone https://github.com/huszakricsi/bash_enhancer.git "$HOME/.bash_enhancer"
    bash ~/.bash_enhancer/setup.sh
    ```

2. **[Customize](#customization)**

### Detailed

1. **Copy or symlink `bash_enhancer.sh` into your home directory or a config folder.**
2. **Source it from your `.bashrc` or `.bash_profile`:**
   ```bash
   . /path/to/bash_enhancer.sh
   ```
3. **[Customize](#customization)**

## Main Commands & Aliases

- `h` — List all commented aliases and functions with descriptions.
- `hl` — List all aliases and functions with their definitions.
- `lg <key>` — Jump to a directory defined in your LUT, with auto-complete. Use -l to list all LUT keys and paths.
- `rs <key>` — Start Rails server in the specified directory, with auto-complete.
- `rc <key>` — Open Rails console in the specified directory, with auto-complete.
- `rk <task>` or `rk <task> <dir>` — Run the specified Rake task. If two parameters are given, change to the directory from LUT using the second parameter, then use the first as an argument to rake. Example: `rk db:migrate my_project` — Jumps to the directory mapped to `my_project` in your LUT and runs `bundle exec rake db:migrate`.
- `nrd <key>` — Start Node.js dev server in the specified directory, with auto-complete.
- `nrd-dependency-refresh <key>` — Rebuild dependency and refresh Node.js dev server, with auto-complete.
- `ga`, `gs`, `gl`, `gpl`, `gps`, `gf`, `gcan`, `gcl`, `gco`, `gcb`, `gcm`, `gst`, `gstp`, `cr`, `changed` — Git helpers.
- `nrb`, `ni` — Node.js helpers.
- `rsp` — Run RSpec with Rescue.
- `elasticsearch`, `sidekiq` — Service starters.
- `c`, `u` — System helpers.

## Let's Go: Directory Lookup Table Navigation (LUT)

- The LUT is defined in `dir_lut.sh` (or falls back to `dir_lut.sh.example`).
- Add entries like:
  ```bash
  [alfa]="$HOME/projects/client_a/alfa_project"
  ```
- Use `lg alfa` to jump to that directory. Don't forget that you dont have to type the whole key, use **tab** for auto-completion.
- Use the switch **-l** to list all LUT keys and paths.
  
## Project Application Executing and Building Functions with Let's Go:

- **Rails Server (`rs`)**  
  ```bash
  rs my_project
  ```
  *Jumps to the directory mapped to `my_project` in your LUT and starts the Rails server (`bundle exec rails s`).*

- **Rails Console (`rc`)**  
  ```bash
  rc my_project
  ```
  *Jumps to the directory mapped to `my_project` in your LUT and opens the Rails console (`bundle exec rails c`).*

- **Rake Task (`rk`)**  
  ```bash
  rk db:migrate my_project
  ```
  *Jumps to the directory mapped to `my_project` in your LUT and runs `bundle exec rake db:migrate`. If only a task is given, runs it in the current directory.*

- **Node.js Dev Server (`nrd`)**  
  ```bash
  nrd frontend
  ```
  *Jumps to the directory mapped to `frontend` in your LUT and starts the Node.js dev server (`npm run dev`).*

- **Node.js Library Refresh (`nrd-library-refresh`)**  
  ```bash
  nrd-library-refresh frontend
  ```
  *Jumps to the directory mapped to `frontend` in your LUT, rebuilds the dependency library, removes and reinstalls `node_modules`, and restarts the dev server. Useful for frontend projects with shared dependencies that you want to work on.*

## Requirements

- Bash 4+
- Perl (for the `h` (help) function)
- awk, grep, git, npm, bundle, rails, etc. (as needed by your workflow)

## Customization

- Edit `bash_enhancer.sh` to add or modify aliases and functions. **\[Optional\]**
- **Customize your directory lookup table:**
   - Copy `dir_lut.sh.example` to `dir_lut.sh` in the same directory. 
        ```bash
        cp ~/.bash_enhancer/dir_lut.sh.example ~/.bash_enhancer/dir_lut.sh
        ```
   - Edit `dir_lut.sh` to add your own directory shortcuts, with your chosen editor:
        ```bash
        nano ~/.bash_enhancer/dir_lut.sh
        ```
        ```bash
        vim ~/.bash_enhancer/dir_lut.sh
        ```
        ```bash
        code ~/.bash_enhancer/dir_lut.sh
        ```
