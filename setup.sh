#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

echo "🚀 Starting Neovim Portable Setup for Linux/macOS..."

# --- Configuration ---
# Target directory for Neovim configuration
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
# Repository URL
REPO_URL="https://github.com/MissinLinkk05551/NeovimPortable.git"

# --- Helper Functions ---
check_command() {
  command -v "$1" >/dev/null 2>&1
}

install_package_manager() {
  local pm_name="$1"
  local install_cmd="$2"
  if ! check_command "$pm_name"; then
    echo "⏳ $pm_name not found. Attempting to install..."
    if [ -n "$install_cmd" ]; then
      eval "$install_cmd"
      if ! check_command "$pm_name"; then
        echo "❌ Failed to install $pm_name. Please install it manually and re-run the script."
        exit 1
      fi
      echo "✅ $pm_name installed successfully."
    else
      echo "⚠️ $pm_name not found. Please install it manually and re-run the script."
      exit 1
    fi
  else
    echo "✅ $pm_name found."
  fi
}

install_package() {
  local package_name="$1"
  local human_name="${2:-$1}" # Optional human-readable name

  # macOS (Homebrew)
  if check_command "brew"; then
    if brew list "$package_name" >/dev/null 2>&1; then
      echo "✅ $human_name already installed (via Homebrew)."
    else
      echo "⏳ Installing $human_name with Homebrew..."
      brew install "$package_name" || { echo "❌ Failed to install $human_name with Homebrew. Please install manually."; exit 1; }
      echo "✅ $human_name installed (via Homebrew)."
    fi
  # Debian/Ubuntu (apt)
  elif check_command "apt"; then
    local apt_package_to_install="$package_name"
    local command_to_verify="$package_name"

    if [ "$package_name" == "fd" ]; then
      apt_package_to_install="fd-find"  # On Debian/Ubuntu, the package is fd-find
      # We still want to verify the 'fd' command later, potentially after symlinking
    fi

    # Check if the target command (e.g., 'fd' or 'fdfind') is already available
    if [ "$package_name" == "fd" ] && (check_command "fd" || check_command "fdfind"); then
        echo "✅ $human_name (fd/fdfind command) already available."
    elif check_command "$command_to_verify"; then
        echo "✅ $human_name ($command_to_verify command) already available."
    else
      # If command not available, check if the specific apt package is installed
      if dpkg -s "$apt_package_to_install" >/dev/null 2>&1; then
        echo "✅ $human_name ($apt_package_to_install package) already installed (via apt)."
      else
        echo "⏳ Installing $human_name ($apt_package_to_install) with apt..."
        # Run apt update, but don't exit if it fails (e.g. no network temporarily)
        sudo apt update -qq || echo "⚠️  sudo apt update failed. Continuing with install attempt..."
        sudo apt install -y "$apt_package_to_install" || { echo "❌ Failed to install $human_name ($apt_package_to_install) with apt. Please install manually."; exit 1; }
        echo "✅ $human_name ($apt_package_to_install package) installed (via apt)."
      fi
    fi

    # If we were trying to get 'fd' and 'fd-find' was involved,
    # and 'fd' command still doesn't exist but 'fdfind' does, create a symlink.
    if [ "$package_name" == "fd" ] && [ "$apt_package_to_install" == "fd-find" ]; then
      if ! check_command "fd" && check_command "fdfind"; then
        echo "ℹ️  'fdfind' command found. Attempting to symlink it to 'fd' in /usr/local/bin..."
        local fdfind_path
        fdfind_path=$(command -v fdfind)
        if [ -n "$fdfind_path" ]; then
          if sudo ln -sf "$fdfind_path" /usr/local/bin/fd; then
            echo "✅ Symlink 'fd' created successfully from '$fdfind_path' to '/usr/local/bin/fd'."
            # For the current script execution, ensure /usr/local/bin is in PATH
            # This helps the script's subsequent `check_command "fd"` to pass
            export PATH="/usr/local/bin:$PATH"
          else
            echo "⚠️  Could not create symlink for 'fd' from '$fdfind_path' to /usr/local/bin/fd."
            echo "   You might need to do this manually: sudo ln -s '$fdfind_path' /usr/local/bin/fd"
            echo "   Ensure /usr/local/bin is in your PATH and you have sudo privileges."
            echo "   Alternatively, some systems might prefer a symlink in ~/.local/bin (if it's in PATH)."
          fi
        else
          echo "⚠️  'fdfind' was reportedly installed or available, but not found in PATH for symlinking."
        fi
      elif check_command "fd"; then
        echo "✅ 'fd' command is available (possibly already symlinked or aliased)."
      fi
    fi

  # Fedora (dnf)
  elif check_command "dnf"; then
    if dnf list installed "$package_name" >/dev/null 2>&1; then
      echo "✅ $human_name already installed (via dnf)."
    else
      echo "⏳ Installing $human_name with dnf..."
      sudo dnf install -y "$package_name" || { echo "❌ Failed to install $human_name with dnf. Please install manually."; exit 1; }
      echo "✅ $human_name installed (via dnf)."
    fi
  # Arch (pacman)
  elif check_command "pacman"; then
    if pacman -Qi "$package_name" >/dev/null 2>&1; then
      echo "✅ $human_name already installed (via pacman)."
    else
      echo "⏳ Installing $human_name with pacman..."
      sudo pacman -Syu --noconfirm "$package_name" || { echo "❌ Failed to install $human_name with pacman. Please install manually."; exit 1; }
      echo "✅ $human_name installed (via pacman)."
    fi
  else
    # Fallback check if the command exists by other means
    if check_command "$package_name"; then
        echo "✅ $human_name ($package_name command) found (likely pre-installed or manually installed)."
    elif [ "$package_name" == "fd" ] && check_command "fdfind"; then
        echo "✅ $human_name (fdfind command) found. The script will attempt to symlink 'fdfind' to 'fd' if on a compatible system."
        # The symlink logic for fd-find on apt systems is handled above.
        # For other systems where fd-find might exist without a package manager being detected here,
        # user might need manual intervention if 'fd' is strictly required over 'fdfind'.
    else
        echo "⚠️ Could not determine package manager OR $human_name is not installed. Please ensure $human_name is installed and in your PATH."
        # Consider exiting if this is a critical dependency:
        # if [ "$package_name" == "fd" ] || [ "$package_name" == "ripgrep" ]; then exit 1; fi
    fi
  fi
}

