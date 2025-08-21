# ==========================
# Help Functions
# ==========================
if [ -f "$HOME/.bash_enhancer/helpers.sh" ]; then
  source "$HOME/.bash_enhancer/helpers.sh"
fi

#h() { # Outputs list of aliases and functions in a colorized Markdown table. Filter groups by adding it's prefix after the command(h sys - for example). If -g is passed, it outputs a list of groups and their aliases/functions.

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
# Git Aliases
# =========================
ga() { # Git add command to stage changes
  git add "$@"
}

alias gd="git diff" # Show the differences between the working directory and the index
alias gs="git status" # Show the status of the Git repository
alias gl="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'" # Colorized, sorted list of local Git branches
alias gpl="git pull" # Pull the latest changes from the remote repository
alias gps="git push" # Push changes to the remote repository
alias gpsf="git push -f" # Force push changes to the remote repository
alias gf="git fetch" # Fetch changes from the remote repository
alias gcan="git commit --amend --no-edit" # Amend the last commit without changing the commit message
alias gcl="git clone $1" # Clone a Git repository

gco() { # Checkout a specific branch or commit
  git checkout "$@"
}

gm() { # Git merge command
  git merge "$@"
}

grb() { # Git rebase command
  git rebase "$@"
}

gbd() { # Git branch delete command
  git branch -d "$@"
}

alias gcob="git checkout -b $1" # Create a new branch and switch to it

gcoh() { # Show Git checkout history
  git reflog --date=iso | grep 'checkout: moving from' | \
  awk -F'HEAD@{|}: checkout: moving from | to ' '
    {
      date[NR]=$2; src[NR]=$3; dst[NR]=$4
      if(length($2)>max1) max1=length($2)
      if(length($3)>max2) max2=length($3)
      if(length($4)>max3) max3=length($4)
      n=NR
    }
    END {
      header1="Date"
      header2="Source"
      header3="Target"
      if(length(header1)>max1) max1=length(header1)
      if(length(header2)>max2) max2=length(header2)
      if(length(header3)>max3) max3=length(header3)
      print "\033[1mGit branch checkout history\033[0m"
      printf "\033[1m%-*s | %-*s -> %-*s\033[0m\n", max1, header1, max2, header2, max3, header3
      for(i=1;i<=n;i++)
        printf "%-*s | \033[38;5;208m%-*s\033[0m -> \033[38;5;226m%-*s\033[0m\n", max1, date[i], max2, src[i], max3, dst[i]
    }
  ' | head -21
}

alias gcm="git commit -m $1" # Commit changes with a message
alias gst="git stash" # Stash changes in the working directory
alias gstp="git stash pop" # Apply the most recent stash
alias gcfd="git clean -fd" # Discard untracked files
alias grh="git reset --hard" # Discard all changes in the working directory
alias grhh="git reset --hard HEAD && git clean -fd" # Discard all changes, including untracked files and directories

if [ -f /usr/share/bash-completion/completions/git ]; then
  source /usr/share/bash-completion/completions/git
fi

if type __git_complete &>/dev/null; then # Enable default git completions for shortcuts
  __git_complete ga _git_add
  __git_complete gco _git_checkout
  __git_complete gd _git_diff
  __git_complete gm _git_merge
  __git_complete grb _git_rebase
  __git_complete gbd _git_branch
fi

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
alias ni="npm install" # Install Node.js dependencies
alias nrb="npm run build" # Run the Node.js build script
alias nrt="npm run test $1" # Run the Node.js test script

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

 # Auto-completion for lg command, rs, rc, nrd, nrd-dependency-refresh, and rk commands. Add more commands as needed for auto-completion. (whitespace before # is to keep it from being listed by h -g command)
_lg_completions() {
  local cur_word
  cur_word="${COMP_WORDS[COMP_CWORD]}"
  local keys
  keys=$(printf "%s\n" "${!__DIR_LUT[@]}")
  COMPREPLY=( $(compgen -W "$keys" -- "$cur_word") )
}
complete -o bashdefault -o default -F _lg_completions lg rs rc nrd nrd-dependency-refresh rk

# =========================
# LS Functions
# =========================
alias ll="ls -alF" # List files in long format, including hidden files
alias la="ls -A" # List all files, including hidden files, but not '.' and '..'
alias l="ls -CF" # List files in columns, appending a slash to directories

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
