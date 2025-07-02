# ==========================
# Help Functions
# ==========================

h() { # Outputs list of aliases and functions in a colorized Markdown table
  local cols=$(tput cols)
  awk -v termw="$cols" '
    function wrap(str, width,   out, i) {
      while (length(str) > width) {
        for (i=width; i>0 && substr(str,i,1)!=" "; i--); 
        if (i==0) i=width;
        out = out substr(str,1,i) "\n"; str=substr(str,i+1);
      }
      return out str;
    }
    # First pass: collect max widths
    NR==FNR {
      if (/^# ([^=].*)/) {
        group = $2; for (i=3; i<=NF; i++) group = group " " $i;
      }
      if (/^alias /) {
        match($0, /^alias ([^=]+)="([^"]*)" # (.*)$/, arr);
        if (arr[1] && arr[2] && arr[3]) {
          g=length(group); n=length(arr[1]);
          if (g>maxg) maxg=g;
          if (n>maxn) maxn=n;
          data[NR]=$0; datag[NR]=group;
        }
      }
      if (/^#?[a-zA-Z0-9_\-]+\(\) { #/) {
        match($0, /^#?([a-zA-Z0-9_\-]+)\(\) { # (.*)$/, arr);
        if (arr[1] && arr[2]) {
          g=length(group); n=length(arr[1]);
          if (g>maxg) maxg=g;
          if (n>maxn) maxn=n;
          data[NR]=$0; datag[NR]=group;
        }
      }
      next;
    }
    # Second pass: print table
    NR!=FNR {
      if (header_printed==0) {
        bg[0]="\033[40m"; bg[1]="\033[44m";
        # 5 pipes, 8 spaces (| col | col | col | col |)
        sepw = 5 + 8;
        remain=termw-(maxg+maxn+sepw);
        if (remain<10) { cmdw=descw=5; } else {
          cmdw=int(remain/2); descw=remain-cmdw;
        }
        header="| " sprintf("%-"maxg"s", "Group") " | " sprintf("%-"maxn"s", "Name/Alias") " | " sprintf("%-"cmdw"s", "Command/Definition") " | " sprintf("%-"descw"s", "Description") " |";
        sep="|" sprintf("-%"maxg"s", "") "-|" sprintf("-%"maxn"s", "") "-|" sprintf("-%"cmdw"s", "") "-|" sprintf("-%"descw"s", "") "-|";
        gsub(/ /,"-",sep);
        print "\033[97;45m" header "\033[0m";
        print "\033[97;45m" sep "\033[0m";
        row=0; header_printed=1;
        group = "";
      }
      if (/^# ([^=].*)/) {
        group = $2; for (i=3; i<=NF; i++) group = group " " $i;
        next;
      }
      if (/^alias /) {
        match($0, /^alias ([^=]+)="([^"]*)" # (.*)$/, arr);
        if (arr[1] && arr[2] && arr[3]) {
          cmd=wrap(arr[2],cmdw); desc=wrap(arr[3],descw);
          
          n=split(cmd,cmdarr,"\n"); m=split(desc,descarr,"\n");
          lines=(n>m?n:m);
          for(i=1;i<=lines;i++) {
            printf "%s| %-*s | %-*s | %-*s | %-*s |\033[0m\n", bg[row%2], maxg, (i==1?group:""), maxn, (i==1?arr[1]:""), cmdw, (i<=n?cmdarr[i]:""), descw, (i<=m?descarr[i]:"");
          }
          row++;
        }
        next;
      }
      if (/^#?[a-zA-Z0-9_\-]+\(\) { #/) {
        match($0, /^#?([a-zA-Z0-9_\-]+)\(\) { # (.*)$/, arr);
        if (arr[1] && arr[2]) {
          fun=arr[1]; desc=wrap(arr[2],descw);
          if (fun == "h" || fun == "hl") {
            def=wrap("Help function defined in ~/.bash_enhancer/helpers.sh",cmdw);
          } else {
            def=wrap("Function (Use hl command to see definiton, or check ~/.bash_enhancer/bash_enhancer.sh)",cmdw);
          }
          n=split(def,cmdarr,"\n"); m=split(desc,descarr,"\n");
          lines=(n>m?n:m);
          for(i=1;i<=lines;i++) {
            printf "%s| %-*s | %-*s | %-*s | %-*s |\033[0m\n", bg[row%2], maxg, (i==1?group:""), maxn, (i==1?fun:""), cmdw, (i<=n?cmdarr[i]:""), descw, (i<=m?descarr[i]:"");
          }
          row++;
        }
        next;
      }
    }
  ' ~/.bash_enhancer/bash_enhancer.sh ~/.bash_enhancer/bash_enhancer.sh
}

hl() { # List all aliases and functions in your .bash_enhancer/bash_enhancer.sh with their definitions
  cat ~/.bash_enhancer/bash_enhancer.sh | awk '
  /^alias / { print }
  /^.*() {/, /^}/
  '
}
