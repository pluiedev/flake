{
  lib,
  user,
  ...
}: {
  accounts.email.accounts = let
    inherit (builtins) mapAttrs;
    inherit (lib) filterAttrs;
    # Shoutout to getchoo who figured this out for me
    mkEmailAccounts = mapAttrs (name: account:
      rec {
        imap = {
          host = "imap.migadu.com";
          port = 993;
        };
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
        };
        address = "${name}@pluie.me";
        userName = address; # Use the address as the IMAP/SMTP username by default

        passwordCommand =
          if account._1passItemId != null
          then "/run/wrappers/bin/op item get --fields label=password ${account._1passItemId}"
          else null;

        thunderbird.enable = true;
      }
      // (filterAttrs (name: _: name != "_1passItemId") account));
  in
    mkEmailAccounts {
      hi = {
        primary = true;

        inherit (user) realName;
        _1passItemId = "fjutji565zipohkgsowe3c3nqq";
      };
      acc = {
        realName = "${user.realName} [accounts]";
        _1passItemId = "s6b5a7cf236jmpthkbdc4yzacu";
      };
    };
}
