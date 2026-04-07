# dump

## DO NOT USE IN PRODUCTION

These are experimental scripts for dev testing only.

## Pre setup scripts

ran by root user on a fresh VPS ideally running Ubuntu 24.04

### root_presetup.sh

```sh
curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/root_presetup.sh?$(date +%s)" | bash
 ```

### root_presetup_cleanup.sh

```sh
curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/root_presetup_cleanup.sh?$(date +%s)" | bash
```

## Setup scripts

ran by normal user to install necessary packages and configure default software and settings.

### setup.sh

```sh
curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/setup.sh?$(date +%s)" | sudo -E bash
```

### cleanup.sh

```sh
curl -o- "https://raw.githubusercontent.com/boxctl/dump/refs/heads/main/cleanup.sh?$(date +%s)" | sudo -E bash
```
