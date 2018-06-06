# ownCloud: OpenShift

This repository stores some simple templates to deploy ownCloud on OpenShift. If you find an issue or if you got an idea how to improve the template feel free to open an issue on this repository.


## Notice

Since our container requires root permissions you have to enable this permission specifically within OpenShift. You can enable this permission globally to all authenticated users via `oc adm policy add-scc-to-group anyuid system:authenticated`, or you can enable this specifically for ever project via `oc adm policy add-scc-to-user anyuid system:serviceaccount:<projectname>:owncloud`.


## Usage

We provide 2 different templates, the `ephemeral.json` template provides an ownCloud installation without a persistent storage, this is useful for demo purposes, the other `persistent.json` template includes persistent volume claims and should be used for production workloads. After installing the template you should be able to find the templates within the regular OpenShift service catalogue.

```
oc apply -n openshift -f https://raw.githubusercontent.com/owncloud-docker/openshift/master/ephemeral.json
oc apply -n openshift -f https://raw.githubusercontent.com/owncloud-docker/openshift/master/persistent.json
```


## Issues, Feedback and Ideas

Open an [Issue](https://github.com/owncloud-docker/openshift/issues)


## Contributing

Fork -> Patch -> Push -> Pull Request


## Authors

* [Thomas Boerger](https://github.com/tboerger)


## License

MIT


## Copyright

```
Copyright (c) 2018 Thomas Boerger <tboerger@owncloud.com>
```
