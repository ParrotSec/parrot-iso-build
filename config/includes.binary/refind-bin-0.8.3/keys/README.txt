This directory contains known public keys for Linux distributions and other
parties that sign boot loaders and kernels that should be verifiable by
shim. I'm providing these keys as a convenience to enable easy installation
of keys should you replace your distribution's version of shim with another
one and therefore require adding its public key as a machine owner key
(MOK).

Files come with three extensions. A filename ending in .crt is a
certificate file that can be used by sbverify to verify the authenticity of
a key, as in:

$ sbverify --cert keys/refind.crt refind/refind_x64.efi

The .cer and .der filename extensions are equivalent, and are public key
files similar to .crt files, but in a different form. The MokManager
utility expects its input public keys in this form, so these are the files
you would use to add a key to the MOK list maintained by MokManager and
used by shim.

The files in this directory are, in alphabetical order:

- altlinux.cer -- The public key for ALT Linux (http://www.altlinux.com).

- canonical-uefi-ca.crt & canonical-uefi-ca.der -- Canonical's public key,
  used to sign Ubuntu boot loaders and kernels.

- fedora-ca.cer & fedora-ca.crt -- Fedora's public key, used to sign Fedora
  18's version of shim and Fedora 18's kernels.

- openSUSE-UEFI-CA-Certificate.cer & openSUSE-UEFI-CA-Certificate.crt --
  Public keys used to sign OpenSUSE 12.3.

- refind.cer & refind.crt -- My own (Roderick W. Smith's) public key,
  used to sign refind_x64.efi and the 64-bit rEFInd drivers.

- SLES-UEFI-CA-Certificate.cer & SLES-UEFI-CA-Certificate.crt -- The
  Public key for SUSE Linux Enterprise Server.
