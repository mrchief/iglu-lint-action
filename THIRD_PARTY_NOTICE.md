# Third Party Licenses and acknowledgements

This Github action uses third party packages in its Docker container. The following acknowledgements and licenses apply to the different components used within the action. The transitive dependencies of the components are not included.

## Acknowledgements

### Container base

Image: [node:lts-alpine3.11](https://hub.docker.com/layers/node/library/node/alpine3.11/images/sha256-662b812d33a75c70c3cdc146eb52d793a42ec5884e2c2614143b02e95ebacbfe?context=explore)\
License: MIT License\
More information at https://hub.docker.com/_/node/, under License

### Package managers

Manager: [npm](https://github.com/npm/cli)\
License: Artistic License 2.0\
https://github.com/npm/cli/blob/latest/LICENSE

### Packages

Package: [zaach/jsonlint](https://github.com/zaach/jsonlint)\
License: MIT License\
https://github.com/zaach/jsonlint#mit-license

Package: [igluctl](https://github.com/snowplow/iglu/tree/master/0-common/igluctl)\
License: Apache License 2.0
https://github.com/snowplow/iglu/blob/master/0-common/igluctl/LICENSE-2.0.txt

Package: [openjdk8-jre](https://pkgs.alpinelinux.org/package/v3.11/community/x86/openjdk8-jre)\
License: custom
https://git.alpinelinux.org/aports/tree/community/openjdk8/APKBUILD?h=3.11-stable#n13

Package: [jq](https://pkgs.alpinelinux.org/package/v3.11/main/x86/jq)\
License: MIT
https://github.com/stedolan/jq/blob/master/COPYING

Package: [curl](https://pkgs.alpinelinux.org/package/v3.11/main/x86/curl)\
License: MIT
https://git.alpinelinux.org/aports/tree/main/curl/APKBUILD?h=3.11-stable#n11

Package: [bash](https://pkgs.alpinelinux.org/package/v3.11/main/x86/bash)\
License: GPL-3.0-or-later
https://git.alpinelinux.org/aports/tree/main/bash/APKBUILD?h=3.11-stable#n13

Package: [ca-certificates](https://pkgs.alpinelinux.org/package/v3.11/main/x86/ca-certificates)\
License: MPL-2.0 GPL-2.0-or-later
https://git.alpinelinux.org/aports/tree/main/ca-certificates/APKBUILD?h=3.11-stable#n9
