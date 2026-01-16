#!/usr/bin/env nix-shell
#!nix-shell -p nushell ssh-to-age -i nu

#==============================================================================
# SOPS w/ Age helper for retrieving my 1Password secret keys on the fly
# 
# Because I am a very lazy person and don't like to watch out for the
# implications of storing my SSH keys on mobile devices that may hypothetically
# be seized at any second, I'm storing all my private keys with 1Password.
# 
# Now, should you do this? For convenience, *maybe*? For maximum security?
# Definitely not. Go use a Yubikey or something. I'm just not a fan of
# keeping a metal dongle on my person this entire time. I'll probably just
# write out my master passphrase in my last will or something so people
# I trust can actually regain access to all my stuff in case something goes
# awry. Just in case.
#==============================================================================

# 1Password UUIDs of my private keys.
# 
# I feel *somewhat* safe to make this globally visible since you do
# need to sign in with my 1Password account to actually access them,
# and if you ever get to that point, my security has already been defeated.
#
# All of these should be Ed25519.
#
# NOTE: Additions/deletions _MUST_ be synchronized with .sops.yaml!
let items = [
  # Main SSH key
  "bkk3jg6qjnwyymb6gjiopczlba"
]

# Make sure to sign in first.
# Does nothing if already signed in
^op signin

$items
  | par-each { |item|
    ^op read $"op://Development/($item)/private key?ssh-format=openssh"
      | ^ssh-to-age -private-key
  }
  | str join "\n"

