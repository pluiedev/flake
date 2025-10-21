{
  hjem.users.leah.ext.programs.vesktop = {
    enable = true;
    autostart = true;

    settings = {
      minimizeToTray = "on";
      discordBranch = "stable";
      arRPC = "on";
      clickTrayToShowHide = true;
    };

    vencord = {
      enable = true;
      css = builtins.readFile ./vencord.css;
    };

    vencord.settings = {
      notifyAboutUpdates = true;
      autoUpdate = true;
      autoUpdateNotification = true;
      useQuickCss = true;
      enableReactDevtools = true;
      frameless = false;
      transparent = false;
      winCtrlQ = false;
      macosTranslucency = false;
      disableMinSize = false;
      winNativeTitleBar = false;

      notifications = {
        timeout = 5000;
        position = "bottom-right";
        useNative = "not-focused";
        logLimit = 50;
      };

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

        AccountPanelServerProfile.enabled = true;
        AlwaysExpandRoles.enabled = true;
        AlwaysTrust.enabled = true;
        AnonymiseFileNames.enabled = true;
        BetterFolders = {
          enabled = true;
          sidebar = false;
          sidebarAnim = true;
          closeAllFolders = false;
          closeAllHomeButton = false;
          closeOthers = false;
          forceOpen = false;
        };
        BetterGifAltText.enabled = true;
        BetterGifPicker.enabled = true;
        BetterRoleContext.enabled = true;
        BetterRoleDot = {
          enabled = true;
          bothStyles = false;
        };
        BetterSessions = {
          enabled = true;
          backgroundCheck = true;
        };
        BetterSettings = {
          enabled = true;
          disableFade = true;
          organizeMenu = true;
          eagerLoad = true;
        };
        BetterUploadButton.enabled = true;
        BiggerStreamPreview.enabled = true;
        BlurNSFW.enabled = true;
        CallTimer.enabled = true;
        ClearURLs.enabled = true;
        ConsoleJanitor.enabled = true;
        CopyEmojiMarkdown.enabled = true;
        CopyFileContents.enabled = true;
        CrashHandler.enabled = true;
        Decor.enabled = true;
        DisableCallIdle.enabled = true;
        DontRoundMyTimestamps.enabled = true;
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
        FixCodeblockGap.enabled = true;
        FixImagesQuality.enabled = true;
        FixSpotifyEmbeds.enabled = true;
        FixYoutubeEmbeds.enabled = true;
        FriendsSince.enabled = true;
        FullSearchContext.enabled = true;
        FullUserInChatbox.enabled = true;
        GameActivityToggle.enabled = true;
        GifPaste.enabled = true;
        GreetStickerPicker.enabled = true;
        HideMedia.enabled = true;
        iLoveSpam.enabled = true;
        ImageZoom.enabled = true;
        ImplicitRelationships.enabled = true;
        KeepCurrentChannel.enabled = true;
        MemberCount.enabled = true;
        MentionAvatars.enabled = true;
        MessageLatency.enabled = true;
        MessageLinkEmbeds.enabled = true;
        MoreKaomoji.enabled = true;
        Moyai = {
          enabled = true;
          ignoreBots = true;
          triggerWhenUnfocused = false;
          volume = 0.1;
          ignoreBlocked = true;
        };
        MutualGroupDMs.enabled = true;
        NewGuildSettings = {
          enabled = true;
          guild = false;
          everyone = false;
          role = false;
          showAllChannels = true;
        };
        NoDevtoolsWarning.enabled = true;
        NoF1.enabled = true;
        NoOnboardingDelay.enabled = true;
        NoReplyMention = {
          enabled = true;
          userList = "";
          shouldPingListed = true;
          inverseShiftReply = false;
        };
        NormalizeMessageLinks.enabled = true;
        NotificationVolume = {
          enabled = true;
          notificationVolume = 50;
        };
        NoTypingAnimation.enabled = true;
        NoUnblockToJump.enabled = true;
        OnePingPerDM.enabled = true;
        OpenInApp = {
          enabled = true;
          spotify = true;
          steam = true;
          epic = true;
        };
        OverrideForumDefaults.enabled = true;
        PauseInvitesForever.enabled = true;
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
        QuickMention.enabled = true;
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
        ReplaceGoogleSearch.enabled = true;
        ReplyTimestamp.enabled = true;
        RevealAllSpoilers.enabled = true;
        ReverseImageSearch.enabled = true;
        ReviewDB.enabled = false; # Fuck ReviewDB
        RoleColorEverywhere = {
          enabled = true;
          chatMentions = true;
          memberList = true;
          voiceUsers = true;
        };
        SendTimestamps.enabled = true;
        ServerInfo.enabled = true;
        ServerListIndicators = {
          enabled = true;
          mode = 2; # Only online friend count
        };
        ShikiCodeblocks = {
          enabled = true;
          useDevIcon = "COLOR";
          tryHljs = "SECONDARY"; # Prefer Shiki over Highlight.js
          bgOpacity = 80;
        };
        ShowAllMessageButtons.enabled = true;
        ShowConnections = {
          enabled = true;
          iconSpacing = 1;
          iconSize = 32;
        };
        ShowTimeoutDuration.enabled = true;
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
        StartupTimings.enabled = true;
        StreamerModeOnStream.enabled = true;
        SuperReactionTweaks = {
          enabled = true;
          superReactByDefault = false;
          superReactionPlayingLimit = 10;
        };
        ThemeAttributes.enabled = true;
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
        UnlockedAvatarZoom.enabled = true;
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
        ValidReply.enabled = true;
        ValidUser.enabled = true;
        VcNarrator = {
          enabled = true;
          # Cursed, I know.
          voice = "Chinese (Mandarin, latin as English)+female2 espeak-ng";
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
        VoiceDownload.enabled = true;
        VoiceMessages.enabled = true;
        VolumeBooster.enabled = true;
        WebKeybinds.enabled = true;
        WebScreenShareFixes.enabled = true;
        WhoReacted.enabled = true;
        YoutubeAdblock.enabled = true;
      };
    };
  };
}
