{
  config,
  pkgs,
  lib,
  ...
}: {
  roles.rust = {
    enable = true;
    settings = {
      build.rustc-wrapper = lib.getExe' pkgs.sccache "sccache";
      build.target-dir = "${config.roles.base.user.home}/.cargo/target";
    };
    rustfmt.settings = {
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
      imports_granularity = "Crate";
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
      use_field_init_shorthand = true;
    };
  };
}
