{
  pkgs,
  lib,
  user,
  ...
}: {
  imports = [
    ./programs
  ];

  pluie.user = {
    email = let
      migadu = {
        imap = {
          host = "imap.migadu.com";
          port = 993;
        };
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
        };
      };
    in {
      enable = true;
      accounts = {
        "hi@pluie.me" = {
          primary = true;
          realName = user.fullName;
          host = migadu;
        };
        "acc@pluie.me" = {
          realName = "${user.fullName} [accounts]";
          host = migadu;
        };
      };
    };

    desktop = {
      _1password.enable = true;
      discord = {
        enable = true;
        openAsar.enable = true;
        vencord.enable = true;
      };
      plasma.enable = true;
    };

    locales.chinese.enable = true;

    tools = {
      fish.enable = true;
      rust = {
        enable = true;
        settings = {
          build.rustc-wrapper = lib.getExe' pkgs.sccache "sccache";
          build.target-dir = "${user.homeDirectory}/.cargo/target";
        };
        rustfmtSettings = {
          edition = "2021"; # In rare circumstances where rustfmt can't detect Cargo settings
          version = "Two";

          # There are simply way too few stable options.
          unstable_options = true;

          # The objectively correct way
          hard_tabs = true;
          tab_spaces = 4;
          newline_style = "Unix";

          # Imports
          imports_layout = "HorizontalVertical";
          imports_granularity = "Module";
          group_imports = "StdExternalCrate";

          # Enable formatting things that aren't usually formatted
          wrap_comments = true;
          format_code_in_doc_comments = true;
          format_macro_matchers = true;
          format_strings = true;

          # Minutiae
          hex_literal_case = "Lower";
          normalize_comments = true;
          normalize_doc_attributes = true;
          overflow_delimited_expr = true;
          reorder_impl_items = true;
          trailing_comma = "Always";
          use_field_init_shorthand = true;
        };
      };
    };
  };
}