# --- Main Setup ---

# 1. Check/Install Neovim
echo ""
echo "--- Step 1: Checking Neovim ---"
if ! check_command "nvim"; then
  echo "⚠️ Neovim (nvim) not found."
  echo "Please install Neovim version 0.9+."
  echo "You can download it from: https://github.com/neovim/neovim/releases"
  echo "Or use a version manager like bob: https://github.com/MordechaiHadad/bob"
  echo "Example for Homebrew (macOS): brew install neovim"
  echo "Example for apt (Ubuntu): sudo add-apt-repository ppa:neovim-ppa/stable -y; sudo apt update; sudo apt install neovim -y"
  exit 1
else
  echo "✅ Neovim found."
  # Optional: Check version (e.g., nvim --version)
fi

# 2. Check/Install Essential Dependencies
echo ""
echo "--- Step 2: Checking Essential Dependencies ---"
install_package "git" "Git"
install_package "curl" "cURL"
install_package "unzip" "Unzip" # Needed by some Mason packages
install_package "ripgrep" "Ripgrep (rg)"
install_package "fd" "fd (fd-find, check package name: 'fd-find' on Debian/Ubuntu, 'fd' on others)"

# For building some Mason packages (compilers)
echo "Checking for C/C++ compiler (build-essential/base-devel)..."
if check_command "gcc" || check_command "clang"; then
    echo "✅ C/C++ compiler found."
else
    echo "⚠️ C/C++ compiler (gcc or clang) not found. Some Mason packages might fail to build."
    echo "   Consider installing: "
    echo "     Debian/Ubuntu: sudo apt install build-essential"
    echo "     Fedora: sudo dnf groupinstall 'Development Tools'"
    echo "     Arch: sudo pacman -S base-devel"
    echo "     macOS: Install Xcode Command Line Tools (xcode-select --install)"
fi

# 3. Clone/Update Neovim Configuration
echo ""
echo "--- Step 3: Setting up Neovim Configuration ---"
if [ -d "$NVIM_CONFIG_DIR/.git" ]; then
  echo "⏳ Neovim config directory exists. Pulling latest changes from $REPO_URL..."
  cd "$NVIM_CONFIG_DIR"
  git pull
  cd - > /dev/null
  echo "✅ Configuration updated."
elif [ -d "$NVIM_CONFIG_DIR" ] && [ "$(ls -A $NVIM_CONFIG_DIR)" ]; then
    echo "⚠️ Directory $NVIM_CONFIG_DIR exists but is not a git repository or is not empty."
    echo "   Please back it up or remove it, then re-run this script."
    echo "   mv \"$NVIM_CONFIG_DIR\" \"${NVIM_CONFIG_DIR}.backup\""
    exit 1
else
  echo "⏳ Cloning Neovim configuration from $REPO_URL to $NVIM_CONFIG_DIR..."
  mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
  git clone "$REPO_URL" "$NVIM_CONFIG_DIR"
  echo "✅ Configuration cloned."
fi

# 4. Nerd Fonts Reminder
echo ""
echo "--- Step 4: Nerd Fonts ---"
echo "ℹ️ For icons and a better UI, please install a Nerd Font and set it in your terminal."
echo "   Popular choices: FiraCode Nerd Font, JetBrainsMono Nerd Font, Hack Nerd Font."
echo "   Download from: https://www.nerdfonts.com/"

# 5. Final Instructions
echo ""
echo "🎉 Neovim Portable Setup Complete! 🎉"
echo ""
echo "Next steps:"
echo "1. Open Neovim by typing 'nvim'."
echo "2. On the first run, Lazy.nvim will install plugins."
echo "3. Mason will then install configured LSPs, linters, formatters, and debuggers."
echo "   You can monitor this with :Mason or check :checkhealth."
echo "Enjoy your portable Neovim setup! ✨"