# This is the Containerfile for your custom image.

# Instead of adding RUN statements here, you should consider creating a script
# in `config/scripts/`. Read more in `modules/script/README.md`

# It takes in the recipe, version, and base image as arguments,
# all of which are provided by build.yml when doing builds
# in the cloud. The ARGs have default values, but changing those
# does nothing if the image is built in the cloud.

ARG IMAGE_MAJOR_VERSION=38
# Warning: changing this might not do anything for you. Read comment above.
ARG BASE_IMAGE_URL=ghcr.io/ublue-os/silverblue-main

FROM ${BASE_IMAGE_URL}:${IMAGE_MAJOR_VERSION}

# The default recipe set to the recipe's default filename
# so that `podman build` should just work for many people.
ARG RECIPE=recipe.yml

# The default image registry to write to policy.json and cosign.yaml
ARG IMAGE_REGISTRY=ghcr.io/ublue-os

# Copy static configurations and component files.
# Warning: If you want to place anything in "/etc" of the final image, you MUST
# place them in "./usr/etc" in your repo, so that they're written to "/usr/etc"
# on the final system. That is the proper directory for "system" configuration
# templates on immutable Fedora distros, whereas the normal "/etc" is ONLY meant
# for manual overrides and editing by the machine's admin AFTER installation!
# See issue #28 (https://github.com/ublue-os/startingpoint/issues/28).
COPY usr /usr

COPY cosign.pub /usr/share/ublue-os/cosign.pub

COPY config /usr/share/ublue-os/startingpoint

# Copy the bling from ublue-os/bling into the image:
# * wallpapers
# * justfiles
# * nix installer
COPY --from=ghcr.io/ublue-os/bling:latest /rpms/ublue-os-wallpapers-0.1-1.fc38.noarch.rpm /tmp/ublue-os-wallpapers-0.1-1.fc38.noarch.rpm
COPY --from=ghcr.io/ublue-os/bling:latest /files/usr/share/ublue-os/just /usr/share/ublue-os/just
COPY --from=ghcr.io/ublue-os/bling:latest /files/usr/bin/ublue-nix* /usr/bin

# "yq" used in build.sh and the "setup-flatpaks" just-action to read recipe.yml.
# Copied from the official container image since it's not available as an RPM.
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

# Copy build script; this is what parses your recipe
COPY build.sh /tmp/build.sh

# Copy modules to a temporary directory, they'll only to be executed during the build
COPY modules /tmp/modules/

# Run the build script, then clean up temp files and finalize container build.
RUN chmod +x /tmp/build.sh && /tmp/build.sh && \
    rm -rf /tmp/* /var/* && ostree container commit

# Storage
# TODO turn this bling installation stuff into a module
# rpm-ostree install /tmp/ublue-os-wallpapers-0.1-1.fc38.noarch.rpm