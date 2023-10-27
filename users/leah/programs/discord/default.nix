{
  pluie.user.desktop.discord = {
    enable = true;

    vesktop.enable = true;

    vesktop.settings = {
      minimizeToTray = "on";
      discordBranch = "stable";
      firstLaunch = false;
      arRPC = "on";
    };

    vencord.css = builtins.readFile ./vencord.css;
    vencord.settings = {
      notifyAboutUpdates = true;
      autoUpdate = false;
      autoUpdateNotification = true;
      useQuickCss = true;
      themeLinks = ["https://catppuccin.github.io/discord/dist/catppuccin-mocha-maroon.theme.css"];
      enableReactDevtools = true;
      frameless = false;
      transparent = false;
      winCtrlQ = false;
      macosTranslucency = false;
      disableMinSize = false;
      winNativeTitleBar = false;

      plugins = {
        BadgeAPI.enabled = true;
        CommandsAPI.enabled = true;
        ContextMenuAPI.enabled = true;
        MemberListDecoratorsAPI.enabled = true;
        MessageAccessoriesAPI.enabled = true;
        MessageDecorationsAPI.enabled = true;
        MessageEventsAPI.enabled = true;
        MessagePopoverAPI.enabled = true;
        NoticesAPI.enabled = true;
        ServerListAPI.enabled = true;
        NoTrack.enabled = true;

        Settings = {
          enabled = true;
          settingsLocation = "aboveActivity";
        };
        BetterFolders = {
          enabled = true;
          sidebar = false;
          sidebarAnim = true;
          closeAllFolders = false;
          closeAllHomeButton = false;
          closeOthers = false;
          forceOpen = false;
        };
        BetterRoleDot = {
          enabled = true;
          bothStyles = false;
        };
        CallTimer.enabled = true;
        ClearURLs.enabled = true;
        CrashHandler.enabled = true;
        EmoteCloner.enabled = true;
        Experiments = {
          enabled = true;
          enableIsStaff = false;
          forceStagingBanner = false;
        };
        FakeNitro = {
          enabled = true;
          enableEmojiBypass = true;
          enableStickerBypass = true;
          enableStreamQualityBypass = true;
          transformStickers = true;
          transformEmojis = true;
          transformCompoundSentence = false;
          emojiSize = 48;
        };
        FakeProfileThemes = {
          enabled = true;
          nitroFirst = true;
        };
        FavoriteGifSearch.enabled = true;
        FixInbox.enabled = true;
        FixSpotifyEmbeds.enabled = true;
        GifPaste.enabled = true;
        GreetStickerPicker.enabled = true;
        iLoveSpam.enabled = true;
        KeepCurrentChannel.enabled = true;
        MemberCount.enabled = true;
        MoreUserTags = {
          enabled = true;
          tagSettings = {
            WEBHOOK = {
              text = "Webhook";
              showInChat = true;
              showInNotChat = true;
            };
            OWNER = {
              text = "Owner";
              showInChat = true;
              showInNotChat = true;
            };
            ADMINISTRATOR = {
              text = "Admin";
              showInChat = true;
              showInNotChat = true;
            };
            MODERATOR_STAFF = {
              text = "Staff";
              showInChat = true;
              showInNotChat = true;
            };
            MODERATOR = {
              text = "Mod";
              showInChat = true;
              showInNotChat = true;
            };
            VOICE_MODERATOR = {
              text = "VC Mod";
              showInChat = true;
              showInNotChat = true;
            };
          };
        };
        Moyai = {
          enabled = true;
          ignoreBots = true;
          triggerWhenUnfocused = false;
          volume = 0.25;
          ignoreBlocked = true;
        };
        NoDevtoolsWarning.enabled = true;
        NoF1.enabled = true;
        NoReplyMention = {
          enabled = true;
          userList = "";
          shouldPingListed = true;
          inverseShiftReply = false;
        };
        NormalizeMessageLinks.enabled = true;
        NoUnblockToJump.enabled = true;
        NSFWGateBypass.enabled = true;
        OpenInApp = {
          enabled = true;
          spotify = true;
          steam = true;
          epic = true;
        };
        PermissionsViewer = {
          enabled = true;
          permissionsSortOrder = 0; # Highest role
          defaultPermissionsDropdownState = false;
        };
        petpet.enabled = true;
        PictureInPicture.enabled = true;
        PinDMs.enabled = true;
        PlatformIndicators = {
          enabled = true;
          colorMobileIndicator = true;
          list = true;
          badges = true;
          messages = true;
        };
        PreviewMessage.enabled = true;
        PronounDB = {
          enabled = true;
          showInMessages = true;
          showSelf = true;
          # Prefer Discord, fall back to PronounDB
          pronounSource = 1;
          pronounsFormat = "LOWERCASE";
          showInProfile = true;
        };
        QuickMention.enabled = true;
        ReactErrorDecoder.enabled = true;
        ReadAllNotificationsButton.enabled = true;
        RelationshipNotifier = {
          enabled = true;
          offlineRemovals = true;
          groups = true;
          servers = true;
          friends = true;
          friendRequestCancels = true;
          notices = false;
        };
        RevealAllSpoilers.enabled = true;
        ReverseImageSearch.enabled = true;
        RoleColorEverywhere = {
          enabled = true;
          chatMentions = true;
          memberList = true;
          voiceUsers = true;
        };
        SearchReply.enabled = true;
        SendTimestamps.enabled = true;
        ServerListIndicators = {
          enabled = true;
          mode = 2; # Only online friend count
        };
        ServerProfile.enabled = true;
        ShikiCodeblocks = {
          enabled = true;
          useDevIcon = "COLOR";
          theme = "https://raw.githubusercontent.com/catppuccin/vscode/6db6d747b2d2b5f21a6c8d5d2ea6ccbd5048c315/macchiato.json";
          tryHljs = "SECONDARY"; # Prefer Shiki over Highlight.js
          bgOpacity = 80;
        };
        ShowAllMessageButtons.enabled = true;
        ShowConnections = {
          enabled = true;
          iconSpacing = 1;
          iconSize = 32;
        };
        SilentMessageToggle.enabled = true;
        SortFriendRequests.enabled = true;
        SpotifyControls = {
          enabled = true;
          hoverControls = false;
        };
        SpotifyCrack = {
          enabled = true;
          noSpotifyAutoPause = true;
          keepSpotifyActivityOnIdle = false;
        };
        SupportHelper.enabled = true;
        Translate = {
          enabled = true;
          autoTranslate = false;
        };
        TypingIndicator = {
          enabled = true;
          includeMutedChannels = false;
          includeBlockedUsers = false;
        };
        TypingTweaks = {
          enabled = true;
          alternativeFormatting = true;
          showRoleColors = true;
          showAvatars = true;
        };
        Unindent.enabled = true;
        UnsuppressEmbeds.enabled = true;
        UserVoiceShow = {
          enabled = true;
          showInUserProfileModal = true;
          showVoiceChannelSectionHeader = true;
        };
        USRBG = {
          enabled = true;
          voiceBackground = true;
          nitroFirst = true;
        };
        ValidUser.enabled = true;
        VcNarrator = {
          enabled = true;
          joinMessage = "{{USER}} joined";
          sayOwnName = false;
          latinOnly = false;
          leaveMessage = "{{USER}} left";
          deafenMessage = "{{USER}} deafened";
          undeafenMessage = "{{USER}} undeafened";
        };
        VencordToolbox.enabled = true;
        ViewIcons.enabled = true;
        VoiceChatDoubleClick.enabled = true;
        VoiceMessages.enabled = true;
        WhoReacted.enabled = true;
        Wikisearch.enabled = true;
      };
      notifications = {
        timeout = 5000;
        position = "bottom-right";
        useNative = "not-focused";
        logLimit = 50;
      };
    };
  };
}
