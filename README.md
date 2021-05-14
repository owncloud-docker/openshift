# ownCloud: OpenShift

[![Build Status](https://img.shields.io/drone/build/owncloud-docker/openshift?logo=drone&server=https%3A%2F%2Fdrone.owncloud.com)](https://drone.owncloud.com/owncloud-docker/openshift)
[![GitHub contributors](https://img.shields.io/github/contributors/owncloud-docker/openshift)](https://github.com/owncloud-docker/openshift/graphs/contributors)
[![Source: GitHub](https://img.shields.io/badge/source-github-blue.svg?logo=github&logoColor=white)](https://github.com/owncloud-docker/openshift)
[![License: MIT](https://img.shields.io/github/license/owncloud-docker/openshift)](https://github.com/owncloud-docker/openshift/blob/master/LICENSE)

This repository stores some simple templates to deploy ownCloud on OpenShift. If you find an issue or if you got an idea how to improve the template feel free to open an issue on this repository.

## Usage

We provide 2 different templates, the `ephemeral.json` template provides an ownCloud installation without a persistent storage, this is useful for demo purposes, the other `persistent.json` template includes persistent volume claims and should be used for production workloads. After installing the template you should be able to find the templates within the regular OpenShift service catalogue.

```Shell
oc apply -n openshift -f https://raw.githubusercontent.com/owncloud-docker/openshift/master/owncloud-ephemeral.yml
oc apply -n openshift -f https://raw.githubusercontent.com/owncloud-docker/openshift/master/owncloud-persistent.yml
```

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/owncloud-docker/openshift/blob/master/LICENSE) file for details.

## Copyright

```Text
Copyright (c) 2021 ownCloud GmbH
```
