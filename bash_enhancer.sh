# ==========================
# Help Functions
# ==========================
if [ -f "$HOME/.bash_enhancer/helpers.sh" ]; then
  source "$HOME/.bash_enhancer/helpers.sh"
fi

#h() { # Outputs list of aliases and functions in a colorized Markdown table

#hl() { # List all aliases and functions in your .bash_enhancer/bash_enhancer.sh with their definitions


# =========================
# System Aliases
# =========================
alias c="clear" # Clear the terminal screen
alias e="exit" # Exit the terminal

# =========================
# Apt-Get Aliases
# =========================
alias au="sudo apt-get update" # Update package lists
alias ai="sudo apt-get install" # Install a package using apt-get
alias ar="sudo apt-get remove" # Remove a package using apt-get
alias as="sudo apt-get search" # Search for a package using apt-get
alias aug="sudo apt-get upgrade" # Upgrade installed packages using apt-get
alias armo="sudo apt-get autoremove" # Remove unused packages using apt-get

# =========================
# LS Aliases
# =========================
alias ll='ls -alF' # List files in long format, including hidden files
alias la='ls -A' # List all files, including hidden files, but not '.' and '..'
alias l='ls -CF' # List files in columns, appending a slash to directories

# =========================
# Git Aliases
# =========================
alias ga="git add" # Git add command to stage changes
alias gs="git status" # Show the status of the Git repository
alias gl="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'" # Colorized, sorted list of local Git branches
alias gpl="git pull" # Pull the latest changes from the remote repository
alias gps="git push" # Push changes to the remote repository
alias gf="git fetch" # Fetch changes from the remote repository
alias gcan="git commit --amend --no-edit" # Amend the last commit without changing the commit message
alias gcl="git clone $1" # Clone a Git repository
alias gco="git checkout $1" # Checkout a specific branch or commit
alias gcb="git checkout -b $1" # Create a new branch and switch to it
alias gcm="git commit -m $1" # Commit changes with a message
alias gst="git stash" # Stash changes in the working directory
alias gstp="git stash pop" # Apply the most recent stash

# =========================
# Docker Aliases
# =========================
alias dc="docker compose" # Docker Compose command
alias dcr="docker compose run" # Run a one-off command in a new container using docker compose
alias dcu="docker compose up" # Start up docker compose services
alias dce="docker compose exec" # Execute a command in a running docker compose service
alias dcd="docker compose down" # Stop and remove docker compose containers, networks, images, and volumes
alias dce="docker compose exec -it" # Execute a command interactively in a running docker compose service
alias dcrec="docker compose down && docker system prune -a && docker network create shared_network && docker compose up" # Recreate docker environment: stop, prune, create network, and start up

# =========================
# Kubernetes Aliases
# =========================
alias kdd="kubectl describe deployment" # Describe a Kubernetes deployment
alias kdp="kubectl describe pod" # Describe a Kubernetes pod
alias kds="kubectl describe service" # Describe a Kubernetes service
alias kdre="kubectl describe replica" # Describe a Kubernetes replica set
alias kdc="kubectl describe configmap" # Describe a Kubernetes config map
alias kdrs="kubectl describe rs" # Describe a Kubernetes replication controller


# =========================
# Node.js/NPM Aliases
# =========================
alias nrb="npm run build" # Run the Node.js build script
alias ni="npm install" # Install Node.js dependencies

# =========================
# Ruby/Rails Aliases
# =========================
alias rsp="bundle exec rescue rspec --fail-fast" # Run RSpec tests with Rescue

# =========================
# Service Aliases
# =========================
alias elasticsearch="/usr/share/elasticsearch/bin/elasticsearch" # Start the Elasticsearch service
alias sidekiq="redis-cli FLUSHALL & bundle exec sidekiq" # Start the Sidekiq background job processor

# =========================
# Let's Go navigation
# =========================

if [ -f "$HOME/.bash_enhancer/dir_lut.sh" ]; then # Load the directory lookup table (LUT) for Let's Go navigation.
  source "$HOME/.bash_enhancer/dir_lut.sh"
elif [ -f "$HOME/.bash_enhancer/dir_lut.sh.example" ]; then
  echo "Warning: $HOME/.bash_enhancer/dir_lut.sh not found. Using $HOME/.bash_enhancer/dir_lut.sh.example instead. Copy and edit it to customize your directories." >&2
  source "$HOME/.bash_enhancer/dir_lut.sh.example"
else
  echo "Error: Both $HOME/.bash_enhancer/.dir_lut and $HOME/.bash_enhancer/.dir_lut.example not found. Please check repository integrity." >&2
fi

lg() { # (Let's Go) Change to the specified directory from LUT, with auto-completion. Use -l to list all LUT keys and paths.
  if [ "$1" = "-l" ]; then
    for key in "${!__DIR_LUT[@]}"; do
      printf "%-20s %s\n" "$key" "${__DIR_LUT[$key]}"
    done | sort
    return 0
  fi
  if [ -n "$1" ]; then
    local dir="${__DIR_LUT[$1]}"
    if [ -z "$dir" ]; then
      echo "Error: Directory key '$1' not found in LUT." >&2
      return 1
    fi
    cd "$dir"
  fi
}

# Auto-completion for lg command, rs, rc, nrd, nrd-dependency-refresh, and rk commands. Add more commands as needed for auto-completion.
_lg_completions() {
  local cur_word
  cur_word="${COMP_WORDS[COMP_CWORD]}"
  local keys
  keys=$(printf "%s\n" "${!__DIR_LUT[@]}")
  COMPREPLY=( $(compgen -W "$keys" -- "$cur_word") )
}
complete -o bashdefault -o default -F _lg_completions lg rs rc nrd nrd-dependency-refresh rk

# =========================
# Project Functions
# =========================
rs() { # Run the Rails server in the specified directory from LUT, with auto-completion, if no directory is specified, it defaults to the current directory.
  if [ -n "$1" ]; then
    lg "$1"
  fi
  bundle exec rails s
}

rc() { # Run the Rails console in the specified directory from LUT, with auto-completion, if no directory is specified, it defaults to the current directory.
  if [ -n "$1" ]; then
    lg "$1"
  fi
  bundle exec rails c
}

bi() { # Runs bundle install in the specified directory from LUT, with auto-completion. If no directory is specified, it defaults to the current directory.
  if [ -n "$1" ]; then
    lg "$1"
  fi
  bundle install
}

rk() { # Run the specified Rake Task. If two parameters are given, change to the directory from LUT using the first parameter, then use the second as an argument to rake.
  if [ -n "$2" ]; then
    lg "$2"
    bundle exec rake "$1"
  else
    if [ -n "$1" ]; then
      bundle exec rake "$1"
    else
      bundle exec rake
    fi
  fi
}

nrd() { # Run the Node.js development server in the specified directory from LUT, with auto-completion. If no directory is specified, it defaults to the current directory.
  if [ -n "$1" ]; then
    lg "$1"
  fi
  npm run dev
}

nrd-dependency-refresh() { # Refresh the Node.js development server for the given project, and also rebuild the "dependency" project. Works with auto-completion. Feel free to tailor as you it to your needs
  lg "dependency"
  npm run build
  lg "$1"
  cd frontend
  rm -rf node_modules package-lock.json
  npm install
  npm run dev
}
