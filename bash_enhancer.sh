# =========================
# Helper Functions
# =========================
h() { # Gives you a short description of your commented aliases and functions in your .bash_enhancer/bash_enhancer.sh
  perl -nE '
    BEGIN {
      @lines = (); @bg = ("\e[40m", "\e[44m"); # black and blue backgrounds
      $maxlen = 0;
      $maxcmdlen = 0;
      $maxdesclen = 0;
      $regex = qr/((^.*)\(\)\s\{|^alias\s(.*)=\").*#[^#](.*)$/;
    }
    if (m{$regex}) {
      my $cmd = $3 ? $3 : $2;
      my $desc = $4;
      $maxcmdlen = length($cmd) if length($cmd) > $maxcmdlen;
      $maxdesclen = length($desc) if length($desc) > $maxdesclen;
      push @lines, [$cmd, $desc];
    }
    END {
      my $maxlen = $maxcmdlen + $maxdesclen + 3;
      my $header = sprintf("%-" . ($maxcmdlen) . "s | %s", "Command", "Description");
      printf "\e[97;45m%-${maxlen}s\e[0m\n", $header;
      my $i = 0;
      foreach my $arr (sort { lc($a->[0]) cmp lc($b->[0]) } @lines) {
        my ($cmd, $desc) = @$arr;
        my $line = sprintf("%-" . ($maxcmdlen) . "s | %s", $cmd, $desc);
        printf "%s%-${maxlen}s\e[0m\n", $bg[$i++%2], $line;
      }
    }
  ' ~/.bash_enhancer/bash_enhancer.sh
}

hl() { # List all aliases and functions in your .bash_enhancer/bash_enhancer.sh with their definitions
  cat ~/.bash_enhancer/bash_enhancer.sh | awk '
  /^alias / { print }
  /^.*() {/, /^}/
  '
}

# =========================
# System Aliases
# =========================
alias c="reset" # Clear the terminal screen
alias u="sudo apt-get update" # Update package lists

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
alias cr="git diff-tree -r --no-commit-id --name-only --diff-filter=ACM dev@\{u\} HEAD | (grep '\.rb$' || true) | (grep -v 'db/**' || true) | xargs --no-run-if-empty bundle exec rubocop" # Run RuboCop on changed Ruby files since the last commit, excluding files in the db directory
alias changed="git diff --name-only HEAD HEAD~1 | xargs subl" # Open files changed in the last commit in Sublime Text

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
# Let's Go (Driectory) Lookup Table
# =========================
if [ -f "$HOME/.bash_enhancer/dir_lut.sh" ]; then
  source "$HOME/.bash_enhancer/dir_lut.sh"
elif [ -f "$HOME/.bash_enhancer/dir_lut.sh.example" ]; then
  echo "Warning: $HOME/.bash_enhancer/dir_lut.sh not found. Using $HOME/.bash_enhancer/dir_lut.sh.example instead. Copy and edit it to customize your directories." >&2
  source "$HOME/.bash_enhancer/dir_lut.sh.example"
else
  echo "Error: Both $HOME/.bash_enhancer/.dir_lut and $HOME/.bash_enhancer/.dir_lut.example not found. Please check repository integrity." >&2
fi

# =========================
# Let's Go (Directory LUT) Navigation Functions
# =========================
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

_lg_completions() {
  local cur_word
  cur_word="${COMP_WORDS[COMP_CWORD]}"
  local keys
  keys=$(printf "%s\n" "${!__DIR_LUT[@]}")
  COMPREPLY=( $(compgen -W "$keys" -- "$cur_word") )
}
complete -o bashdefault -o default -F _lg_completions lg rs rc nrd nrd-dependency-refresh rk

# =========================
# Project Application Executing and Building Functions
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
