{ config, lib, ... }:
{
  imports = [
    ./dock
    ./applescript
    ./plists.nix
  ];

  # When applying macOS upgrades, `/etc/zshrc` changes that were made by the
  # nix installer tend to be removed. To avoid having to update it every time,
  # add it to user-specific zsh config. See https://github.com/NixOS/nix/issues/3616
  programs.zsh.initExtra = ''
    if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
      . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
  '';

  home.sessionVariables = {
    BASH_SILENCE_DEPRECATION_WARNING = "1";
    HOMEBREW_NO_ANALYTICS = "1";
    CLICOLOR = "1"; # Enable colors for macOS version of `ls`
  };

  home.file."Pictures/screenshots/.keep".text = "";

  # Some settings pulled from:
  # https://github.com/mathiasbynens/dotfiles/blob/master/.macos
  targets.darwin.defaults = {
    "com.apple.screencapture".location = "${config.home.homeDirectory}/Pictures/screenshots/";
    "com.apple.dock".tilesize = 42;

    "com.apple.finder" = {
      _FXSortFoldersFirst = true; # Keep folders on top when sorting by name
      _FXShowPosixPathInTitle = true; # Display full POSIX path as Finder window title
      ShowStatusBar = true; # Finder: show status bar
      ShowPathbar = true; # Finder: show path bar
      FXDefaultSearchScope = "SCcf"; # When performing a search, search the current folder by default
    };


    # Avoid creating .DS_Store files on network or USB volumes
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };

    NSGlobalDomain = {
      # Enable subpixel font rendering on non-Apple LCDs
      # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
      AppleFontSmoothing = 1;

      # Expand save panel by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      # Finder: show all filename extensions
      AppleShowAllExtensions = true;

      # Possible values: "WhenScrolling", "Automatic" and "Always"
      AppleShowScrollBars = "Always";

      # Disable press-and-hold for keys in favor of key repeat
      ApplePressAndHoldEnabled = false;

      # Set key repeat rate
      KeyRepeat = 2;
      InitialKeyRepeat = 15;

      # Disable automatic substitutions
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      # Reverse swipe scroll direction (set to "unnatural")
      "com.apple.swipescrolldirection" = false;

      # Enable subpixel antialiasing
      # https://dev.to/mrahmadawais/onedevminute-fixing-terrible-blurry-font-rendering-issue-in-macos-mojave--lck
      CGFontRenderingFontSmoothingDisabled = false;
    };

    "com.apple.spotlight".orderedItems = [
      { enabled = 1; name = "APPLICATIONS"; }
      { enabled = 1; name = "MENU_EXPRESSION"; }
      { enabled = 0; name = "CONTACT"; }
      { enabled = 1; name = "MENU_CONVERSION"; }
      { enabled = 1; name = "MENU_DEFINITION"; }
      { enabled = 0; name = "DOCUMENTS"; }
      { enabled = 0; name = "EVENT_TODO"; }
      { enabled = 0; name = "DIRECTORIES"; }
      { enabled = 0; name = "FONTS"; }
      { enabled = 0; name = "IMAGES"; }
      { enabled = 0; name = "MESSAGES"; }
      { enabled = 0; name = "MOVIES"; }
      { enabled = 0; name = "MUSIC"; }
      { enabled = 0; name = "MENU_OTHER"; }
      { enabled = 0; name = "PDF"; }
      { enabled = 0; name = "PRESENTATIONS"; }
      { enabled = 0; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }
      { enabled = 0; name = "SPREADSHEETS"; }
      { enabled = 1; name = "SYSTEM_PREFS"; }
      { enabled = 0; name = "TIPS"; }
      { enabled = 0; name = "BOOKMARKS"; }
    ];
  };

  targets.darwin.plists = {
    "Library/Preferences/com.apple.finder.plist" = {
      # Show item info near icons on the desktop and in other icon views
      "DesktopViewSettings:IconViewSettings:showItemInfo" = true;
      "FK_StandardViewSettings:IconViewSettings:showItemInfo" = true;
      "StandardViewSettings:IconViewSettings:showItemInfo" = true;

      # Show item info to the right of the icons on the desktop
      "DesktopViewSettings:IconViewSettings:labelOnBottom" = false;

      # Enable snap-to-grid for icons on the desktop and in other icon views
      "DesktopViewSettings:IconViewSettings:arrangeBy" = "grid";
      "FK_StandardViewSettings:IconViewSettings:arrangeBy" = "grid";
      "StandardViewSettings:IconViewSettings:arrangeBy" = "grid";

      # Increase grid spacing for icons on the desktop and in other icon views
      "DesktopViewSettings:IconViewSettings:gridSpacing" = 85;
      "FK_StandardViewSettings:IconViewSettings:gridSpacing" = 85;
      "StandardViewSettings:IconViewSettings:gridSpacing" = 85;

      # Increase the size of icons on the desktop and in other icon views
      "DesktopViewSettings:IconViewSettings:iconSize" = 75;
      "FK_StandardViewSettings:IconViewSettings:iconSize" = 75;
      "StandardViewSettings:IconViewSettings:iconSize" = 75;
    };
  };
}
