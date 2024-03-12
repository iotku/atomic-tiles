# Atomic Tiles (based on BlueBuild Template) &nbsp; [![build-ublue](https://github.com/iotku/atomic-tiles/actions/workflows/build.yml/badge.svg)](https://github.com/iotku/atomic-tiles/actions/workflows/build.yml)

Howdy, you've stumbled across my customized BlueBuild image which I run on my
various systems.

This image is focused towards developing a usable i3 or sway enviroment, but
may include other tiling WMs in the future.

This repo probably isn't very useful for you unless you want to run my base
system.

If you're interested in creating your own personal image:
 See the [BlueBuild docs](https://blue-build.org/how-to/setup/)

## Installation

> **Warning**  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/iotku/atomic-tiles:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/iotku/atomic-tiles:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

> **Warning**  
> The ISO GitHub Action will be deprecated soon in favor of the new [ublue-os/isogenerator](https://github.com/ublue-os/isogenerator). The Action will then be removed from this template repository and instructions for building ISOs will be on the website.

Currently, this repo does not generate ISOs.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command

```bash
cosign verify --key cosign.pub ghcr.io/iotku/atomic-tiles
```

