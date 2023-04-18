def main(ctx):
    return checkStarlark() + test() + rocketchat()

def checkStarlark():
    return [{
        "kind": "pipeline",
        "type": "docker",
        "name": "check-starlark",
        "steps": [
            {
                "name": "format-check-starlark",
                "image": "docker.io/owncloudci/bazel-buildifier",
                "pull": "always",
                "commands": [
                    "buildifier --mode=check .drone.star",
                ],
            },
            {
                "name": "show-diff",
                "image": "docker.io/owncloudci/bazel-buildifier",
                "pull": "always",
                "commands": [
                    "buildifier --mode=fix .drone.star",
                    "git diff",
                ],
                "when": {
                    "status": [
                        "failure",
                    ],
                },
            },
        ],
        "depends_on": [],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/pull/**",
            ],
        },
    }]

def test():
    return [{
        "kind": "pipeline",
        "type": "docker",
        "name": "test",
        "platform": {
            "os": "linux",
            "arch": "amd64",
        },
        "steps": [
            {
                "name": "lint",
                "image": "docker.io/owncloudci/alpine",
                "commands": [
                    "yamllint owncloud-*.yml",
                ],
            },
            {
                "name": "link-check",
                "image": "ghcr.io/tcort/markdown-link-check:3.11.0",
                "commands": [
                    "/src/markdown-link-check README.md",
                ],
            },
        ],
        "depends_on": [
            "check-starlark",
        ],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/tags/**",
                "refs/pull/**",
            ],
        },
    }]

def rocketchat():
    return [{
        "kind": "pipeline",
        "type": "docker",
        "name": "rocketchat",
        "platform": {
            "os": "linux",
            "arch": "amd64",
        },
        "clone": {
            "disable": True,
        },
        "steps": [
            {
                "name": "notify",
                "image": "docker.io/plugins/slack",
                "pull": "always",
                "failure": "ignore",
                "settings": {
                    "webhook": {
                        "from_secret": "public_rocketchat",
                    },
                    "channel": "docker",
                },
            },
        ],
        "depends_on": [
            "test",
        ],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/tags/**",
            ],
            "status": [
                "changed",
                "failure",
            ],
        },
    }]
